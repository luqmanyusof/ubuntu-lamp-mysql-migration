# 10 — PHP Setup (PHP-FPM + Nginx)

**Goal:** Install **PHP-FPM** on `ubuntu-app`, wire it into Nginx so `.php` files actually execute, and install the MySQL driver so PHP can talk to the database on `ubuntu-old-db`. This completes the **P**.

**Time:** ~30 minutes

> All commands on **ubuntu-app**. Check your prompt says `student@ubuntu-app`.

---

## 1. How Nginx runs PHP — read this first

This is the one place Nginx genuinely differs from Apache, so it's worth 60 seconds.

Apache could execute PHP **inside itself** (the `mod_php` module). **Nginx cannot execute PHP at all.** Instead it hands the request to a **separate program** — **PHP-FPM** (FastCGI Process Manager) — which runs the code and hands back the HTML.

```
  Browser ──HTTP──► Nginx ──FastCGI──► PHP-FPM ──SQL──► MySQL on ubuntu-old-db
                     │       (Unix socket)  │
              serves .html,           executes .php
              .css, images
```

They talk over a **Unix socket** — a file on disk, at `/run/php/php8.3-fpm.sock`. Nothing listens on a network port, so this channel is not exposed to anyone.

The consequence you must remember: **two services now serve your site.** If you change PHP code, nothing needs restarting. If you change PHP *configuration* (`php.ini`), restart `php8.3-fpm` — restarting `nginx` will do nothing.

---

## 2. Install PHP-FPM + the pieces we need

```bash
$ sudo apt update
$ sudo apt install php-fpm php-mysql -y
```

What each part does:

- **`php-fpm`** — the PHP runtime *and* the FastCGI process manager Nginx talks to. (This replaces `libapache2-mod-php`.)
- **`php-mysql`** — the driver so PHP can connect to MySQL, including the **remote** MySQL on `ubuntu-old-db`.

Confirm the version:

```bash
$ php --version
PHP 8.3.x ...
```

📌 **Checkpoint:** `php --version` shows PHP 8.3.x (Ubuntu 24.04's default).

Confirm the FPM service is running, and note the exact socket path:

```bash
$ systemctl status php8.3-fpm        # look for: active (running)
$ ls -l /run/php/
srw-rw---- 1 www-data www-data 0 ... php8.3-fpm.sock
```

📌 **Checkpoint:** `php8.3-fpm` is active, and `php8.3-fpm.sock` exists in `/run/php/`.

> ⚠️ **Watch out:** the version number is **part of the socket filename**. On Ubuntu 24.04 it's `php8.3-fpm.sock`. If your `php --version` says something else, use *your* version everywhere below — a mismatch here is the #1 cause of the "502 Bad Gateway" we troubleshoot in §5.

---

## 3. Tell Nginx to hand `.php` files to PHP-FPM

Edit the default site:

```bash
$ sudo nano /etc/nginx/sites-available/default
```

Make **two** changes inside the `server { ... }` block.

**(a)** Add `index.php` to the front of the `index` line, so a request for `/` serves our app rather than the welcome page:

```nginx
    index index.php index.html index.htm;
```

**(b)** Add a `location` block that routes `.php` requests to the FPM socket. Put it just after the existing `location / { ... }` block:

```nginx
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.3-fpm.sock;
    }
```

The finished `server` block should look like this:

```nginx
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.php index.html index.htm;      # ← (a) index.php first

    server_name _;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {                        # ← (b) the PHP handoff
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.3-fpm.sock;
    }
}
```

Line by line:

| Line | What it does |
|------|--------------|
| `location ~ \.php$` | `~` = match by regular expression; this matches any path **ending in** `.php` |
| `include snippets/fastcgi-php.conf` | Ships with Nginx — sets the standard FastCGI variables (which script to run, etc.) so you don't hand-write them |
| `fastcgi_pass unix:/run/php/...sock` | **Where to send it** — the PHP-FPM socket from §2 |

Save (**Ctrl+O**, Enter) and exit (**Ctrl+X**).

Now **test the config before you reload** — the habit from file 09:

```bash
$ sudo nginx -t
nginx: configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful

$ sudo systemctl reload nginx
```

📌 **Checkpoint:** `nginx -t` reports **syntax is ok** / **test is successful**. If it points at a line number, you have a missing `;` or `}` — fix it before reloading.

---

## 4. Test that Nginx runs PHP

Create a temporary info page:

```bash
$ sudo nano /var/www/html/info.php
```

Type:

```php
<?php
phpinfo();
```

Save and exit. From your **Windows browser** (using the **192.168.56.x** host-only IP from file 09):

```
http://<app-IP>/info.php
```

You should see the purple **PHP information** page. Near the top, `Server API` reads **FPM/FastCGI** — proof the request went through PHP-FPM, not Nginx alone.

📌 **Checkpoint:** The `phpinfo()` page loads and shows `Server API: FPM/FastCGI`.

> ⚠️ **If the browser downloads a file instead of showing the page**, Nginx served the PHP as plain text — your `location ~ \.php$` block isn't matching. Re-check §3(b), then `sudo nginx -t && sudo systemctl reload nginx`.

> ⚠️ **Security:** `phpinfo()` reveals a lot about your server. **Delete it** as soon as you've confirmed PHP works:
> ```bash
> $ sudo rm /var/www/html/info.php
> ```

---

## 5. When it breaks: **502 Bad Gateway**

`502` is *the* Nginx+PHP error, and it means one specific thing: **Nginx could not reach PHP-FPM.** Nginx is fine; the handoff failed. Two causes, in order of likelihood:

```bash
# 1. Is the socket path in your config the one that actually exists?
$ ls /run/php/                                    # what exists
$ grep fastcgi_pass /etc/nginx/sites-available/default   # what you told Nginx
```
Those two **must match exactly**, version number included.

```bash
# 2. Is PHP-FPM even running?
$ systemctl status php8.3-fpm
$ sudo systemctl restart php8.3-fpm
```

And the log that tells you the truth:

```bash
$ sudo tail -n 20 /var/log/nginx/error.log
```

> **Lesson:** a `502` is never a PHP *code* error — a broken PHP script gives you a blank page or a `500`. `502` always means the **socket**: wrong path, or FPM is down.

---

## 6. Confirm the MySQL driver is present

```bash
$ php -m | grep -i mysql
mysqli
pdo_mysql
```

📌 **Checkpoint:** `php -m | grep mysql` lists `mysqli` and `pdo_mysql`.

> This confirms the *driver* is installed. It does **not** yet prove PHP can reach the database on `ubuntu-old-db` — that network connection is what file 11 sets up and tests.

---

## Done

PHP-FPM is installed, wired into Nginx, and has the MySQL driver. Next: **`11-sample-app.md`** — deploy a PHP page that reads real data from `ubuntu-old-db`.
