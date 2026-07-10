# 20 — Troubleshooting Workshop

**Mode:** Hands-on / discussion
**Goal:** Build diagnostic instinct. Instead of new material, you work through **realistic broken scenarios** using a repeatable method — the skill that matters most after the course ends.

**Time:** ~60 minutes

> Use a snapshot (`day3-complete` or `day2-two-tier`) so you can break things freely and roll back. **Take a snapshot before deliberately breaking anything.** Scenarios span both `ubuntu-app` and `ubuntu-db` — watch which VM each step is on.

---

## 1. The troubleshooting method (use it every time)

1. **Reproduce** — make the failure happen on demand.
2. **Read the error** — the actual message, not your guess of it.
3. **Check the logs** — the service log almost always says more.
4. **Isolate the layer** — is it network, service, auth, config, or data?
5. **Change one thing** — test, observe, revert if it didn't help.
6. **Confirm the fix** — reproduce the original test; it should now pass.

Key logs to reach for:

```bash
$ sudo journalctl -xe                          # system-wide recent errors
$ sudo tail -n 50 /var/log/mysql/error.log     # MySQL
$ sudo tail -n 50 /var/log/apache2/error.log   # Apache/PHP
$ sudo tail -n 50 /var/log/auth.log            # SSH/login/sudo
```

---

## 2. Scenario A — "I can't SSH in anymore"

**Break it (instructor):** enable UFW without allowing SSH, or restrict SSH to a wrong IP.

**Diagnose:**
- From Windows: `ssh student@<IP>` → connection refused/timeout.
- On the VM console: `sudo ufw status` → is 22 allowed? `systemctl status ssh` → is it running?

**Fix:**
```bash
$ sudo ufw allow OpenSSH
$ sudo systemctl enable --now ssh
```
**Confirm:** reconnect from Windows.

> Lesson: this is exactly why Day 1 taught *allow SSH before enabling UFW*.

---

## 3. Scenario B — "The website shows a 500 / blank page"

*(App config + code live on `ubuntu-app`.)*

**Break it:** put a wrong password in `/var/www/appconfig.php`, or a PHP syntax error in `index.php`.

**Diagnose (on `ubuntu-app`):**
```bash
$ sudo tail -n 30 /var/log/apache2/error.log
```
Look for `Database connection failed` (bad credentials) or `PHP Parse error` (syntax).

**Fix:** correct the credential or the syntax; then:
```bash
$ sudo apachectl configtest && sudo systemctl reload apache2
```
**Confirm:** reload the page.

---

## 3b. Scenario B2 — "The app can't reach the database server" (the two-tier classic)

This is the failure unique to a two-tier setup: the code is fine, but `ubuntu-app` can't talk to MySQL on `ubuntu-db`.

**Break it (pick one, on `ubuntu-db`):** remove the firewall rule (`sudo ufw delete` the 3306 line), or set `bind-address = 127.0.0.1` and restart MySQL, or change the app user's host so it no longer matches the app IP.

**Diagnose — work outward-in from `ubuntu-app`:**
```bash
$ nc -zv <db-IP> 3306        # port reachable? timeout = firewall/bind problem
$ mysql -h <db-IP> -u appuser -p appdb   # isolates auth from PHP
```
- `nc` **times out** → firewall closed to this app, or MySQL bound to localhost.
- `nc` succeeds but login says `Access denied for 'appuser'@'<app-IP>'` → user host mismatch.

**Fix (on `ubuntu-db`, matching the cause):**
```bash
$ sudo ufw allow from <app-IP> to any port 3306 proto tcp   # firewall
# or set bind-address = 0.0.0.0 in mysqld.cnf, then:
$ sudo systemctl restart mysql
```
```sql
-- or repair the user host:
mysql> RENAME USER 'appuser'@'wrong' TO 'appuser'@'<app-IP>';
mysql> FLUSH PRIVILEGES;
```
**Confirm:** `nc` succeeds, the `mysql -h` login works, then the web page loads.

> Lesson: three layers must line up — **firewall → bind-address → user host** (file 08 §5). Test them in that order and the fault localizes itself.

---

## 4. Scenario C — "MySQL won't start after a config change" (on `ubuntu-db`)

**Break it:** add an invalid line to `mysqld.cnf` (e.g. `innodb_buffer_pool_size = 999G`).

**Diagnose:**
```bash
$ sudo systemctl status mysql            # failed
$ sudo tail -n 30 /var/log/mysql/error.log   # the real reason
```

**Fix:** revert the bad line, then:
```bash
$ sudo systemctl restart mysql
```
**Confirm:** `systemctl status mysql` → active (running).

> Lesson: change one setting at a time; always check status + error log after restart.

---

## 5. Scenario D — "App can't connect: authentication plugin" (on `ubuntu-db`)

**Break it:** create a user with `caching_sha2_password` and connect with an old client/driver that doesn't support it.

**Diagnose:** error mentions `caching_sha2_password`. Check the account:
```sql
mysql> SELECT user, host, plugin FROM mysql.user WHERE user='legacyapp';
```

**Fix (compatibility):**
```sql
mysql> ALTER USER 'legacyapp'@'<app-IP>'
       IDENTIFIED WITH mysql_native_password BY 'Str0ng!';
mysql> FLUSH PRIVILEGES;
```
**Confirm:** the client connects.

> Lesson: the #1 real-world 5→8 migration gotcha (file 15 §1) — and it can bite a two-tier app too if the app's MySQL driver is old.

---

## 6. Scenario E — "Import failed on a reserved word"

**Break it:** import a small dump containing a column named `` `rank` `` unquoted.

**Diagnose:** `ERROR 1064 ... near 'rank'`.

**Fix:** quote or rename in the dump/schema:
```sql
ALTER TABLE players CHANGE `rank` player_rank INT;
```
**Confirm:** re-run the import; no error.

---

## 7. Scenario F — "Website unreachable from Windows, but curl on the VM works"

**Break it:** remove the Apache firewall rule.

**Diagnose:**
```bash
# On the VM — proves the app itself is fine:
$ curl -I http://localhost
# From Windows — fails → it's a network/firewall layer issue
$ sudo ufw status        # Apache Full missing?
```

**Fix:**
```bash
$ sudo ufw allow 'Apache Full'
```
**Confirm:** browser on Windows loads the page.

> Lesson: isolate the layer — "works locally, fails remotely" points at firewall/network, not the app.

---

## 8. Wrap-up: your standing checklist

When anything breaks, in order:

1. What exactly is the symptom? (reproduce)
2. What does the error say? (read it literally)
3. What do the logs say? (`journalctl`, service logs)
4. Which layer? (network / service / auth / config / data)
5. One change, test, confirm.

📌 **Course complete.** You can install and secure Ubuntu, build a **two-tier** LAMP stack (app and DB on separate servers, linked over a scoped network path), administer and harden it, understand how a MySQL 5.x → 8 migration is planned and validated, and diagnose failures methodically.

> **Trainer note (Luqman):** Pick the scenarios that match the questions trainees actually asked during the three days — reinforce their real pain points. Leave 10 minutes at the end for open Q&A and to point them at the `day3-complete` snapshot as their reference build.
