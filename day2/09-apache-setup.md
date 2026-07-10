# 09 — Apache Setup

**Goal:** Install the **Apache** web server on ubuntu-app, open the firewall for web traffic, and serve a page you can see from your Windows browser.

**Time:** ~25 minutes

> All commands on **ubuntu-app**. Check your prompt says `student@ubuntu-app` — MySQL stays on `ubuntu-db`; the web tier lives here. This is the **A** in LAMP.

---

## 1. Install Apache

```bash
$ sudo apt update
$ sudo apt install apache2 -y
```

Confirm it's running:

```bash
$ sudo systemctl status apache2
```

Look for **active (running)** and **enabled**.

📌 **Checkpoint:** Apache service is active and enabled.

---

## 2. Firewall thread — open the web ports

Apache needs ports **80 (HTTP)** and **443 (HTTPS)**. UFW knows Apache by name. First, see the profiles UFW offers:

```bash
$ sudo ufw app list
```

You'll see `Apache`, `Apache Full`, `Apache Secure`. We use **Apache Full** (80 + 443):

```bash
$ sudo ufw allow 'Apache Full'
$ sudo ufw status
```

Expected rules now include SSH (from Day 1) **and** Apache Full:

```
To                         Action      From
--                         ------      ----
22/tcp (OpenSSH)           ALLOW IN    Anywhere
Apache Full                ALLOW IN    Anywhere
```

📌 **Checkpoint:** `ufw status` lists both OpenSSH and Apache Full.

> **Firewall thread so far:** Day 1 opened SSH (22) on both VMs; on `ubuntu-db` you opened MySQL (3306) *from this app server's IP only* (file 08); now on `ubuntu-app` you open web (80/443). Each machine exposes only what its role requires.

---

## 3. View the default page from Windows

Find the app server's IP:

```bash
$ ip a | grep inet
```

On your **Windows host**, open a browser and go to:

```
http://<app-IP>
```

You should see the **"Apache2 Ubuntu Default Page"**.

📌 **Checkpoint:** The Apache default page loads in your Windows browser. If it doesn't:
- Confirm you used `http://` (not https).
- Re-check `ufw status` includes Apache Full.
- Confirm the IP with `ip a`.

---

## 4. Understand the web root

Apache serves files from **`/var/www/html`** by default:

```bash
$ ls -l /var/www/html
```

You'll see `index.html` — that's the default page. Our PHP app (file 11) will live here too.

The main site config is:

```bash
$ cat /etc/apache2/sites-available/000-default.conf
```

Key line: `DocumentRoot /var/www/html`.

---

## 5. Useful Apache commands (reference)

```bash
$ sudo systemctl restart apache2     # restart after config changes
$ sudo systemctl reload apache2      # reload config without dropping connections
$ sudo apachectl configtest          # check config syntax before restarting
$ sudo tail -f /var/log/apache2/error.log    # watch errors live
$ sudo tail -f /var/log/apache2/access.log   # watch requests live
```

> **Tip:** After any config change, run `sudo apachectl configtest` **before** restarting. It catches typos so you don't take the server down.

---

## Done

Apache serves pages and the firewall allows web traffic. Next: **`10-php-setup.md`** — add PHP so Apache can run dynamic pages.
