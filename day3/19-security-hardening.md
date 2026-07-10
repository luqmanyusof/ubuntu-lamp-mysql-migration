# 19 — Security Hardening (Two-Tier, Consolidated)

**Mode:** Hands-on / discussion
**Goal:** Pull everything into one deliberate hardening pass across the **whole two-tier stack** — OS, SSH, firewall, MySQL, and web — and review the firewall thread as a whole.

**Time:** ~50 minutes

> This lab spans **both** VMs. Apply the OS/SSH/firewall parts on **both** `ubuntu-app` and `ubuntu-db`; the MySQL parts on `ubuntu-db`; the web/PHP parts on `ubuntu-app`. Watch your prompt.

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

Discussion: minimal install = smaller attack surface. `ubuntu-db` in particular should run **only** MySQL — no web server, no extra packages.

📌 **Checkpoint:** Both VMs patched; unattended-upgrades enabled on each.

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

## 3. Firewall — the consolidated two-tier review

This is where the **firewall thread** comes together. Each machine exposes only what its role needs. Review both:

```bash
$ sudo ufw status verbose     # run on each VM
```

The intended posture across the course:

| VM | Port | Service | Rule |
|----|------|---------|------|
| both | 22 | SSH | `ALLOW` (optionally from admin IPs only) |
| `ubuntu-app` | 80/443 | Apache | `ALLOW` (Apache Full) |
| `ubuntu-db` | 3306 | MySQL | `ALLOW from <app-IP>` **only** |

**Principle of least exposure — act on it now:**

- On **`ubuntu-db`**, confirm 3306 is open to the **app server only**, never `Anywhere`:
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

📌 **Checkpoint:** `ubuntu-app` exposes only 22 + 80/443; `ubuntu-db` exposes only 22 + 3306-from-app-IP; both default-deny inbound.

---

## 4. MySQL hardening (on `ubuntu-db`)

Re-confirm the Day 2 basics and add a few:

- ✅ `mysql_secure_installation` was run (anon users removed, test DB gone, remote root off).
- ✅ The app uses a **least-privilege** user (`appuser`), never root.
- **On network binding — the two-tier reality:** MySQL here is *intentionally* bound to the network (`0.0.0.0`) so the app can reach it. That is fine **because** two other layers restrict access — the firewall (3306 from `<app-IP>` only) and the user host (`'appuser'@'<app-IP>'`). Confirm both are still true:
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
- Drop any leftover test/reporting users no longer needed (`DROP USER ...`).

📌 **Checkpoint:** MySQL reachable only from the app server (firewall + user host); no unexpected or wildcard-host accounts; least privilege confirmed.

> **Discussion — going further:** for production you'd add **TLS** on the app↔DB connection (`REQUIRE SSL` on the user, certs on the server) so the traffic between the two servers is encrypted, not just access-controlled. We note it; the classroom uses a trusted LAN.

---

## 5. Web / PHP hardening (on `ubuntu-app`)

- **Remove info leaks:** ensure `info.php` / any `phpinfo()` files are gone:
  ```bash
  $ find /var/www -name '*.php' -exec grep -l phpinfo {} \;
  ```
- **Hide version banners** — reduce what Apache advertises:
  ```bash
  $ sudo nano /etc/apache2/conf-enabled/security.conf
  ```
  ```
  ServerTokens Prod
  ServerSignature Off
  ```
  ```bash
  $ sudo systemctl reload apache2
  ```
- **Credentials outside web root** — confirm `appconfig.php` is not under `/var/www/html` and is `640` (file 11).
- **App code** uses prepared statements + `htmlspecialchars` (SQL injection / XSS defenses, file 11).
- **HTTPS** — discussion: for production, add TLS to the web tier (e.g. Let's Encrypt / `certbot`). We note it; the classroom uses HTTP.

📌 **Checkpoint:** No phpinfo files; server banners minimized; app credentials protected.

---

## 6. Final snapshot

Take the course's final snapshot on **both** VMs:

- Name: **`day3-complete`**
- Description: `Two-tier LAMP: migrated-DB knowledge, hardened, firewall scoped`

---

## Hardening scorecard

- [ ] Both VMs patched + auto-updates on
- [ ] Root SSH off on both; key auth (and password auth off) working
- [ ] `ubuntu-app`: only 22 + 80/443 open
- [ ] `ubuntu-db`: only 22 + 3306-from-app-IP open (never `Anywhere`)
- [ ] MySQL access restricted by firewall **and** user host; no wildcard accounts
- [ ] Web: no info leaks; banners minimized; secure app patterns
- [ ] `day3-complete` snapshot taken on both VMs

Next: **`20-troubleshooting-workshop.md`** — practise fixing things that break.
