# Migration Runbook — CentOS MySQL 5.x → Ubuntu MySQL 8

> **Trainer-only.** Your real, end-to-end runbook for moving the legacy **CentOS + MySQL 5.x** database onto a **separate, new Ubuntu Server + MySQL 8** host. Logical dump-and-load. Self-contained: it does not depend on the participants' training VMs.

**Assumed environment (adjust to your real versions):**

| Role | Host | OS | MySQL |
|------|------|----|-------|
| **Source** | `centos-db` | CentOS 7 (or 6/8/Stream) | MySQL 5.7 (or 5.6) |
| **Target** | `ubuntu-db-new` | Ubuntu Server 24.04 LTS | MySQL 8.0 (Community) |

> Throughout, substitute `sourcedb` with the real database name, and `<centos-IP>` / `<ubuntu-IP>` with real addresses. Commands prefixed `#` run as root (or with `sudo`).

---

## 0. The one-page plan

```
   centos-db (CentOS)                         ubuntu-db-new (Ubuntu)
   ┌────────────────────┐                     ┌────────────────────┐
   │  MySQL 5.x         │  ── dump.sql.gz ──► │  MySQL 8.0         │
   │  (production data) │     scp over SSH    │  (fresh, secured)  │
   └────────────────────┘                     └────────────────────┘
        1. inventory            3. transfer         4. import
        2. dump (consistent)                        5. users/grants
                                                     6. validate → cutover
```

**Golden rules**
- **Never migrate the live production box without a tested rehearsal first.** Do a full dry run on snapshots/clones.
- **Read from the source; never write to it** during migration.
- Keep a **known-good dump** archived off-box before you touch anything.
- Have a **rollback**: the old CentOS server stays untouched and running until cutover is signed off.

---

## 1. Pre-flight inventory (on the CentOS source)

You cannot plan what you haven't measured. Capture all of this into a text file you keep.

### 1.1 OS and MySQL versions

```bash
# cat /etc/redhat-release              # CentOS version
# mysql --version                      # client version
# mysqld --version 2>/dev/null || mysql -V
```

Log in. On CentOS, MySQL 5.x `root` typically uses a **password** (not `auth_socket` like Ubuntu):

```bash
# mysql -u root -p
```

```sql
SELECT VERSION();
```

### 1.2 Databases, sizes, engines, charsets

```sql
-- Which databases (ignore system schemas)
SHOW DATABASES;

-- Size per database (MB)
SELECT table_schema,
       ROUND(SUM(data_length + index_length)/1024/1024, 1) AS size_mb
FROM information_schema.tables
GROUP BY table_schema ORDER BY size_mb DESC;

-- Storage engines in play (spot MyISAM)
SELECT table_schema, engine, COUNT(*) AS tables
FROM information_schema.tables
WHERE table_schema = 'sourcedb'
GROUP BY table_schema, engine;

-- Charsets / collations in use
SELECT DISTINCT table_collation
FROM information_schema.tables
WHERE table_schema = 'sourcedb';
```

**Write down:** DB name(s), total size, table count, any **MyISAM** tables, any **utf8/latin1** (non-`utf8mb4`) tables.

### 1.3 Accounts, hosts, and auth plugins

```sql
SELECT user, host, plugin FROM mysql.user ORDER BY user;
```

Note every account the **application(s)** use, their **host** scoping, and their **plugin** (5.x will show `mysql_native_password` or blank). You will recreate these on MySQL 8.

Dump the exact grants so you can replay them:

```bash
# mysql -u root -p -N -e \
  "SELECT CONCAT('SHOW GRANTS FOR ''',user,'''@''',host,''';') \
   FROM mysql.user WHERE user NOT IN ('root','mysql.sys','mysql.session','debian-sys-maint')" \
  | mysql -u root -p > ~/source_grants.txt
# cat ~/source_grants.txt
```

### 1.4 Config worth carrying over

```bash
# cat /etc/my.cnf
# ls /etc/my.cnf.d/ 2>/dev/null && cat /etc/my.cnf.d/*.cnf 2>/dev/null
```

