# 14 — Copy Methods 2 & 3, and the Cutover

**Mode:** Hands-on
**Goal:** Copy the database two *faster* ways, understand when you'd choose each — then **fix the missing user** and **repoint the app** at `ubuntu-new-db`.

**Time:** ~60 minutes

> Headers as before: 🟦 `ubuntu-old-db` (source) · 🟪 `ubuntu-new-db` (target) · 🟩 `ubuntu-app` (web)

---

## 0. 🟪 Reset the target — you're doing this again

To *learn* method 2, you must start from an empty target. Wipe what file 13 imported:

```bash
$ sudo mysql -e "DROP DATABASE appdb; CREATE DATABASE appdb CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;"
$ sudo mysql -e "SHOW TABLES FROM appdb;"    # Empty
```

📌 **Checkpoint:** `appdb` on `ubuntu-new-db` exists and is **empty** again.

> Restoring the **`new-db-empty`** snapshot from file 12 works too, and is the more realistic "start over" move. The `DROP DATABASE` is faster in class.

> ⚠️ **Read that command twice before you run it.** `DROP DATABASE` on the *wrong VM* destroys your source data. Check your prompt says **`ubuntu-new-db`**. This is not a drill you get to repeat — it's why professionals `snapshot` first, which you did.

---

## 1. Method 2 — the SSH pipe (no intermediate file)

🟦 On **`ubuntu-old-db`**, one command does everything:

```bash
$ mysqldump -u root -p \
    --single-transaction --routines --triggers --events \
    --databases appdb \
  | ssh student@<new-db-IP> "sudo mysql"
```

**Read it left to right — it's a conveyor belt:**

```
  mysqldump  ──stdout──►  ssh (encrypted network)  ──stdin──►  mysql on new-db
  produces SQL text        carries the bytes                    executes the SQL
```

The `|` means **nothing ever touches the disk.** The SQL streams out of `mysqldump`, through the SSH tunnel, straight into `mysql` on the other machine.

> **Why `sudo mysql` inside the quotes?** That's the command SSH runs *on the remote host*. It reads the piped SQL from its standard input, exactly as `mysql < file.sql` did in file 13.
>
> If `sudo` prompts for a password over SSH it will fail — the pipe has no terminal. Use MySQL credentials instead if that happens: `ssh student@<new-db-IP> "mysql -u root -p'YourPass' "`.

📌 **Checkpoint:** 🟪 On `ubuntu-new-db`, the counts are back:

```sql
mysql> SELECT (SELECT COUNT(*) FROM appdb.departments) AS d,
              (SELECT COUNT(*) FROM appdb.employees)   AS e,
              (SELECT COUNT(*) FROM appdb.projects)    AS p;
```

**4 / 6 / 5** again — and you never created a file.

**What you gained:** speed, no disk space needed, nothing to clean up. On a 200 GB database that intermediate file is a real problem; this method makes it vanish.

**What you lost:** the artefact. There is **no backup** on disk afterwards. If the pipe breaks halfway, you have a **half-imported database** and nothing to retry from — you start over from the source.

---

## 2. Method 3 — pull it over the MySQL protocol (no SSH between servers)

Methods 1 and 2 both need **SSH access** from one server to the other. Often you don't have that — you're a DBA with database credentials, not a shell account on someone else's box.

You can dump **remotely**: `mysqldump` is just a MySQL *client*, so it can connect over the network with `-h`, exactly like the `mysql` client did in file 11.

### 2a. 🟦 On `old-db` — allow the new server to connect

The source needs a user the target can log in as, and a firewall that lets it:

```sql
-- on ubuntu-old-db
mysql> CREATE USER 'copyuser'@'<new-db-IP>' IDENTIFIED BY 'Copy_Str0ng!';
mysql> GRANT SELECT, SHOW VIEW, TRIGGER, LOCK TABLES, EVENT ON appdb.* TO 'copyuser'@'<new-db-IP>';
mysql> GRANT PROCESS ON *.* TO 'copyuser'@'<new-db-IP>';
mysql> FLUSH PRIVILEGES;
```

```bash
$ sudo ufw allow from <new-db-IP> to any port 3306    # the new server may now reach MySQL
```

> **Why those grants?** A dump needs to *read* the data (`SELECT`), read view definitions (`SHOW VIEW`), read triggers (`TRIGGER`) and events (`EVENT`), and `LOCK TABLES` unless you use `--single-transaction`. This is least privilege again: a user that can copy the database and **do nothing else**.

### 2b. 🟪 On `new-db` — reset, then pull

```bash
$ sudo mysql -e "DROP DATABASE appdb; CREATE DATABASE appdb CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;"

$ mysqldump -h <old-db-IP> -u copyuser -p \
    --single-transaction --routines --triggers --events \
    --databases appdb \
  | sudo mysql
```

Look closely at what changed: **`-h <old-db-IP>`**. The dump runs *on the target*, reaching *across the network* to read the source, and pipes straight into the local MySQL. The source server never ran a command.

📌 **Checkpoint:** Counts are **4 / 6 / 5** on `ubuntu-new-db` for the third time — with no SSH between the servers, and no file.

---

## 3. Which method, when?

