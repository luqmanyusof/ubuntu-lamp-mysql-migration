# 17 — Validate the Copy

**Mode:** Hands-on
**Goal:** Prove the copy you made on Day 2 is **complete and correct** — not just "it imported without red text." Validation is the discipline that lets you *sign off* a database move.

**Time:** ~45 minutes

> Headers: 🟦 **`ubuntu-old-db`** (the source) · 🟪 **`ubuntu-new-db`** (the copy).
>
> You did the copy yesterday and cut the app over. Today you go back and **prove it was correct** — the step everyone is tempted to skip, and the one that catches silent damage.

---

## 1. The validation mindset

Yesterday's lab hammered one idea: **"no errors during import" is not proof of success.** A copy can move every row and still be wrong — a widened column, a dropped constraint, a reset counter. None of those print an error.

So you verify on three levels, comparing 🟦 source against 🟪 copy each time:

1. **Structural** — the same tables and objects exist.
2. **Quantitative** — the same number of rows in each.
3. **Qualitative** — the actual *content* and *structure* match, byte for byte.

Level 3 is the one that catches what levels 1 and 2 miss.

> **Both your servers are MySQL 8**, so a correct copy should match *exactly* — same types, same collations, same checksums. (In a real cross-**version** migration some differences are expected and intentional; §6 covers that case. Here, any difference is a bug.)

---

## 2. Structural check — the object inventory

Run this on **both** servers and compare the output:

```sql
mysql> SELECT table_name FROM information_schema.tables
       WHERE table_schema = 'appdb' ORDER BY table_name;
```

Expect the same three on each: **departments, employees, projects**.

📌 **Checkpoint:** Both servers list the identical three tables.

---

## 3. Quantitative check — row counts

The numbers you wrote down in file 12. Run on **both**:

```sql
mysql> SELECT
         (SELECT COUNT(*) FROM appdb.departments) AS departments,
         (SELECT COUNT(*) FROM appdb.employees)   AS employees,
         (SELECT COUNT(*) FROM appdb.projects)    AS projects;
```

> ⚠️ **Mind the drift.** You cut the app over to `new-db` yesterday and may have added employees through the form *since*. If so, `new-db` will legitimately have **more** employees than `old-db` — that's not a copy error, it's writes that arrived after the copy. To compare like-for-like, either count only rows that existed at copy time (`WHERE emp_id <= 6`) or just account for the ones you added.

📌 **Checkpoint:** Counts match (once you account for post-cutover writes).

---

## 4. Structural check, level 3 — diff `SHOW CREATE TABLE`

**This is the check that matters**, and the one a row count can never replace. `COUNT(*)` says nothing about whether `salary` is still `DECIMAL(10,2)` or quietly became `DOUBLE`.

The clean way to compare is to dump *just the structure* from each server and diff the two files.

🟦 On **`ubuntu-old-db`**:

```bash
$ mysqldump -u root -p --no-data --skip-comments appdb > /tmp/old-schema.sql
```

🟪 On **`ubuntu-new-db`**:

```bash
$ mysqldump -u root -p --no-data --skip-comments appdb > /tmp/new-schema.sql
```

Now get both files onto one machine and compare. From `ubuntu-new-db`:

```bash
$ scp student@<old-db-IP>:/tmp/old-schema.sql /tmp/
$ diff /tmp/old-schema.sql /tmp/new-schema.sql && echo "IDENTICAL"
```

- `--no-data` dumps **structure only** — every `CREATE TABLE`, exactly as stored.
- `--skip-comments` strips the header comments (timestamps, host names) that would otherwise show as spurious differences.

📌 **Checkpoint:** `diff` prints nothing and you see **`IDENTICAL`**. The schemas — types, sizes, keys, `AUTO_INCREMENT`, charset, collation — match to the byte.

> **If `diff` shows something**, read it. On two MySQL-8 servers the only *legitimate* difference is the `AUTO_INCREMENT=` counter, which moves as you insert rows. Anything else — a changed type, a missing `UNIQUE`, a dropped `FOREIGN KEY` — is a real defect in the copy, and now you've caught it instead of shipping it.

---

## 5. Qualitative check — checksums

Row counts match and structures match. Last question: is the **data content** identical? `CHECKSUM TABLE` fingerprints a table's contents.

Run on **both** servers:

```sql
mysql> CHECKSUM TABLE appdb.departments, appdb.projects;
```

Compare the number per table between source and copy.

> **Use checksums on tables you did *not* write to after the copy** — `departments` and `projects` are ideal. Skip `employees` if you added rows through the form post-cutover: its contents legitimately diverged, and a mismatch there is drift, not corruption. To checksum it fairly, compare only the original rows:
> ```sql
> mysql> SELECT MD5(GROUP_CONCAT(emp_id, name, email, salary, hired_on ORDER BY emp_id))
>        FROM appdb.employees WHERE emp_id <= 6;
> ```
> Run that on both — identical hashes mean the original six rows are byte-identical.

📌 **Checkpoint:** `departments` and `projects` checksums match between the two servers.

---

## 6. When differences are *expected* — the real migration

Everything above assumed same-version, so **any** difference is a bug. A real MySQL **5→8** migration is different: you *intentionally* change things on the way — convert `utf8` → `utf8mb4`, rename a reserved-word column, switch MyISAM → InnoDB (files 15–16). There, a blind `diff` and a checksum mismatch are **expected**, and validation shifts from "prove they're identical" to "prove every difference was deliberate."

The discipline is the same three levels; only the pass criteria change:

| | Same-version copy (yours) | Cross-version migration (the trainer's) |
|---|---|---|
| Schema `diff` | Must be identical (bar `AUTO_INCREMENT`) | Differences allowed **if** each was an intended fix |
| Checksums | Must match | Differ on any table you converted; spot-check instead |
| Row counts | Must match | Must **still** match — counts never change on a clean migration |

> **The takeaway:** row counts are the invariant that holds in *both* worlds. Structure and checksums are where "identical copy" and "correct migration" part ways.

---

## 7. Sign-off

Your copy is validated when:

- [ ] Object inventory matches — same three tables on both servers
- [ ] Row counts match (accounting for any post-cutover writes)
- [ ] `SHOW CREATE TABLE` / schema `diff` is **identical** bar the `AUTO_INCREMENT` counter
- [ ] Checksums match on tables you didn't write to after cutover
- [ ] You can explain *why* any difference that remains is legitimate

Record the results — this checklist is your acceptance evidence. "I diffed the schemas and they were identical" is a sentence you can put your name to; "it imported fine" is not.

Next: **`18-mysql-admin-deeper.md`** — day-to-day administration of your MySQL 8 servers.
