# 13 — Copy Method 1: Dump → File → Transfer → Import

**Mode:** Hands-on
**Goal:** Copy `appdb` from `ubuntu-old-db` to `ubuntu-new-db` using the classic three-step method — and **read the dump file** to understand what actually moves.

**Time:** ~45 minutes

> Watch the headers:
> - 🟦 **on `ubuntu-old-db`** — the source
> - 🟪 **on `ubuntu-new-db`** — the target
>
> This is **the method to know**. Methods 2 and 3 (file 14) are variations on it.

---

## The shape of it

```
   🟦 ubuntu-old-db                          🟪 ubuntu-new-db
   ┌────────────────┐                        ┌────────────────┐
   │  MySQL 8       │                        │  MySQL 8       │
   │    appdb       │                        │    appdb       │
   └───────┬────────┘                        └───────▲────────┘
           │ 1. mysqldump                            │ 3. mysql < file
           ▼                                         │
      appdb.sql  ─────── 2. scp over SSH ───────►  appdb.sql
```

Three steps, three separate things that can fail — which is exactly why this method is good for learning. **You can inspect the artefact between every step.**

---

## 1. 🟦 Take the dump

On **ubuntu-old-db**:

```bash
$ mysqldump -u root -p \
    --single-transaction \
    --routines --triggers --events \
    --databases appdb \
    > ~/appdb.sql
```

> Use `sudo mysqldump` without `-u root -p` if that's how you log into MySQL on this VM.

**Every flag earns its place — know what these do:**

| Flag | What it does | Why it matters |
|------|--------------|----------------|
| `--single-transaction` | Dumps inside one consistent transaction, **without locking the tables** | The app keeps serving while you dump. Without it, `mysqldump` locks tables and your website stalls. **InnoDB only** — which is what we have |
| `--routines --triggers --events` | Includes stored procedures, triggers, scheduled events | **These are NOT included by default.** A dump without them looks complete and silently isn't |
| `--databases appdb` | Wraps the dump in `CREATE DATABASE` + `USE appdb` | Without `--databases`, the dump has no `USE` statement and you must tell `mysql` which DB to load into. With it, the file is self-contained |

📌 **Checkpoint:** The file exists and isn't empty.

```bash
$ ls -lh ~/appdb.sql
-rw-rw-r-- 1 student student 5.4K ... appdb.sql
```

> ⚠️ **A zero-byte dump is a *successful* command with a failed result.** `mysqldump` writes errors to the screen but still creates the file. **Always check the size.**

---

## 2. 🟦 Read the dump — this is the important part

Do not skip this. Everything file 12's risk map warned about is visible here, in plain text.

```bash
$ less ~/appdb.sql        # q to quit
```

**Find these five things:**

**(a) The structure comes with the data.** Search for `CREATE TABLE employees` — your column types, sizes and constraints are all there:

```sql
CREATE TABLE `employees` (
  `emp_id` int unsigned NOT NULL AUTO_INCREMENT,
  `salary` decimal(10,2) NOT NULL,           -- ← DECIMAL survived. Verify this on the target!
  ...
  CONSTRAINT `fk_emp_dept` FOREIGN KEY (`dept_id`) REFERENCES `departments` (`dept_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

**(b) The `AUTO_INCREMENT` counter is carried.** See `AUTO_INCREMENT=7` above — the dump remembers the *next* ID, not just the rows. That's risk #5 handled for you.

**(c) The foreign key problem is solved by a trick.** Near the top:

```sql
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
```

`mysqldump` **turns foreign key checking off** for the duration of the import, and back on at the end. That's why load order doesn't break the import — the constraints are still *created*, just not *enforced* while loading.

```bash
$ grep -n 'FOREIGN_KEY_CHECKS' ~/appdb.sql
```

> **Remember this.** The day you hand-edit a dump, or load tables individually, this safety net is gone — and then parent-before-child order is entirely your problem.

**(d) The data is just `INSERT` statements.**

```bash
$ grep -n 'INSERT INTO' ~/appdb.sql
```

**(e) What is NOT in the file — look for it and fail to find it:**

```bash
$ grep -c 'CREATE USER' ~/appdb.sql       # 0
$ grep -c 'GRANT'       ~/appdb.sql       # 0
```

**Zero.** `appuser` and its grants **are not in this dump.** They live in the `mysql` system database, not in `appdb`. The data will arrive perfectly and the app still won't be able to log in. **This is risk #2, and you just proved it to yourself.** You'll fix it in file 14.

📌 **Checkpoint:** You can point at the `CREATE TABLE`, the `AUTO_INCREMENT=` counter, the `FOREIGN_KEY_CHECKS=0` line, and the *absence* of any `GRANT`.

---

## 3. 🟦 Transfer the file to the target

```bash
$ scp ~/appdb.sql student@<new-db-IP>:~/
student@192.168.56.103's password:
appdb.sql                          100% 5.4KB   2.1MB/s   00:00
```

