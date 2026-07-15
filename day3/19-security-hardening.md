# 19 — Security Hardening (Consolidated)

**Mode:** Hands-on / discussion
**Goal:** Pull everything into one deliberate hardening pass across **all three servers** — OS, SSH, firewall, MySQL, and web — and review the firewall thread as a whole.

**Time:** ~50 minutes

> This lab spans **all three** VMs. Apply the OS/SSH/firewall parts on **`ubuntu-app`, `ubuntu-old-db`, and `ubuntu-new-db`**; the MySQL parts on **both** database VMs; the web/PHP parts on `ubuntu-app`. Watch your prompt.

---

## 1. Operating system (both VMs)

Keep each system patched:

```bash
$ sudo apt update && sudo apt upgrade -y
```

Enable **automatic security updates** on both:

```bash
$ sudo apt install unattended-upgrades -y
$ sudo dpkg-reconfigure --priority=low unattended-upgrades   # choose Yes
```

Discussion: minimal install = smaller attack surface. The **database VMs** in particular should run **only** MySQL — no web server, no extra packages.

📌 **Checkpoint:** All three VMs patched; unattended-upgrades enabled on each.

---

## 2. SSH hardening (both VMs)

Edit the SSH server config on each:

```bash
$ sudo nano /etc/ssh/sshd_config
```

Recommended changes:

```
PermitRootLogin no
PasswordAuthentication no        # only after you've set up SSH keys! (Day 1 lab 05 B3)
MaxAuthTries 3
```

> ⚠️ **Do not set `PasswordAuthentication no` until key-based login works** on that VM, or you'll lock yourself out. Test keys first, keep a second session open.

Apply and verify:

```bash
$ sudo systemctl restart ssh
$ sudo systemctl status ssh
```

📌 **Checkpoint:** On both VMs: root SSH disabled; (if keys set up) password auth disabled; you can still log in with your key.

---

## 3. Firewall — the consolidated review

This is where the **firewall thread** comes together. Each machine exposes only what its role needs. Review all three:

```bash
$ sudo ufw status verbose     # run on each VM
```

The intended posture across the course:

| VM | Port | Service | Rule |
|----|------|---------|------|
| all three | 22 | SSH | `ALLOW` (optionally from admin IPs only) |
| `ubuntu-app` | 80/443 | Nginx | `ALLOW` (Nginx Full) |
| `ubuntu-old-db` | 3306 | MySQL | `ALLOW from <app-IP>` **only** |
| `ubuntu-new-db` | 3306 | MySQL | `ALLOW from <app-IP>` **only** |

**Principle of least exposure — act on it now:**

- On **both database VMs**, confirm 3306 is open to the **app server only**, never `Anywhere`:
  ```bash
  $ sudo ufw status               # the 3306 line must show From = <app-IP>
  ```
  > Unlike a one-off migration port, this rule is **permanent** — the app depends on it. The hardening goal here is not to close 3306 but to keep it **tightly scoped** to exactly `ubuntu-app`. If you see `3306 ALLOW Anywhere`, fix it:
  > ```bash
  > $ sudo ufw status numbered
  > $ sudo ufw delete <number-of-the-wide-3306-rule>
  > $ sudo ufw allow from <app-IP> to any port 3306 proto tcp
  > ```
- Consider restricting **SSH** to known admin IPs on both VMs:
  ```bash
  $ sudo ufw delete allow OpenSSH
  $ sudo ufw allow from <your-admin-IP> to any port 22 proto tcp
  ```
- Confirm defaults on both: `deny incoming`, `allow outgoing`:
  ```bash
  $ sudo ufw default deny incoming
  $ sudo ufw default allow outgoing
  ```

> ⚠️ **`ubuntu-new-db`'s rule was added at cutover (file 14).** A recently-provisioned database server is the one most likely to be missing this scoping, or to have a leftover wide-open rule from the copy — check it as carefully as `old-db`. If you used copy method 3, also remove the temporary `copyuser` rule that let `new-db` reach `old-db`; it's not needed after the copy.

📌 **Checkpoint:** `ubuntu-app` exposes only 22 + 80/443; **both** database VMs expose only 22 + 3306-from-app-IP; all three default-deny inbound.

---

## 4. MySQL hardening (on **both** database VMs)

