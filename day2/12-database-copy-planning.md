# 12 — Planning the Database Copy

**Mode:** Hands-on (you do this yourself)
**Goal:** Before you move a single byte, understand *what* you're copying, *which method* you'll use, and *what can go wrong* — then pre-flight the target server.

**Time:** ~30 minutes

> This is the plan for the next two labs. You'll copy the `appdb` database from **`ubuntu-old-db`** to **`ubuntu-new-db`**, then repoint the app at the new server. Nothing on `ubuntu-old-db` is destroyed — a copy is not a move.

---

## 1. What you're copying (and what you're not)

| | |
|---|---|
| **Copying** | The **schema and data** of `appdb` — 3 tables, their foreign keys, indexes, column types, and `AUTO_INCREMENT` counters |
| **From → To** | `ubuntu-old-db` (MySQL 8) → `ubuntu-new-db` (MySQL 8), **server to server, across the network** |
| **Not copying** | The **users and grants** — `appuser` does *not* come across in a database dump. You recreate it on the target. This surprises people; see §5. |
| **Not touching** | `ubuntu-app`. The app keeps running against `old-db` until *you* repoint it, in file 14. |

```
   ubuntu-old-db                    ubuntu-new-db                ubuntu-app
   ┌──────────────┐                 ┌──────────────┐             ┌──────────┐
   │  MySQL 8     │ ──── copy ────► │  MySQL 8     │  ◄── then ──│  Nginx   │
   │  appdb       │                 │  appdb       │   repoint   │  + PHP   │
   │  (4/6/5 rows)│                 │  (empty)     │             └──────────┘
   └──────────────┘                 └──────────────┘
```

**This is a real-world shape.** Moving a database to newer hardware, a new data centre, or a cloud instance is exactly this: dump, transfer, load, verify, cut over.

---

## 2. Logical vs physical — why we dump instead of copying files

Your instinct might be to copy MySQL's data files (`/var/lib/mysql`) straight across with `scp`. **Don't.**

| Approach | What it is | Verdict |
|----------|-----------|---------|
| **Logical dump** (`mysqldump`) ✅ | Export the database as **SQL text** — `CREATE TABLE` + `INSERT` statements — and replay it on the target | **Our choice.** Portable across versions and OSes, human-readable, inspectable, easy to fix by hand |
| Physical copy (raw files / `CLONE` plugin) | Copy InnoDB's binary files | Fast for huge databases, but the server must be **stopped** (or the clone plugin configured), and it's sensitive to version and config differences. Overkill here |
| Replication | Make `new-db` a replica, let it sync, then promote it | The near-zero-downtime professional answer. Many moving parts — worth *knowing about*, not doing today |

> **The rule of thumb:** under a few tens of GB, **logical dump wins on simplicity and safety**. It's plain text — if something goes wrong you can *open the file and look*. You cannot do that with a binary tablespace.

---

## 3. The three methods you'll actually use

The dump is always the same; what differs is **how the SQL gets from A to B**. You'll try all three and see why each exists.

| # | Method | The shape of it | When you'd use it |
|---|--------|-----------------|-------------------|
| **1** | **Dump → file → transfer → import** (file 13) | `mysqldump > f.sql`, `scp` it, `mysql < f.sql` | **The default.** You get a file you can keep, inspect, and re-run. Best when you want a backup artefact as a by-product |
| **2** | **SSH pipe** (file 14) | `mysqldump \| ssh new-db "mysql"` | One command, **no intermediate file**. Great when disk is tight or the DB is large. Nothing to clean up — but nothing to keep, either |
| **3** | **Pull over the MySQL protocol** (file 14) | On `new-db`: `mysqldump -h old-db \| mysql` | No SSH access needed between servers — only the MySQL port. Useful when you only hold DB credentials, not shell accounts |

All three produce **the same result**. Understanding *why you'd pick each* is the actual skill.

---

## 4. What can go wrong (the risk map)

The mechanics take minutes. The failures are all in the **structure**, and the nasty ones are **silent** — the copy "succeeds" and the damage shows up later.

1. **Foreign key order.** The dump recreates tables; if the child (`employees`) loads before the parent (`departments`), the constraint fails. `mysqldump` handles this for you — but you must know *how* (file 13 §3), because the day you hand-edit a dump, it bites.
2. **Missing users and grants.** The dump contains `appdb`, not `appuser`. Import it, point the app at `new-db`, and you get `Access denied` — the data is fine, the *account* doesn't exist yet.
3. **Column types quietly changing.** `DECIMAL(10,2)` → `DOUBLE` means salaries round wrong. Row counts still match. **`COUNT(*)` will not catch this** — only comparing `SHOW CREATE TABLE` will.
4. **Charset / collation drift.** If the two servers have different defaults, text can arrive mangled or sort differently.
5. **`AUTO_INCREMENT` counters lost.** Rows copy, but the counter resets to 1 — the next insert collides with an existing key.
6. **Stale data.** If someone writes to `old-db` *after* you dumped, that row never arrives. (Which is why real cutovers stop writes, or use replication.)

> **The lesson that outlives this course:** "The import finished without errors" is **not** the same as "the copy is correct." You verify by comparing **structure and counts**, not by the absence of a red message. That's file 14 §5, and Day 3's validation lab.

---

## 5. Pre-flight — prepare `ubuntu-new-db` now

🟪 **On `ubuntu-new-db`.** (Your prompt should read `student@ubuntu-new-db`.)

MySQL 8 should already be installed here (same steps as file 07). Confirm it's running, then create the **empty** target database:

```bash
$ systemctl status mysql          # active (running)
$ sudo mysql
```

```sql
mysql> CREATE DATABASE appdb CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
mysql> SHOW DATABASES;            -- appdb is listed, and empty
mysql> USE appdb;
mysql> SHOW TABLES;               -- Empty set
mysql> EXIT;
```

📌 **Checkpoint:** `appdb` exists on `ubuntu-new-db` and contains **no tables**.

> **Why create it with an explicit charset?** So the target's default can't quietly differ from the source's. This is risk #4, pre-empted in one line.

Now record the numbers you're copying — 🟦 on **`ubuntu-old-db`**:

```sql
mysql> SELECT
         (SELECT COUNT(*) FROM appdb.departments) AS departments,
         (SELECT COUNT(*) FROM appdb.employees)   AS employees,
         (SELECT COUNT(*) FROM appdb.projects)    AS projects;
```

Expect **4 / 6 / 5** (plus any employees you added through the form). **Write these down.** They are the first thing you check on the other side.

---

## 6. Pre-flight checklist

- [ ] `ubuntu-new-db` is running MySQL 8, secured (file 08 steps applied)
- [ ] An **empty** `appdb` exists on `ubuntu-new-db`, with `utf8mb4` charset
- [ ] You know the **host-only IPs** (`192.168.56.x`) of `old-db` and `new-db`
- [ ] You have SSH access from `old-db` to `new-db` (needed for methods 1 and 2)
- [ ] You've written down the source row counts (departments / employees / projects)
- [ ] Snapshot taken of `ubuntu-new-db` in its clean, empty state — so you can **redo the copy from scratch** if it goes sideways

> **Take that snapshot.** You are about to run the same copy three different ways. Being able to reset `new-db` to empty in 20 seconds is what makes that practical. Name it **`new-db-empty`**.

---

## Done

You know what's moving, how, and what to watch for. Next: **`13-copy-method-1-dump-file.md`** — the workhorse method: dump to a file, transfer it, import it.