> `<new-db-IP>` is the **host-only** `192.168.56.x` address — not `10.0.2.15`, which is the same on every VM and routes nowhere.

**For a real (large) database, compress it** — SQL text compresses ~10:1:

```bash
$ gzip -c ~/appdb.sql > ~/appdb.sql.gz     # then scp the .gz, and gunzip on the far side
```

📌 **Checkpoint:** 🟪 On `ubuntu-new-db`, `ls -lh ~/appdb.sql` shows the file, **same size** as on the source.

> ⚠️ **If `scp` hangs or is refused**, SSH between the two VMs isn't working — remember both are on the host-only network and both need SSH open in UFW (Day 1). Test bare connectivity first: `ssh student@<new-db-IP>`.

---

## 4. 🟪 Import into `ubuntu-new-db`

On **ubuntu-new-db**:

```bash
$ sudo mysql < ~/appdb.sql
```

That's it. Silence means success — `mysql` prints nothing when a script runs cleanly.

> **Why no `appdb` argument?** Because you dumped with `--databases`, the file contains its own `CREATE DATABASE`/`USE appdb`. It knows where it's going. (Had you dumped *without* that flag, you'd need `sudo mysql appdb < ~/appdb.sql`.)

> ⚠️ **`ERROR 1049 (42000): Unknown database 'appdb'`** means the opposite mistake — a dump *without* `--databases` being loaded without naming a target. Re-dump with `--databases`, or name the DB on import.

📌 **Checkpoint:** The command returns with no error output.

---

## 5. 🟪 Verify — and do not trust silence

The import printed nothing. **That is not evidence of correctness.** Check three levels, in increasing strength:

**Level 1 — do the tables exist?**

```sql
mysql> USE appdb;
mysql> SHOW TABLES;
+-----------------+
| departments     |
| employees       |
| projects        |
+-----------------+
```

**Level 2 — do the row counts match the source?** (The numbers you wrote down in file 12.)

```sql
mysql> SELECT
         (SELECT COUNT(*) FROM departments) AS departments,
         (SELECT COUNT(*) FROM employees)   AS employees,
         (SELECT COUNT(*) FROM projects)    AS projects;
```

Expect **4 / 6 / 5** (plus any rows you added through the form).

**Level 3 — did the *structure* survive?** This is the one that catches the silent corruption:

```sql
mysql> SHOW CREATE TABLE employees\G
```

Read it against what you saw in the dump file. Specifically confirm:

- [ ] `salary` is still **`decimal(10,2)`** — not `double`, not `float`
- [ ] `email` still has its **`UNIQUE`** key
- [ ] The **`fk_emp_dept` FOREIGN KEY** is present, with `ON DELETE RESTRICT`
- [ ] Charset is **`utf8mb4`**, collation `utf8mb4_0900_ai_ci`
- [ ] `AUTO_INCREMENT=` shows the **next** ID (7 or higher), not 1

**And prove the constraints are actually enforced**, not just declared:

```sql
mysql> INSERT INTO employees (dept_id, name, email, salary, hired_on)
       VALUES (99, 'Ghost', 'ghost@example.com', 1000, '2025-01-01');
ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails
```

📌 **Checkpoint:** Three tables, matching counts, `DECIMAL(10,2)` intact, and the foreign key **still refuses** department 99 — exactly as it did on `old-db`.

> **This is the whole lesson of the lab.** A copy that moves every row but loses a constraint or widens a column *passes* a row-count check and *is still broken*. Levels 1 and 2 are necessary; only level 3 is convincing.

---

## 6. A dump is also a backup

Notice what you have sitting in your home directory: a complete, portable, human-readable snapshot of the database.

```bash
$ cp ~/appdb.sql ~/appdb-backup-$(date +%F).sql
```

That's a real backup strategy in one command — and it's the by-product that makes **Method 1 the default choice**. Methods 2 and 3 are faster and tidier, but they leave you with **nothing to keep**.

> Day 3 (file 18) turns this into a scheduled, automated job.

---

## Where you are

- ✅ `appdb` — schema, data, keys, counters — now exists on `ubuntu-new-db`
- ✅ You've verified it at the **structural** level, not just by counting rows
- ❌ `appuser` does **not** exist on `ubuntu-new-db` — the dump never contained it
- ❌ The app on `ubuntu-app` is still pointed at `ubuntu-old-db`

Next: **`14-copy-methods-2-3-and-cutover.md`** — do the same copy two faster ways (SSH pipe; pull over the MySQL protocol), then fix the missing user and **repoint the app at `ubuntu-new-db`**.

> **Trainer note (Luqman):** §2 is the section worth protecting if you're short on time — reading the dump is where the concepts land, and everything after it is typing. Have someone read out the `AUTO_INCREMENT=7` and the `FOREIGN_KEY_CHECKS=0` lines to the room. The `grep -c 'GRANT'` returning **0** is the moment the file-14 `Access denied` becomes something they predicted rather than something that happened to them.
