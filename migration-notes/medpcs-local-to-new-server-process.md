# medpcs — local → new DB server (process note)

Second leg of the move. The local MySQL 8 server now holds a converted, verified
`medpcs`; this pushes it to the **new production server**.

Trainer-side prep. Participants never touch `medpcs`.

**This leg is MySQL 8 → MySQL 8.** The version and charset work already happened on the
way in from production ([[medpcs-prod-to-local-process]]). Nothing is meant to change
here — so unlike the first leg, **any** difference between local and new is a defect,
not an intended fix.

---

## 1. Deploy the DDL to the new server

Reuse the **same corrected DDL file** from the first leg — the one already converted to
`utf8mb4`. Do not regenerate it from production; that would reintroduce `latin1`.

Create the database first, so tables inherit the right collation (the DDL carries no
explicit `COLLATE`):

```sql
CREATE DATABASE medpcs CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
```

Then run the DDL against the new server.

## 2. Validate the structure before loading any data

Confirm all 282 tables arrived and match, on both servers:

```sql
SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='medpcs';
```

**Schema Compare is a DBeaver PRO feature** — it isn't in Community edition. Two ways
forward:

- **On PRO:** right-click the two schemas → **Compare/Migrate** → **Compare Structures**.
- **On Community (or to have evidence you can keep):** dump structure from each and
  diff, exactly as `day3/17-post-migration-validation.md` teaches:

```bash
$ mysqldump -u root -p --no-data --skip-comments medpcs > /tmp/local-schema.sql
$ mysqldump -u root -p --no-data --skip-comments medpcs > /tmp/new-schema.sql   # on new
$ diff /tmp/local-schema.sql /tmp/new-schema.sql && echo "IDENTICAL"
```

Both servers are MySQL 8, so expect **`IDENTICAL`**. The only legitimate difference is
the `AUTO_INCREMENT=` counter. Anything else — a changed type, a missing index, a
dropped foreign key — is a real defect, and this is the moment to catch it.

Validate structure *before* loading data. Fixing a wrong column type is trivial on an
empty table and painful on a loaded one.

## 3. Transfer the data

Same **Export Data** wizard as the first leg, local → new:

1. Navigator → **local** `medpcs` → **Tables**, select all.
2. Right-click → **Export Data** → target type **Database** → *Next*.
3. **Tables mapping:** *Choose* the `medpcs` container on the **new server**. Every row
   must read **existing**. A row reading **create** means the mapping missed and
   DBeaver will invent a table — stop and fix it.
4. **Data load settings:** tick **Disable referential integrity checks** (249 InnoDB
   tables with foreign keys; child rows will otherwise land before parents).
5. **Confirm** → *Proceed*.

## 4. Validate the data

Structure was checked in step 2; now the rows.

```sql
SELECT table_name, table_rows FROM information_schema.tables
 WHERE table_schema='medpcs' ORDER BY table_name;
```

`table_rows` is an **estimate for InnoDB** — fine for spotting an empty table, not
proof. For tables that matter, `SELECT COUNT(*)` and compare, then fingerprint contents:

```sql
CHECKSUM TABLE medpcs.<table>;
```

Nothing writes to `medpcs` between the two servers on this leg, so **checksums should
match on every table**. A mismatch here is corruption, not drift.

---

## Notes

- **Users and grants do not travel.** Not in the DDL, not in the data export. Recreate
  the application accounts by hand on the new server — the same lesson Day 2 lands with
  `appdb` and `Access denied` after a clean copy.
- **Re-enable referential integrity** after the load if you disabled it at session level,
  and confirm the foreign keys are actually enforced on the new server rather than
  merely present.
- **The 33 MyISAM tables** copy as MyISAM. Still worth resolving before this is called
  finished.
- **Don't decommission the local copy** until step 4 passes on the new server. It is the
  rollback.
