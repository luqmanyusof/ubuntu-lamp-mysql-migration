# 13 — Backup & Dump the Source

**Mode:** Instructor demo
**Goal:** Produce a **consistent, complete `mysqldump`** of the source MySQL 5.x database, ready to load into MySQL 8.

**Time:** ~30 minutes narrated

> Commands run on **ubuntu-source** unless noted. Substitute your real database name for `sourcedb` and your admin user for `root`.

---

## 1. First, know what you're dumping

Log into the source MySQL 5.x and survey it:

```bash
$ mysql -u root -p
```

```sql
mysql> SHOW DATABASES;
mysql> USE sourcedb;
mysql> SHOW TABLES;
mysql> SELECT COUNT(*) FROM some_table;     -- note a couple of row counts to verify later
mysql> SELECT table_name, engine FROM information_schema.tables
       WHERE table_schema = 'sourcedb';     -- spot MyISAM vs InnoDB
mysql> EXIT;
```

**Write down**: database name, table count, and a couple of row counts. We use these to prove the migration was complete (file 17).

📌 **Checkpoint:** You have a record of what "correct" looks like on the source.

---

## 2. Take a filesystem-safe, consistent dump

The key to a trustworthy dump is **consistency** — a snapshot of the data at one moment, even if the DB is in use.

For an **InnoDB** database:

```bash
$ mysqldump -u root -p \
    --single-transaction \
    --routines --triggers --events \
    --databases sourcedb \
    > ~/sourcedb_dump.sql
```

What the flags mean:

| Flag | Why |
|------|-----|
| `--single-transaction` | Consistent snapshot **without locking** the tables (InnoDB) |
| `--routines` | Include stored procedures & functions |
| `--triggers` | Include triggers (on by default, explicit for clarity) |
| `--events` | Include scheduled events |
| `--databases sourcedb` | Include the `CREATE DATABASE` + `USE` statements |

> ⚠️ **If the source has MyISAM tables**, `--single-transaction` does **not** make those consistent. For a course/demo you can briefly stop writes, or add `--lock-tables`. In production you'd plan a maintenance window. Note this out loud — it's a real-world consideration.

📌 **Checkpoint:** The command completes with no error and produces `~/sourcedb_dump.sql`.

---

## 3. Sanity-check the dump file

A dump you didn't inspect is a dump you don't trust.

```bash
$ ls -lh ~/sourcedb_dump.sql          # non-zero, sensible size
$ head -n 30 ~/sourcedb_dump.sql      # header, CREATE DATABASE, version comments
$ grep -c "CREATE TABLE" ~/sourcedb_dump.sql   # roughly matches your table count
$ tail -n 5 ~/sourcedb_dump.sql       # should end with "Dump completed"
```

The last line reading `-- Dump completed` confirms the dump wasn't truncated.

📌 **Checkpoint:** File size is reasonable, `CREATE TABLE` count matches, and the file ends with "Dump completed".

---

## 4. Keep a known-good copy

Protect the dump — this is our safety net.

```bash
$ cp ~/sourcedb_dump.sql ~/sourcedb_dump.KNOWN_GOOD.sql
$ gzip -k ~/sourcedb_dump.sql          # also keep a compressed copy for transfer
$ ls -lh ~/sourcedb_dump*
```

> **Trainer note (Luqman):** This is where the *standby* known-good dump lives. If the live-created dump has any issue during the class, we fall back to a pre-tested one prepared before the session. Say this explicitly so trainees understand the safety net.

---

## 5. (Optional) Schema-only and data-only views for teaching

Handy to *show* the difference between structure and data:

```bash
$ mysqldump -u root -p --no-data --databases sourcedb > ~/schema_only.sql
$ head -n 60 ~/schema_only.sql     # pure CREATE TABLE statements — great for explaining 5→8 diffs
```

This schema-only file is also what we feed the **upgrade checker** on Day 3 (file 16).

---

## Done

You have a consistent, verified dump of the source, plus a known-good backup. Next: **`14-migration-execution.md`** — move it to the target and load it into MySQL 8.
