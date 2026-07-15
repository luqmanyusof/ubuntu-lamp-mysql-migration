# 15 — MySQL 5 vs MySQL 8 Differences

**Mode:** Discussion / reference (cover if time permits)
**Goal:** Understand the real differences between MySQL 5.x and 8, and how each one is fixed — so you can plan a cross-**version** upgrade, not just a same-version copy.

**Time:** ~45 minutes

> **How this relates to what you did.** Your Day 2 copy went between **two MySQL 8 servers**, so you hit *none* of the problems below — a same-version copy has nothing to translate. This file is about the harder case: moving a database *across major versions* (MySQL 5.x → 8), which is exactly the CentOS → Ubuntu migration the trainer runs separately. Treat it as the map you'd need for a real upgrade project. Every fix here is a concrete thing that turns a "20-minute" migration into an afternoon.

---

## 1. Authentication plugin (the #1 gotcha)

| | MySQL 5.x | MySQL 8 |
|---|---|---|
| Default auth plugin | `mysql_native_password` | `caching_sha2_password` |

**Symptom:** An old application or client can connect to 5.x but fails against 8 with errors like *"Authentication plugin 'caching_sha2_password' cannot be loaded"* or *"Access denied"*.

**Fix options:**

- **Preferred (modern):** upgrade the client/driver so it supports `caching_sha2_password`. Then create users normally:
  ```sql
  CREATE USER 'app'@'localhost' IDENTIFIED BY 'Str0ng!';
  ```
- **Compatibility (legacy client that can't be upgraded):** pin the user to the old plugin:
  ```sql
  CREATE USER 'app'@'localhost'
    IDENTIFIED WITH mysql_native_password BY 'Str0ng!';
  -- or for an existing user:
  ALTER USER 'app'@'localhost'
    IDENTIFIED WITH mysql_native_password BY 'Str0ng!';
  ```

> Prefer upgrading the client. Only fall back to `mysql_native_password` when you truly cannot.

---

## 2. Reserved words

MySQL 8 added new reserved words. If a 5.x schema used one as an unquoted identifier, the import fails.

Common new reserved words: `RANK`, `GROUPS`, `ROW`, `ROWS`, `SYSTEM`, `CUME_DIST`, `DENSE_RANK`, `LEAD`, `LAG`, `PERCENT_RANK`, `WINDOW`.

**Symptom:** `ERROR 1064 (42000) ... near 'rank'` during import.

**Fix:** quote the identifier with backticks, or rename the column:

```sql
-- during/after import, reference it quoted:
SELECT `rank` FROM players;

-- or rename to avoid the reserved word entirely:
ALTER TABLE players CHANGE `rank` player_rank INT;
```

> Best practice: fix at the **schema** level (rename or backtick in the dump) so downstream code is unambiguous.

---

## 3. Storage engine: MyISAM → InnoDB

MySQL 8 still supports MyISAM but strongly favors InnoDB (system tables are all InnoDB now).

**Find MyISAM tables** in the migrated DB:

```sql
SELECT table_name, engine
FROM information_schema.tables
WHERE table_schema = 'sourcedb' AND engine = 'MyISAM';
```

**Convert each to InnoDB:**

```sql
ALTER TABLE sometable ENGINE = InnoDB;
```

> Gains: transactions, foreign keys, row-level locking, crash safety. Watch for MyISAM-only features (e.g. `FULLTEXT` existed on MyISAM earlier — InnoDB supports FULLTEXT since 5.6, so usually fine).

---

## 4. Character set & collation

| | MySQL 5.x default | MySQL 8 default |
|---|---|---|
| Charset | `latin1` (older) / `utf8` (3-byte) | `utf8mb4` (true 4-byte UTF-8) |
| Collation | `latin1_swedish_ci` / `utf8_general_ci` | `utf8mb4_0900_ai_ci` |

**Symptoms:** mojibake (garbled non-ASCII text), *"Illegal mix of collations"* errors when joining old and new tables.

**Fix (convert a table to utf8mb4):**

```sql
ALTER TABLE sometable
  CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
```

> ⚠️ Converting charset rewrites the table and can affect index length limits. Test on a copy first. For a demo DB it's straightforward.

---

## 5. Stricter SQL mode

MySQL 8 enables strict modes by default (`ONLY_FULL_GROUP_BY`, `STRICT_TRANS_TABLES`, `NO_ZERO_DATE`, etc.).

**Symptoms:**
- Queries with ambiguous `GROUP BY` now error.
- `'0000-00-00'` dates rejected.
- Out-of-range or truncated values error instead of silently accepting.

**Fixes:**
- **Fix the query/data** (preferred): make `GROUP BY` explicit, replace zero-dates with `NULL` or real dates.
- **Temporary compatibility** (buy time, then fix properly):
  ```sql
  SET GLOBAL sql_mode = 'NO_ENGINE_SUBSTITUTION';
  ```
  Loosening `sql_mode` globally is a stopgap, not a destination.

---

## 6. Removed / deprecated syntax

- `GRANT ... IDENTIFIED BY` no longer creates users implicitly — use `CREATE USER` then `GRANT`.
- Some old spatial/`utf8`-alias behaviors changed.
- `NO_AUTO_CREATE_USER` mode removed (it's now always on).

**Symptom:** dump lines that worked in 5.x error on import.

**Fix:** rewrite to the 8-compatible form (split account creation from grants, as we already do in file 08/14).

---

## 7. Why your copy didn't hit any of these

Worth making explicit, because it's the whole reason your Day 2 lab was smooth: **a same-version copy has no version gap to cross.** Same auth-plugin default on both servers, same reserved-word list, same `utf8mb4_0900_ai_ci` collation, same InnoDB, same `sql_mode`. The dump you took on `old-db` and replayed on `new-db` needed **zero** translation — which is exactly why your `SHOW CREATE TABLE` diff in file 17 came back identical.

Change *one* server to MySQL 5.7 and every section above becomes a live problem. That's the difference between a **copy** (same version, expect identical) and a **migration** (across versions, expect — and account for — deliberate change).

📌 **Checkpoint (discussion):** For each difference above, say whether it could affect your `old-db → new-db` copy. (Answer: none — both are MySQL 8. Each one *would* matter for a 5.7 → 8 move.)

> The **upgrade checker** (file 16) finds most of these *automatically, before* you import — the next file shows how.

---

## Quick reference table

| Difference | Symptom | Fix |
|-----------|---------|-----|
| Auth plugin | Access denied / plugin can't load | Upgrade client, or `IDENTIFIED WITH mysql_native_password` |
| Reserved words | `ERROR 1064 near '<word>'` | Backtick or rename column |
| MyISAM | Legacy engine | `ALTER TABLE ... ENGINE=InnoDB` |
| Charset/collation | Garbled text / collation mix | `CONVERT TO CHARACTER SET utf8mb4` |
| Strict SQL mode | GROUP BY / zero-date errors | Fix query/data; temp loosen `sql_mode` |
| Deprecated syntax | Old dump lines error | Rewrite to 8-compatible SQL |

Next: **`16-upgrade-checker.md`** — automate finding these.
