# 17 — Post-Migration Validation

**Mode:** Instructor demo → into hands-on
**Goal:** Prove the migration is **complete and correct** — not just "it imported without red text." Validation is what lets you sign off a migration.

**Time:** ~40 minutes

---

## 1. The validation mindset

"No errors during import" is **not** proof of success. We verify on three levels:

1. **Structural** — same databases, tables, and objects exist.
2. **Quantitative** — same number of rows in each table.
3. **Qualitative** — the actual data content matches (checksums/spot checks).

Compare **source (5.x)** against **target (8)** for each.

---

## 2. Structural check — object inventory

**On the source:**

```sql
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'sourcedb' ORDER BY table_name;

SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='sourcedb';   -- table count
SELECT routine_name, routine_type FROM information_schema.routines WHERE routine_schema='sourcedb';
SELECT trigger_name FROM information_schema.triggers WHERE trigger_schema='sourcedb';
```

**On the target:** run the identical queries and compare the lists.

📌 **Checkpoint:** Table list, routine list, and trigger list match between source and target.

---

## 3. Quantitative check — row counts

Generate per-table row counts on **both** servers and diff them.

Quick approach — the approximate counts from metadata (fast, good first pass):

```sql
SELECT table_name, table_rows
FROM information_schema.tables
WHERE table_schema = 'sourcedb'
ORDER BY table_name;
```

> `table_rows` is an **estimate** for InnoDB. For authoritative counts, run exact counts per table:

```sql
SELECT COUNT(*) FROM sourcedb.each_table;   -- repeat per table
```

A handy way to generate the exact-count statements automatically:

```sql
SELECT CONCAT('SELECT ''', table_name, ''' AS tbl, COUNT(*) FROM `', table_name, '`;')
FROM information_schema.tables
WHERE table_schema = 'sourcedb';
```

Copy its output, run on both, compare.

📌 **Checkpoint:** Exact row counts match table-by-table between source and target.

---

## 4. Qualitative check — data integrity (checksums)

Row counts can match while contents differ. `CHECKSUM TABLE` gives a fingerprint of a table's data:

**On both servers:**

```sql
CHECKSUM TABLE sourcedb.customers, sourcedb.orders;
```

Compare the numbers per table.

> ⚠️ **Caveat:** checksums can legitimately differ across 5→8 if you **intentionally changed** things during migration (charset conversion, engine change, reserved-word rename). Use checksums on tables you migrated **unchanged**. For changed tables, fall back to targeted spot checks:

```sql
-- spot-check specific known rows
SELECT * FROM sourcedb.customers WHERE id IN (1, 500, 999) ORDER BY id;
```

Run identical spot checks on both and eyeball the results.

📌 **Checkpoint:** Unchanged tables have matching checksums; changed tables pass spot checks.

---

## 5. Object-level correctness

- **Foreign keys** present and valid:
  ```sql
  SELECT table_name, constraint_name FROM information_schema.table_constraints
  WHERE table_schema='sourcedb' AND constraint_type='FOREIGN KEY';
  ```
- **Indexes** present:
  ```sql
  SHOW INDEX FROM sourcedb.orders;
  ```
- **AUTO_INCREMENT** continues from the right value (so new inserts don't collide):
  ```sql
  SELECT table_name, auto_increment FROM information_schema.tables
  WHERE table_schema='sourcedb' AND auto_increment IS NOT NULL;
  ```

📌 **Checkpoint:** Keys, indexes, and auto-increment values look correct.

---

## 6. (Optional) "App still works" check

> **This section is optional — the trainer keeps or drops it based on time. It is a nice, tangible finish if the schedule allows.**

If a lightweight app can point at the migrated `sourcedb`, do a real end-to-end check:

1. Configure a test app/user (created in file 14 §5) to connect to the migrated database on MySQL 8.
2. Load a page that reads data → confirm expected records appear.
3. Perform one write → confirm it persists and reads back.

This demonstrates that not only the data, but **connectivity and the auth-plugin choice**, are correct in practice.

> Remember: full application migration is **out of scope**. This is only a confidence check that the migrated database serves a client correctly — not a migration of the app itself.

📌 **Checkpoint (if run):** A client reads and writes the migrated data on MySQL 8 successfully.

---

## 7. Sign-off

Migration is validated when:

- [ ] Object inventory matches (tables, routines, triggers)
- [ ] Exact row counts match table-by-table
- [ ] Unchanged tables checksum-match; changed tables pass spot checks
- [ ] Foreign keys, indexes, auto-increment correct
- [ ] (Optional) A client reads/writes the migrated DB successfully

Record the results. This checklist is the migration's acceptance evidence.

Next: **`18-mysql-admin-deeper.md`** — day-to-day administration of your new MySQL 8 server.
