# 10 — PHP Setup

**Goal:** Install **PHP** on ubuntu-app, wire it into Apache, and install the MySQL driver so PHP can talk to the database on `ubuntu-db`. This completes the **P**.

**Time:** ~25 minutes

> All commands on **ubuntu-app**. Check your prompt says `student@ubuntu-app`.

---

## 1. Install PHP + the pieces we need

```bash
$ sudo apt update
$ sudo apt install php libapache2-mod-php php-mysql -y
```

What each part does:

- **`php`** — the PHP language runtime.
- **`libapache2-mod-php`** — lets Apache execute PHP files.
- **`php-mysql`** — the driver so PHP can connect to MySQL (including the **remote** MySQL on `ubuntu-db`).

Confirm the version:

```bash
$ php --version
PHP 8.x ...
```

📌 **Checkpoint:** `php --version` shows PHP 8.x.

---

## 2. Restart Apache to load PHP

```bash
$ sudo systemctl restart apache2
```

---

## 3. Test that Apache runs PHP

Create a temporary info page:

```bash
$ sudo nano /var/www/html/info.php
```

Type:

```php
<?php
phpinfo();
```

Save (**Ctrl+O**, Enter) and exit (**Ctrl+X**).

From your **Windows browser**:

```
http://<app-IP>/info.php
```

You should see the purple **PHP information** page.

📌 **Checkpoint:** The `phpinfo()` page loads.

> ⚠️ **Security:** `phpinfo()` reveals a lot about your server. **Delete it** as soon as you've confirmed PHP works:
> ```bash
> $ sudo rm /var/www/html/info.php
> ```

---

## 4. Confirm the MySQL driver is present

On the phpinfo page (before deleting it) you could search for a **`mysqli`** or **`pdo_mysql`** section — its presence means the driver loaded. Or check from the command line:

```bash
$ php -m | grep -i mysql
```

You should see `mysqli` and `pdo_mysql` listed.

📌 **Checkpoint:** `php -m | grep mysql` lists `mysqli` and/or `pdo_mysql`.

> This confirms the *driver* is installed. It does **not** yet prove PHP can reach the database on `ubuntu-db` — that network connection is what file 11 sets up and tests.

---

## 5. Make sure index.php is preferred (optional but tidy)

By default Apache serves `index.html` before `index.php`. Since our app is `index.php`, either delete the default HTML (we do this in file 11) or adjust the priority. We'll simply remove the default `index.html` in the next lab, so no config change is needed here.

---

## 6. The LAMP stack — spread across two machines

```
             ubuntu-app                         ubuntu-db
L — Linux     (Ubuntu Server) ✅ Day 1           (Ubuntu Server) ✅ Day 1
A — Apache    (web server)    ✅ file 09
P — PHP       (app language)  ✅ this file
M — MySQL 8                                       (database) ✅ file 07–08
```

This is the same **LAMP** stack — just with the **M** on its own server. Everything is installed; next we prove the app tier and the database tier work **together across the network**.

---

## Done

PHP is installed and connected to Apache and MySQL. Next: **`11-sample-app.md`** — deploy a real one-page app.
