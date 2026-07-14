# 09 — Nginx Setup

**Goal:** Install the **Nginx** web server on `ubuntu-app`, open the firewall for web traffic, and serve a page you can see from your Windows browser.

**Time:** ~25 minutes

> All commands on **ubuntu-app**. Check your prompt says `student@ubuntu-app` — the databases live on `ubuntu-old-db` and `ubuntu-new-db`; the web tier lives here.

---

## 1. Install Nginx

```bash
$ sudo apt update
$ sudo apt install nginx -y
```

Confirm it's running:

```bash
$ sudo systemctl status nginx
```

Look for **active (running)** and **enabled**.

📌 **Checkpoint:** Nginx service is active and enabled.

> ⚠️ **Watch out:** Nginx and Apache both want port 80. If Apache was ever installed on this VM, Nginx will fail to start with *"Address already in use"*. Fix it with:
> ```bash
> $ sudo systemctl disable --now apache2
> $ sudo systemctl restart nginx
> ```

---

## 2. Firewall thread — open the web ports

Nginx needs ports **80 (HTTP)** and **443 (HTTPS)**. UFW ships profiles for it. First, see what's on offer:

```bash
$ sudo ufw app list
```

You'll see `Nginx HTTP`, `Nginx HTTPS`, `Nginx Full`. We use **Nginx Full** (80 + 443):

```bash
$ sudo ufw allow 'Nginx Full'
$ sudo ufw status
```

Expected rules now include SSH (from Day 1) **and** Nginx Full:

```
To                         Action      From
--                         ------      ----
22/tcp (OpenSSH)           ALLOW IN    Anywhere
Nginx Full                 ALLOW IN    Anywhere
```

📌 **Checkpoint:** `ufw status` lists both OpenSSH and Nginx Full.

> **Firewall thread so far:** Day 1 opened SSH (22) on every VM; on the database VM you opened MySQL (3306) *from this app server's IP only* (file 08); now on `ubuntu-app` you open web (80/443). Each machine exposes only what its role requires.

---

## 3. View the default page from Windows

Find the app server's IP:

```bash
$ ip -4 addr show
```

You'll see **two** addresses, because each VM has two network adapters:

| Interface | Address | Adapter | What it's for |
|-----------|---------|---------|---------------|
| `enp0s3` | `10.0.2.15` | NAT | Internet access (`apt`). **Same on every VM — never use it.** |
| `enp0s8` | `192.168.56.x` | Host-Only | Talking to your Windows host and the other VMs. **This is the one you want.** |

> ⚠️ **Watch out — the single most common mix-up in this course.** `10.0.2.15` appears identically on `ubuntu-app`, `ubuntu-old-db` and `ubuntu-new-db`; it's a private NAT address that nothing outside the VM can reach. Whenever a guide says `<app-IP>` or `<db-IP>`, it always means the **`192.168.56.x`** host-only address.

To print just the address you want:

```bash
$ ip -4 addr show enp0s8 | grep inet
    inet 192.168.56.101/24 ...     # ← this is your <app-IP>
```

Write it down — files 10 and 11 need it, and `ubuntu-old-db`'s firewall will be scoped to exactly this IP.

On your **Windows host**, open a browser and go to:

```
http://<app-IP>          e.g. http://192.168.56.101
```

You should see **"Welcome to nginx!"**.

📌 **Checkpoint:** The Nginx welcome page loads in your Windows browser. If it doesn't:
- Confirm you used `http://` (not https).
- Confirm you used the **`192.168.56.x`** address, not `10.0.2.15`.
- Re-check `ufw status` includes Nginx Full.

---

## 4. Understand the web root and the site config

Nginx serves files from **`/var/www/html`** by default:

```bash
$ ls -l /var/www/html
```

You'll see `index.nginx-debian.html` — that's the welcome page. Our PHP app (file 11) will live here too.

Nginx sites work like Apache's: definitions in `sites-available`, symlinks in `sites-enabled`.

```bash
$ ls -l /etc/nginx/sites-enabled/
$ cat /etc/nginx/sites-available/default
```

The important parts of that file:

```nginx
server {
    listen 80 default_server;
    root /var/www/html;                 # where files are served from
    index index.html index.htm;         # what to serve for "/"
    server_name _;

    location / {
        try_files $uri $uri/ =404;      # find the file, else 404
    }
}
```

Three ideas to hold on to — we edit all three in file 10:

| Directive | Means |
|-----------|-------|
| `root` | The document root — the folder on disk that maps to `/` |
| `index` | Which file answers a request for a directory |
| `location` | A rule block matched against the request path |

> **Apache → Nginx translation** (useful if you've used Apache before):
> | Apache | Nginx |
> |--------|-------|
> | `DocumentRoot` | `root` |
> | `.htaccess` | *(no equivalent — all config is in the server block)* |
> | `a2ensite` / `a2dissite` | symlink in/out of `sites-enabled` |
> | `apachectl configtest` | `nginx -t` |

---

## 5. Useful Nginx commands (reference)

```bash
$ sudo nginx -t                            # check config syntax — ALWAYS before restart
$ sudo systemctl reload nginx              # apply config without dropping connections
$ sudo systemctl restart nginx             # full restart
$ sudo tail -f /var/log/nginx/error.log    # watch errors live
$ sudo tail -f /var/log/nginx/access.log   # watch requests live
```

> **Tip:** Run `sudo nginx -t` **before** every reload. It prints `syntax is ok` / `test is successful`, or points at the exact line that's wrong — so a typo never takes the site down.

---

## Done

Nginx serves pages and the firewall allows web traffic. Next: **`10-php-setup.md`** — add PHP-FPM so Nginx can run dynamic pages.
