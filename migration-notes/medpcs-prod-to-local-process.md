# medpcs — production → local MySQL 8 (process note)

How the `medpcs` production database (CentOS, MySQL 5.x) is reproduced on the local
Ubuntu MySQL 8 server. Structure first, then data — two separate passes, both driven
from DBeaver.

This is trainer-side prep, not participant material. Participants never touch `medpcs`.

---

## 1. Generate the DDL from production

Structure only — no data in this pass.

1. Connect to production in DBeaver and expand it in the **Database Navigator**.
2. Expand `medpcs` → **Tables**. Click the first table, scroll to the last,
   **Shift-click** it to select all 282. (Selecting the `medpcs` schema itself also
   works and pulls the whole database in one go.)
3. Right-click the selection → **Generate SQL** → **DDL**.
4. In the preview dialog, turn **off** *Compact SQL* — you need the DDL readable to
   edit the charsets in step 2. Leave *Show comments* on; the column comments in
   `medpcs` carry real meaning (`'GP-General Practice, SS-Specialist Services'`).
5. **Copy** to a SQL editor, or **Save** straight to a `.sql` file.

> The preview dialog can be slow to render at 282 tables. It is working — let it finish
> rather than clicking again.

## 2. Convert latin1 → utf8mb4

The generated DDL comes out of MySQL 5.x carrying `latin1`. Change it to `utf8mb4`,
with collation `utf8mb4_0900_ai_ci`.

`utf8mb4_0900_ai_ci` is MySQL 8's default collation and does not exist in MySQL 5.x —
this conversion is a one-way step toward 8, not something you can round-trip back.

## 3. Check against the sample

`medpcs-structure-16-7-2026.sql` (16 July 2026) is a worked example of the corrected
output — 282 tables, all `CHARSET=utf8mb4`, no `latin1` remaining. Use it to see what
"done" looks like.

Two things to know about the sample before copying its style:

- It sets **no explicit `COLLATE`** anywhere. Tables inherit the collation from the
  database default, so the target database must be created as `utf8mb4_0900_ai_ci`
  first or the tables silently take whatever the server default is.
- 50 columns carry their own `CHARACTER SET utf8mb4` override. Column-level settings
  beat the table default, so a table-level change alone will miss them.

## 4. Deploy the structure locally

Run the corrected DDL against the local MySQL 8 server. Create the database with the
right charset/collation *before* running it — see the note above.

```sql
CREATE DATABASE medpcs CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
```

## 5. Copy the data

The structure is already deployed, so this pass only moves rows.

1. In the Navigator, open **production** → `medpcs` → **Tables** and select the tables
   to copy (Shift-click for all).
2. Right-click → **Export Data**. This opens the **Data Transfer** wizard.
3. **Target type:** choose **Database** (not CSV) → *Next*.
4. **Tables mapping:** click **Choose** and pick the local `medpcs` as the target
   container. Every row should now read **existing** in the *Target* column — that
   means DBeaver found the table you deployed in step 4.
   - Any row reading **create** means the name did not match and DBeaver is about to
     make a *new* table from production's latin1 definition — undoing step 2. Fix the
     mapping instead of letting it create.
5. **Extraction settings:** defaults are fine.
6. **Data load settings:** tick **Disable referential integrity checks**. Without it the
   load fails wherever a child row lands before its parent — see the FK note below.
   Leave *Truncate target table* off unless you are deliberately re-running.
7. **Confirm** → *Proceed*.

> **Version note:** paths follow DBeaver 21+. Older builds label the wizard *Data
> Transfer* and nest the option under a different tab, but the flow is the same.

---

## Notes

- **Engines:** the sample is 249 InnoDB / 33 MyISAM. The MyISAM tables come across as
  MyISAM unless converted — they have no foreign keys, no transactions, and MySQL 8
  still accepts them, but they are worth flagging before anyone calls this migration
  finished.
- **Legacy 5.x artifacts** in the DDL: `int(11)` display widths (deprecated in 8.0.17,
  8 will drop them from `SHOW CREATE TABLE`), zerofill columns, and column names
  containing spaces (`Clinic Name`, `Type of Services`) that need backticks everywhere.
- **Structure and data are separate passes.** DDL first, then rows — foreign keys mean
  parent tables need to load before children, or the export has to run with checks off.
- **Users and grants are not in the DDL.** Same lesson Day 2 teaches with `appdb`: a
  structure dump carries no accounts. They are recreated by hand on the target.
