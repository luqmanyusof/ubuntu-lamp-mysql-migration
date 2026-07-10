# 12 — Migration Planning

**Mode:** Instructor demo (trainees follow conceptually and take notes — **you do not migrate anything yourself**)
**Goal:** Understand exactly *what* the trainer is migrating, *how*, and *what can go wrong* — before touching any data.

**Time:** ~30–40 minutes discussion

> **This is a demo.** The trainer runs it on a **separate CentOS → Ubuntu pair** (the real legacy database is on CentOS). Your own `ubuntu-app` / `ubuntu-db` from this morning are **not** involved and stay exactly as you left them. The full operational steps live in the trainer's runbook (`trainer-only/centos-mysql5-to-ubuntu-mysql8-migration.md`).

---

## 1. What is being migrated (and what is not)

| | |
|---|---|
| **Migrating** | The **data and schema** of a MySQL **5.x** database on a **CentOS** server (`centos-db`) → a fresh MySQL **8** server on a separate **Ubuntu** host (`ubuntu-db-new`) |
| **Type** | **Server-to-server**, and also **cross-OS** (CentOS → Ubuntu) |
| **NOT migrating** | The application. App migration is **out of scope.** |

The morning's two-tier app is only proof a target stack works. This migration is purely database-to-database.

---

## 2. The two servers, side by side

```
   centos-db (CentOS)                    ubuntu-db-new (Ubuntu)
   ┌────────────────┐                    ┌────────────────┐
   │  MySQL 5.x     │  ── dump file ──►  │  MySQL 8       │
   │  (old data)    │    (mysqldump)     │  (fresh)       │
   └────────────────┘                    └────────────────┘
```

The chosen method: **logical dump-and-load**.

1. On the **CentOS source**, run `mysqldump` to produce a `.sql` file (schema + data as SQL statements).
2. **Transfer** that file to the target (over SSH/`scp`).
3. On the **Ubuntu target**, **import** the file into MySQL 8.

> **Why logical (not a file copy)?** Physically copying MySQL data files across **different OSes and major versions** (CentOS 5.x → Ubuntu 8) is brittle and unsupported. A logical dump is plain SQL text — OS- and version-agnostic — which is exactly why it's the right tool for a cross-OS 5→8 move.

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
- ✅ MySQL is never exposed widely — if a network path is opened at all, 3306 is scoped **from one source IP only** (and on CentOS that's a `firewall-cmd` rule, not UFW).

---

## 7. Pre-flight checklist (before file 13)

- [ ] CentOS source has a MySQL 5.x instance with a sample database to migrate
- [ ] You know the source DB name and a user that can read all of it
- [ ] The separate Ubuntu MySQL 8 target is running and secured
- [ ] Both hosts snapshotted
- [ ] Known-good dump file is available on standby

> **Trainer note (Luqman):** Full operational detail — CentOS `yum`/`firewalld`/SELinux, `my.cnf` paths, dump flags, rollback — is in `trainer-only/centos-mysql5-to-ubuntu-mysql8-migration.md`. Rehearse from that runbook. Seed the CentOS source with a representative schema that *includes* at least one gotcha (a reserved-word column or a MyISAM table) so Day 3 has something real to fix. This setup is demo prep, done before class, never live in front of trainees.

Next: **`13-backup-and-dump.md`**.