Note anything non-default: `sql_mode`, `character-set-server`, timezone, custom buffer sizes. You'll reconcile these against MySQL 8 defaults (§7).

📌 **Pre-flight done when** you have a written record of: versions, DB name/size/table count, MyISAM list, non-utf8mb4 list, app accounts + hosts + plugins, grants file, and notable config.

---

## 2. Prepare the target (Ubuntu MySQL 8)

On `ubuntu-db-new`. If you built it with the course Day 2 steps, MySQL 8 is already installed and secured — otherwise:

```bash
$ sudo apt update && sudo apt install mysql-server -y
$ mysql --version                       # expect 8.0.x
$ sudo systemctl enable --now mysql
$ sudo mysql_secure_installation        # remove anon users, test db, remote root
```

Confirm a clean, empty server:

```bash
$ sudo mysql -e "SHOW DATABASES;"       # only system schemas present
```

> Decide **now** whether the app connects to this box over the network. If yes, you'll bind it to the network and firewall it (mirrors the participant `ubuntu-db` setup — see `day2/07`, `day2/08`). If the app moves onto the same host, keep it on localhost.

---

## 3. Run the upgrade checker (before dumping — this is the real order)

MySQL Shell's `checkForServerUpgrade` finds 5→8 problems *at the source* so you fix them before importing, not during.

Install MySQL Shell somewhere that can reach the CentOS server (the Ubuntu target is fine):

```bash
$ sudo apt install mysql-shell -y       # or Oracle APT repo if not present
$ mysqlsh --version
```

Point it at the live CentOS source (needs 3306 reachable — see §5.1 for firewalld):

```bash
$ mysqlsh -- util check-for-server-upgrade \
    { --user=root --host=<centos-IP> --port=3306 } \
    --target-version=8.0.0 --output-format=TEXT
```

> If you'd rather not open 3306 on CentOS, install `mysql-shell` **on the CentOS box** and run it against `localhost`.

**Act on the report:**
- **Errors** must be fixed (reserved-word identifiers, removed features, orphaned/incompatible objects).
- **Warnings** (e.g. `utf8mb3` usage) — review, usually convert to `utf8mb4`.
- Fix at the **source** (rename columns, convert engines/charsets) or plan to fix in the dump, then **re-run until zero Errors**.

Common fixes:
```sql
-- reserved word column (rank, groups, system, ...)
ALTER TABLE players CHANGE `rank` player_rank INT;
-- MyISAM → InnoDB
ALTER TABLE legacy_table ENGINE = InnoDB;
-- utf8(mb3) → utf8mb4
ALTER TABLE legacy_table CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
```

📌 **Green light:** upgrade checker reports **0 Errors**.

---

## 4. Take a consistent dump (on the CentOS source)

Use the **source server's own `mysqldump`** (5.x) — it matches the server and avoids client/version quirks.

**All-InnoDB database (after §3 conversions):**

```bash
# mysqldump -u root -p \
    --single-transaction --quick \
    --routines --triggers --events \
    --default-character-set=utf8mb4 \
    --databases sourcedb \
    > ~/sourcedb_$(date +%F).sql
```

| Flag | Why |
|------|-----|
| `--single-transaction` | Consistent snapshot **without locking** (InnoDB) |
| `--quick` | Stream rows, don't buffer whole tables in RAM |
| `--routines --triggers --events` | Carry procedures/functions, triggers, scheduled events |
| `--databases sourcedb` | Include `CREATE DATABASE`/`USE` |
| `--default-character-set=utf8mb4` | Dump text as 4-byte UTF-8 |

> ⚠️ **If any MyISAM tables remain**, `--single-transaction` does **not** make them consistent. Either convert them to InnoDB first (§3), or take a brief maintenance window with `--lock-all-tables`. Don't mix.

> **GTID / replication:** if the source uses GTIDs and the new server won't replicate from it, add `--set-gtid-purged=OFF` to avoid importing GTID state. For a standalone cutover this is usually what you want.