| | **1. Dump → file** | **2. SSH pipe** | **3. Remote pull** |
|---|---|---|---|
| Leaves a backup artefact | ✅ **yes** | ❌ no | ❌ no |
| Needs disk space for the dump | ❌ yes | ✅ no | ✅ no |
| Needs SSH between servers | yes | yes | ✅ **no** |
| Needs MySQL port open between servers | no | no | yes |
| Can inspect/edit before importing | ✅ **yes** | ❌ no | ❌ no |
| Resumable if it fails halfway | ✅ (re-import the file) | ❌ start over | ❌ start over |
| Best for | **the default**; anything you want to keep or check | huge DBs, tight disk | when you only hold DB credentials |

> **The honest answer for most real migrations is Method 1** — because the dump file *is* your rollback plan, and because being able to `grep` the thing you're about to import is worth more than the disk space it costs. Reach for 2 and 3 when the file itself is the problem.

---

## 4. The cutover — and the failure you predicted

The data is on `ubuntu-new-db`. Now point the app at it.

### 4a. 🟩 Repoint the app — one line

On **`ubuntu-app`**:

```bash
$ sudo nano /var/www/appconfig.php
```

Change **only** the host:

```php
    'host' => '<new-db-IP>',        // was <old-db-IP> — now ubuntu-new-db
```

Reload `http://<app-IP>/` in your browser.

### 4b. It fails. **Good.**

```
Database connection failed: SQLSTATE[HY000] [1045]
Access denied for user 'appuser'@'192.168.56.101'
```

**You called this in file 13.** `grep -c 'GRANT' appdb.sql` returned **0** — the dump carried the *database*, never the *users*. `appuser` exists on `old-db` and has never existed on `new-db`. The data is perfect; nobody is allowed to read it.

> **This is the single most common cutover failure in the real world**, and it's why "the import succeeded" is never the end of a migration.

### 4c. 🟪 Create the user on the new server

On **`ubuntu-new-db`** — same user, same grants as file 11 §3:

```sql
mysql> CREATE USER 'appuser'@'<app-IP>' IDENTIFIED BY 'ChangeMe_Str0ng!';
mysql> GRANT SELECT, INSERT ON appdb.* TO 'appuser'@'<app-IP>';
mysql> FLUSH PRIVILEGES;
```

And open the firewall to the app — the **three-layer rule** from file 11 applies to this server too:

```bash
$ sudo ufw allow from <app-IP> to any port 3306
$ sudo ufw status
```

> Also confirm `bind-address = 0.0.0.0` in `/etc/mysql/mysql.conf.d/mysqld.cnf` on this VM (file 08 §3) — a fresh MySQL binds to `127.0.0.1` and will refuse the app no matter how open the firewall is.

### 4d. 🟩 Reload the page

```
http://<app-IP>/
```

The directory is back — and the line now reads:

> Data in MySQL at **192.168.56.103** — database host: **ubuntu-new-db**

📌 **Checkpoint:** The page renders **4 departments / 6 employees / 5 projects** and names **`ubuntu-new-db`** as the database host. **You have migrated a live application to a new database server.**

---

## 5. Prove the new server is *live*, not a fossil

A static copy would look identical. Write to it:

1. **Add an employee** through the form on the web page.
2. 🟪 On **`ubuntu-new-db`**, confirm it landed:

```sql
mysql> SELECT name, email FROM appdb.employees ORDER BY emp_id DESC LIMIT 1;   -- your new row
```

3. 🟦 On **`ubuntu-old-db`**, confirm it did **not**:

```sql
mysql> SELECT name, email FROM appdb.employees ORDER BY emp_id DESC LIMIT 1;   -- your row is NOT here
```

📌 **Checkpoint:** New writes land on `ubuntu-new-db` and **only** there. The old server is now a **stale snapshot** — frozen at the moment you dumped it.

> **This is the sharpest lesson of the day.** From the instant you cut over, `old-db` starts drifting out of date. In a real migration, any write that reached the old server *after* the dump but *before* the cutover is **lost data**. That gap is why serious cutovers stop writes first, or use replication to keep the target in sync until the moment of the switch.

---

## 6. Wrap-up

- [ ] Copied `appdb` **three ways**: dump file, SSH pipe, remote pull
- [ ] Can say which method you'd choose and **why**
- [ ] Verified the copy structurally, not just by row count
- [ ] Recreated `appuser` + the firewall rule on `ubuntu-new-db` — the part the dump didn't carry
- [ ] The app now reads and writes `ubuntu-new-db`, and the page proves it by name
- [ ] Understand that `ubuntu-old-db` is now stale, and why that matters

Snapshot all three VMs — **`day2-cutover-complete`**.

> **Trainer note (Luqman):** Let §4b actually fail. Don't warn them, don't let them pre-create the user — the `Access denied` is the payoff for the `grep` in file 13, and a failure they *predicted* teaches more than a lab that just works. Budget five minutes for the room to explain it back to you before you show 4c. The §5 old-vs-new divergence is the natural bridge to Day 3: it's the reason validation is a discipline and not a formality.

Next: **Day 3** — validate the copy properly (`SHOW CREATE TABLE` diffs, checksums), then go deeper on MySQL administration and harden all three servers.
