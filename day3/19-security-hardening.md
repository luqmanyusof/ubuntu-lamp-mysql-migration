# 19 — Security Hardening (Consolidated)

**Mode:** Hands-on / discussion
**Goal:** Pull together everything into one deliberate hardening pass across the whole stack — OS, SSH, firewall, MySQL, and web — and review the firewall thread as a whole.

**Time:** ~50 minutes

> Apply on **ubuntu-target** (and mirror the OS/SSH/firewall parts on `ubuntu-source`).

---

## 1. Operating system

Keep the system patched:

```bash
$ sudo apt update && sudo apt upgrade -y
```

Enable **automatic security updates**:

```bash
$ sudo apt install unattended-upgrades -y
$ sudo dpkg-reconfigure --priority=low unattended-upgrades   # choose Yes
```

Discussion: minimal install = smaller attack surface. Don't install packages you don't need.

📌 **Checkpoint:** System fully patched; unattended-upgrades enabled.

---

## 2. SSH hardening

Edit the SSH server config:

```bash
$ sudo nano /etc/ssh/sshd_config
```

Recommended changes:

```
PermitRootLogin no
PasswordAuthentication no        # only after you've set up SSH keys! (Day 1 lab 05 B3)
MaxAuthTries 3
```

> ⚠️ **Do not set `PasswordAuthentication no` until key-based login works**, or you'll lock yourself out. Test keys first.

Apply and verify (keep a second session open as a safety net):

```bash
$ sudo systemctl restart ssh
$ sudo systemctl status ssh
```

📌 **Checkpoint:** Root SSH disabled; (if keys are set up) password auth disabled; you can still log in with your key.

---

## 3. Firewall — the consolidated review

This is where the **firewall thread** comes together. Review the full posture:

```bash
$ sudo ufw status verbose
```

The intended rule set across the course:

| Port | Service | Rule | Added |
|------|---------|------|-------|
| 22 | SSH | `ALLOW` (optionally from admin IPs only) | Day 1 |
| 80/443 | Apache | `ALLOW` (Apache Full) | Day 2 AM |
| 3306 | MySQL | `ALLOW from <source-IP>` **only** (if opened at all) | Day 2 PM |

**Principle of least exposure — act on it now:**

- The migration is done. If you opened **3306**, **close it again** — nothing external needs it anymore:
  ```bash
  $ sudo ufw status numbered
  $ sudo ufw delete <number-of-the-3306-rule>
  ```
- Consider restricting **SSH** to known admin IPs instead of Anywhere:
  ```bash
  $ sudo ufw delete allow OpenSSH
  $ sudo ufw allow from <your-admin-IP> to any port 22 proto tcp
  ```
- Confirm defaults: `deny incoming`, `allow outgoing`:
  ```bash
  $ sudo ufw default deny incoming
  $ sudo ufw default allow outgoing
  ```

📌 **Checkpoint:** Only the ports you actually need are open; 3306 is closed again post-migration; defaults deny inbound.

---

## 4. MySQL hardening (recap + additions)

Re-confirm the Day 2 basics and add a few:

- ✅ `mysql_secure_installation` was run (anon users removed, test DB gone, remote root off).
- ✅ Apps use **least-privilege** users, never root.
- **Keep MySQL bound to localhost** unless a remote client genuinely needs it:
  ```bash
  $ grep bind-address /etc/mysql/mysql.conf.d/mysqld.cnf   # expect 127.0.0.1
  ```
- Audit accounts and privileges:
  ```sql
  mysql> SELECT user, host FROM mysql.user;                 -- any unexpected accounts/hosts?
  mysql> SELECT user, host FROM mysql.user WHERE host='%';  -- flag wide-open hosts
  ```
- Remove any leftover migration/test users no longer needed (`DROP USER ...`).

📌 **Checkpoint:** MySQL bound to localhost; no unexpected or wildcard-host accounts; least privilege confirmed.

---

## 5. Web / PHP hardening

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
- **Credentials outside web root** — confirm `appconfig.php` is not under `/var/www/html` and is `640` (we did this in file 11).
- **App code** uses prepared statements + `htmlspecialchars` (SQL injection / XSS defenses, file 11).
- **HTTPS** — discussion: for production, add TLS (e.g. Let's Encrypt / `certbot`). We note it; the classroom uses HTTP.

📌 **Checkpoint:** No phpinfo files; server banners minimized; app credentials protected.

---

## 6. Final snapshot

Take the course's final snapshot on **both** VMs:

- Name: **`day3-complete`**
- Description: `Migration finished, validated, and hardened`

---

## Hardening scorecard

- [ ] OS patched + auto-updates on
- [ ] Root SSH off; key auth (and password auth off) working
- [ ] Firewall reviewed; least exposure; 3306 closed post-migration
- [ ] MySQL localhost-bound; least-privilege accounts; no wildcard hosts
- [ ] Web: no info leaks; banners minimized; secure app patterns
- [ ] `day3-complete` snapshot taken

Next: **`20-troubleshooting-workshop.md`** — practise fixing things that break.