**Verify and preserve the dump:**

```bash
# ls -lh ~/sourcedb_*.sql
# head -n 30 ~/sourcedb_*.sql             # header + version + CREATE DATABASE
# grep -c "CREATE TABLE" ~/sourcedb_*.sql # ~matches your table count
# tail -n 3 ~/sourcedb_*.sql              # ends with "-- Dump completed"
# gzip -k ~/sourcedb_*.sql                # keep a compressed copy for transfer
# cp ~/sourcedb_*.sql.gz ~/sourcedb.KNOWN_GOOD.sql.gz   # archive off-box after this
```

📌 **Dump good when** size is sensible, `CREATE TABLE` count matches, and the file ends with `-- Dump completed`.

---

## 5. Transfer to the Ubuntu target

### 5.1 CentOS firewall / SELinux notes (source side)

CentOS uses **firewalld** and **SELinux**, not UFW. To allow the checker or an outbound scp you generally need nothing extra for **outbound** SSH. If you instead pull *from* Ubuntu or run the checker *to* CentOS on 3306:

```bash
# firewall-cmd --permanent --add-rich-rule='rule family=ipv4 source address=<ubuntu-IP>/32 port port=3306 protocol=tcp accept'
# firewall-cmd --reload
```

Remove that rule again after migration. SELinux rarely blocks scp/ssh; if it interferes with a non-standard MySQL datadir later, check `getenforce` and `ausearch -m avc`.

### 5.2 Copy the dump (push from CentOS, or pull from Ubuntu)

```bash
# from CentOS, push:
# scp ~/sourcedb_*.sql.gz  <ubuntu-user>@<ubuntu-IP>:~/
```
or
```bash
# from Ubuntu, pull:
$ scp <centos-user>@<centos-IP>:~/sourcedb_*.sql.gz ~/
```

📌 **Checkpoint:** the `.sql.gz` exists in the Ubuntu target's home (`ls -lh ~`).

---

## 6. Import into MySQL 8 (on the Ubuntu target)

```bash
$ gunzip ~/sourcedb_*.sql.gz
$ sudo mysql < ~/sourcedb_*.sql
```

Because we dumped with `--databases`, the file recreates the database itself. Watch the output — errors here are the 5→8 differences (should be minimal if §3 was clean):

- `ERROR 1064 ... near '<word>'` → a reserved word slipped through → fix in dump, re-import.
- collation / `utf8mb4` warnings → usually benign after conversion.

If an import stops hard, fix the offending lines (or fall back to the known-good dump) and re-run. For large dumps you can watch progress with `pv`:

```bash
$ pv ~/sourcedb_*.sql | sudo mysql
```

Confirm the data landed:

```bash
$ sudo mysql -e "SHOW DATABASES;"
$ sudo mysql -e "USE sourcedb; SHOW TABLES;"
```

---

## 7. Recreate users, grants, and reconcile auth plugins

The single-database dump does **not** carry `mysql.user` accounts. Recreate each app account from your `source_grants.txt` — **but** MySQL 8 defaults to `caching_sha2_password`.

**Preferred (modern driver):**
```sql
CREATE USER 'appuser'@'<app-host-or-IP>' IDENTIFIED BY 'Str0ng_Pass!';
GRANT SELECT, INSERT, UPDATE, DELETE ON sourcedb.* TO 'appuser'@'<app-host-or-IP>';
FLUSH PRIVILEGES;
```

**Legacy driver that can't do `caching_sha2_password`:**
```sql
CREATE USER 'appuser'@'<app-host-or-IP>'
  IDENTIFIED WITH mysql_native_password BY 'Str0ng_Pass!';
```

> This auth-plugin change is the **#1 real-world breakage**. Test the actual application driver against MySQL 8 before cutover; only fall back to `mysql_native_password` if you genuinely can't upgrade the client.

