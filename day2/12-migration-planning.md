# 12 — Migration Planning

**Mode:** Instructor demo (trainees follow conceptually and take notes)
**Goal:** Understand exactly *what* we're migrating, *how*, and *what can go wrong* — before touching any data.

**Time:** ~30–40 minutes discussion

---

## 1. What we are migrating (and what we are not)

| | |
|---|---|
| **Migrating** | The **data and schema** of a MySQL **5.x** database on `ubuntu-source` → a MySQL **8** server on `ubuntu-target` |
| **Type** | **Server-to-server** (two separate hosts) |
| **NOT migrating** | The application. App migration is **out of scope.** |

The sample PHP app from this morning is only proof the target stack works. The migration is purely database-to-database.

---

## 2. The two servers, side by side

```
   ubuntu-source                         ubuntu-target
   ┌────────────────┐                    ┌────────────────┐
   │  MySQL 5.x     │  ── dump file ──►  │  MySQL 8       │
   │  (old data)    │    (mysqldump)     │  (fresh)       │
   └────────────────┘                    └────────────────┘
```

Our chosen method: **logical dump-and-load**.

1. On **source**, run `mysqldump` to produce a `.sql` file (schema + data as SQL statements).
2. **Transfer** that file to the target (over SSH/`scp`).
3. On **target**, **import** the file into MySQL 8.

---

## 3. Why logical dump-and-load (vs alternatives)?

| Method | What it is | Why we chose / skipped it |
|--------|-----------|---------------------------|
| **Logical dump (`mysqldump`)** ✅ | Export as SQL text, re-import | Version-agnostic, human-readable, handles 5→8 well, easy to teach and inspect. **Our choice.** |
| Physical copy (files / clone) | Copy raw InnoDB files | Version-sensitive, brittle across 5→8. Skip. |
| Replication cutover | Set up 5→8 replication, switch | Powerful for near-zero downtime, but far more moving parts than this course needs. Mention only. |

For a one-time 5→8 move of a modest database, **logical dump-and-load is the standard, safe choice.**

---

## 4. What can go wrong (the risk map)

The mechanical steps take ~20–40 minutes. The *risk* is in the differences between 5.x and 8. Things to anticipate:

1. **Authentication plugin change** — apps/users defined with `mysql_native_password` may fail against 8's `caching_sha2_password` default.
2. **Reserved words** — a 5.x column named e.g. `rank`, `groups`, `system` became reserved in 8 and can break on import.
3. **SQL mode strictness** — 8 is stricter (e.g. zero dates, `GROUP BY` behavior).
4. **Character set / collation** — moving to `utf8mb4` / `utf8mb4_0900_ai_ci`; collation mismatches can surface.
5. **MyISAM tables** — should generally be converted to InnoDB.
6. **Deprecated syntax** — some 5.x SQL no longer valid in 8.

> **We do not solve all of these today.** Today (Day 2 PM) we **get the data across**. Resolving these differences is **Day 3 AM** (files 15–17). This split is deliberate and protects our timing.

---

## 5. The plan for the next two labs

- **File 13 — Backup & Dump:** prepare the source, take a **consistent** `mysqldump`, and set aside a **known-good copy**.
- **File 14 — Migration Execution:** transfer the dump, open the firewall narrowly, import into MySQL 8, reach a **clean stopping point**.

---

## 6. Safeguards we're using (state them aloud)

- ✅ Full migration was **pre-tested** before this session.
- ✅ **Snapshots** of both VMs taken right before this demo.
- ✅ A **known-good dump** is on standby if the live dump misbehaves.
- ✅ Clear **stopping point**: end of PM = data loaded in MySQL 8 (validation is tomorrow).
- ✅ We never expose MySQL widely — 3306 opens **from the source IP only**, and only if the method needs it.

---

## 7. Pre-flight checklist (before file 13)

- [ ] Source VM has a MySQL 5.x instance with a sample database to migrate
- [ ] You know the source DB name and a user that can read all of it
- [ ] Target MySQL 8 is running (file 07) and secured (file 08)
- [ ] Both VMs snapshotted
- [ ] Known-good dump file is available on standby

> **Trainer note (Luqman):** If the source doesn't yet have a MySQL 5.x sample DB, that setup happens as demo prep, not in front of the class. Have a representative schema — ideally one that *includes* at least one gotcha (a reserved-word column or a MyISAM table) so Day 3 has something real to fix.

Next: **`13-backup-and-dump.md`**.