Re-confirm the Day 2 basics and add a few — on `ubuntu-old-db` *and* `ubuntu-new-db`:

- ✅ `mysql_secure_installation` was run on **each** (anon users removed, test DB gone, remote root off).
- ✅ The app uses a **least-privilege** user (`appuser` with only `SELECT, INSERT`), never root.
- **On network binding:** MySQL is *intentionally* bound to the network (`0.0.0.0`) so the app can reach it. That is fine **because** two other layers restrict access — the firewall (3306 from `<app-IP>` only) and the user host (`'appuser'@'<app-IP>'`). Confirm both are still true on each server:
  ```bash
  $ grep bind-address /etc/mysql/mysql.conf.d/mysqld.cnf   # 0.0.0.0 (network) — protected by firewall + user host
  $ sudo ufw status | grep 3306                            # ALLOW from <app-IP> only
  ```
- Audit accounts and privileges — flag anything wide-open:
  ```sql
  mysql> SELECT user, host FROM mysql.user;                 -- any unexpected accounts/hosts?
  mysql> SELECT user, host FROM mysql.user WHERE host='%';  -- flag any wildcard-host accounts
  ```
- Confirm the app user is scoped to the app IP, **not** `%`:
  ```sql
  mysql> SELECT user, host FROM mysql.user WHERE user='appuser';   -- host should be <app-IP> (or your subnet)
  ```
- Drop any leftover test/reporting users no longer needed (`DROP USER ...`). **In particular, on `ubuntu-old-db` drop the `copyuser` account** if you created it for copy method 3 — it was a one-time tool for the migration and should not outlive it:
  ```sql
  mysql> DROP USER IF EXISTS 'copyuser'@'<new-db-IP>';   -- on ubuntu-old-db
  ```

📌 **Checkpoint:** Both MySQL servers reachable only from the app server (firewall + user host); no unexpected or wildcard-host accounts; the migration's `copyuser` removed; least privilege confirmed.

> **Discussion — going further:** for production you'd add **TLS** on the app↔DB connection (`REQUIRE SSL` on the user, certs on the server) so the traffic between the servers is encrypted, not just access-controlled. We note it; the classroom uses a trusted LAN.

---

## 5. Web / PHP hardening (on `ubuntu-app`)

- **Remove info leaks:** ensure `info.php` / any `phpinfo()` files are gone:
  ```bash
  $ find /var/www -name '*.php' -exec grep -l phpinfo {} \;
  ```
- **Hide the version banner** — stop Nginx advertising its version in headers and error pages:
  ```bash
  $ sudo nano /etc/nginx/nginx.conf
  ```
  In the `http { ... }` block, uncomment (or add):
  ```nginx
  server_tokens off;
  ```
  ```bash
  $ sudo nginx -t && sudo systemctl reload nginx
  ```
  Verify: `curl -I http://<app-IP>/` should show `Server: nginx` with **no version number**.
- **Credentials outside web root** — confirm `appconfig.php` is not under `/var/www/html` and is `640`, owned `root:www-data` (file 11).
- **App code** uses prepared statements + `htmlspecialchars` (SQL injection / XSS defenses, file 11).
- **HTTPS** — discussion: for production, add TLS to the web tier (e.g. Let's Encrypt / `certbot`). We note it; the classroom uses HTTP.

📌 **Checkpoint:** No phpinfo files; server banners minimized; app credentials protected.

---

## 6. Final snapshot

Take the course's final snapshot on **all three** VMs:

- Name: **`day3-complete`**
- Description: `Nginx+PHP app, MySQL 8 copied old-db→new-db, hardened, firewall scoped`

---

## Hardening scorecard

- [ ] All three VMs patched + auto-updates on
- [ ] Root SSH off on all three; key auth (and password auth off) working
- [ ] `ubuntu-app`: only 22 + 80/443 open
- [ ] **Both** database VMs: only 22 + 3306-from-app-IP open (never `Anywhere`); temporary `copyuser` firewall rule removed
- [ ] MySQL access restricted by firewall **and** user host on both DB VMs; no wildcard accounts; `copyuser` dropped
- [ ] Web: no info leaks; Nginx banner minimized; secure app patterns
- [ ] `day3-complete` snapshot taken on all three VMs

Next: **`20-troubleshooting-workshop.md`** — practise fixing things that break.