Reconcile config: MySQL 8 enables strict `sql_mode` (`ONLY_FULL_GROUP_BY`, `NO_ZERO_DATE`, `STRICT_TRANS_TABLES`) and `utf8mb4` defaults. If the app relies on loose 5.x behavior, fix the app/queries; only loosen `sql_mode` as a temporary, documented stopgap.

---

## 8. Validate (prove complete + correct)

Compare **CentOS source** vs **Ubuntu 8** on three levels.

**Structural** — same objects:
```sql
SELECT COUNT(*) FROM information_schema.tables   WHERE table_schema='sourcedb';
SELECT routine_name FROM information_schema.routines WHERE routine_schema='sourcedb';
SELECT trigger_name FROM information_schema.triggers WHERE trigger_schema='sourcedb';
```

**Quantitative** — exact row counts on both, diffed. Generate the statements:
```sql
SELECT CONCAT('SELECT ''', table_name, ''' t, COUNT(*) c FROM `', table_name, '`;')
FROM information_schema.tables WHERE table_schema='sourcedb';
```
Run the generated block on both servers; compare.

**Qualitative** — fingerprints on **unchanged** tables:
```sql
CHECKSUM TABLE sourcedb.customers, sourcedb.orders;
```
(Checksums will legitimately differ on tables you converted charset/engine — spot-check those instead.)

Also confirm foreign keys, indexes, and `AUTO_INCREMENT` next-values carried over.

📌 **Sign-off:** object inventory matches, exact row counts match, unchanged tables checksum-match, changed tables pass spot checks, keys/indexes/auto-increment correct.

---

## 9. Cutover & rollback

1. **Freeze writes** on the CentOS app (maintenance page / stop app), take a **final incremental dump** of anything changed since the rehearsal dump, and import the delta — or, for a small DB, simply re-dump/re-import fresh during the window.
2. **Repoint the application** to the Ubuntu MySQL 8 host (connection string → `<ubuntu-IP>`, new credentials).
3. **Smoke test** the app end-to-end: read a page, perform one write, confirm it persists.
4. **Watch** `/var/log/mysql/error.log` and app logs for the first hour.

**Rollback:** the CentOS server is **untouched and still running**. If the app misbehaves on 8, repoint back to CentOS — no data was written to it during the window. Only decommission CentOS after a sign-off period (e.g. a week of clean running + a verified backup of the new box).

---

## 10. CentOS ↔ Ubuntu quick-reference (the things that trip people up)

| Concern | CentOS (source) | Ubuntu (target) |
|--------|-----------------|-----------------|
| Package mgr | `yum` / `dnf` | `apt` |
| MySQL service | `systemctl status mysqld` (often **`mysqld`**) | `systemctl status mysql` |
| Config file | `/etc/my.cnf` (+ `/etc/my.cnf.d/`) | `/etc/mysql/mysql.conf.d/mysqld.cnf` |
| Socket | `/var/lib/mysql/mysql.sock` | `/var/run/mysqld/mysqld.sock` |
| Firewall | **firewalld** (`firewall-cmd`) | **UFW** (`ufw`) |
| Mandatory access ctl | **SELinux** (`getenforce`) | AppArmor |
| root auth (5.x) | **password** | 8 on Ubuntu: `auth_socket` (`sudo mysql`) |
| Data dir | `/var/lib/mysql` | `/var/lib/mysql` |

---

## 11. Rehearsal checklist (do this before the live run *and* before the class demo)

- [ ] Full pre-flight inventory captured (§1)
- [ ] Target Ubuntu MySQL 8 installed, secured, empty (§2)
- [ ] Upgrade checker run → **0 Errors** (§3)
- [ ] Consistent dump taken, verified, known-good copy archived off-box (§4)
- [ ] Dump transferred and imported cleanly (§5–6)
- [ ] App users/grants recreated; **real app driver tested** against 8 (§7)
- [ ] Validation passed — counts, checksums, objects (§8)
- [ ] Cutover + rollback steps written down and timed (§9)
- [ ] Snapshots taken of both boxes; timings noted for the demo

> Run the rehearsal end-to-end at least once. The demo you show the class is the rehearsal narrated — not a first attempt.
