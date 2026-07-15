# 20 — Troubleshooting Workshop

**Mode:** Hands-on / discussion
**Goal:** Build diagnostic instinct. Instead of new material, you work through **realistic broken scenarios** using a repeatable method — the skill that matters most after the course ends.

**Time:** ~60 minutes

> Use a snapshot (`day3-complete` or `day2-cutover-complete`) so you can break things freely and roll back. **Take a snapshot before deliberately breaking anything.** Scenarios span `ubuntu-app` and the database VMs — watch which VM each step is on. The app now talks to **`ubuntu-new-db`**, so that's the database server in the app-connectivity scenarios.

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
$ sudo tail -n 50 /var/log/nginx/error.log     # Nginx / PHP-FPM
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
$ sudo tail -n 30 /var/log/nginx/error.log
```
Look for `Database connection failed` (bad credentials) or `PHP ... Parse error` (syntax). A **502 Bad Gateway** here is different — that's Nginx unable to reach PHP-FPM (file 10 §5), not a code or credential fault.

**Fix:** correct the credential or the syntax. PHP code changes need no reload; if you touched Nginx config:
```bash
$ sudo nginx -t && sudo systemctl reload nginx
```
**Confirm:** reload the page.

---

## 3b. Scenario B2 — "The app can't reach the database server" (the split-tier classic)

This is the failure unique to a split app/database setup: the code is fine, but `ubuntu-app` can't talk to MySQL on `ubuntu-new-db`. It's the exact failure you *engineered* at cutover in file 14 §4b — worth reproducing deliberately now.

**Break it (pick one, on `ubuntu-new-db`):** remove the firewall rule (`sudo ufw delete` the 3306 line), or set `bind-address = 127.0.0.1` and restart MySQL, or change the app user's host so it no longer matches the app IP.

**Diagnose — work outward-in from `ubuntu-app`:**
```bash
$ nc -zv <new-db-IP> 3306        # port reachable? timeout = firewall/bind problem
$ mysql -h <new-db-IP> -u appuser -p appdb   # isolates auth from PHP
```
- `nc` **times out** → firewall closed to this app, or MySQL bound to localhost.
- `nc` succeeds but login says `Access denied for 'appuser'@'<app-IP>'` → user host mismatch (or the user was never created on this server — the cutover trap).

**Fix (on `ubuntu-new-db`, matching the cause):**
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

> Lesson: three layers must line up — **firewall → bind-address → user host** (file 08 §5, file 11 §8). Test them in that order and the fault localizes itself. Note this is *the same* diagnosis whether the DB is `old-db` or `new-db` — the skill transfers to every database server you'll ever add.

---

## 4. Scenario C — "MySQL won't start after a config change" (on a database VM)

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

## 5. Scenario D — "App can't connect: authentication plugin" (on a database VM)

> This one is a **cross-version** flavour — you won't hit it with your all-MySQL-8 setup, but it's the classic symptom when a legacy app meets a migrated 5→8 database, so it's worth rehearsing.

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

> Lesson: the #1 real-world 5→8 migration gotcha (file 15 §1) — and it can bite any split app/DB setup if the app's MySQL driver is old.

---

## 6. Scenario E — "Import failed on a reserved word"

> Also a **cross-version** scenario (file 15 §2): your own dump imported cleanly because both servers are MySQL 8. This is what a 5.x dump can do on an 8 target.

**Break it:** import a small dump containing a column named `` `rank` `` unquoted.

**Diagnose:** `ERROR 1064 ... near 'rank'`.

**Fix:** quote or rename in the dump/schema:
```sql
ALTER TABLE players CHANGE `rank` player_rank INT;
```
**Confirm:** re-run the import; no error.

---

## 7. Scenario F — "Website unreachable from Windows, but curl on the VM works"

**Break it:** remove the Nginx firewall rule (on `ubuntu-app`).

**Diagnose:**
```bash
# On the VM — proves the app itself is fine:
$ curl -I http://localhost
# From Windows — fails → it's a network/firewall layer issue
$ sudo ufw status        # Nginx Full missing?
```

**Fix:**
```bash
$ sudo ufw allow 'Nginx Full'
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

📌 **Course complete.** You can install and secure Ubuntu, build an **Nginx + PHP-FPM + MySQL 8** stack split across separate app and database servers (linked over a scoped network path), **copy a database between servers and prove the copy correct**, administer and harden the whole thing, understand how a cross-version MySQL 5.x → 8 migration differs from a same-version copy, and diagnose failures methodically.

> **Trainer note (Luqman):** Pick the scenarios that match the questions trainees actually asked during the three days — reinforce their real pain points. Leave 10 minutes at the end for open Q&A and to point them at the `day3-complete` snapshot as their reference build.
