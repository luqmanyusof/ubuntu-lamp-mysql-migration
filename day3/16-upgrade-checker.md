# 16 — Upgrade Checker

**Mode:** Instructor demo
**Goal:** Use **MySQL Shell's Upgrade Checker** to automatically detect 5→8 compatibility problems *before* (or alongside) migrating — turning the manual list from file 15 into a generated report.

**Time:** ~30 minutes

---

## 1. What the upgrade checker is

**MySQL Shell (`mysqlsh`)** includes a built-in utility, `util.checkForServerUpgrade()`, that scans a server (or a dump) and reports anything that would break or change when moving to MySQL 8 — reserved words, removed features, charset issues, orphaned objects, and more.

It's the official, Oracle-supported way to de-risk a 5→8 upgrade. Running it turns "hope it imports" into "here's the list, fix these first."

---

## 2. Install MySQL Shell

MySQL Shell is a separate package from the server. Install it on the **Ubuntu target** (or wherever you can reach the CentOS source):

```bash
$ sudo apt update
$ sudo apt install mysql-shell -y
```

> If `mysql-shell` isn't in the default repo, add Oracle's APT repo (`mysql-apt-config`) and try again. Confirm with:

```bash
$ mysqlsh --version
```

📌 **Checkpoint:** `mysqlsh --version` prints a version.

---

## 3. Run the checker against the source (ideal: before migrating)

The most useful run is against the **live CentOS 5.x** server. From a machine that can reach it:

```bash
$ mysqlsh -- util check-for-server-upgrade \
    { --user=root --host=<centos-source-IP> --port=3306 } \
    --target-version=8.0.0 \
    --output-format=TEXT
```

Or interactively inside the shell:

```bash
$ mysqlsh root@<centos-source-IP>:3306
```
```js
 MySQL> util.checkForServerUpgrade();
```

> **Firewall note:** reaching the CentOS source over 3306 needs that port open on it for your checking host — on CentOS that's a **`firewall-cmd`** rich rule scoped to the checking IP (not UFW). If you'd rather not open it, install `mysql-shell` **on the CentOS box** and run against `localhost`. See the trainer runbook.

---

## 4. Read the report

The output is grouped into checks, each with a severity:

- **Error** — will break the upgrade/import. Must fix.
- **Warning** — may change behavior. Review.
- **Notice** — informational.

Typical findings map straight onto file 15:

```
1) Usage of db objects with names conflicting with new reserved keywords
   Error: table `sourcedb`.`players` column `rank` ...
   → rename or quote (file 15 §2)

2) Table names in the mysql schema conflicting with ... 
3) Usage of utf8mb3 charset
   Warning: convert to utf8mb4 (file 15 §4)

4) Issues reported by 'check table x for upgrade' command
5) Removed system variables ...
```

📌 **Checkpoint:** You can point at each **Error** in the report and name the fix from file 15.

---

## 5. Fix, then re-run

Workflow:

1. Run checker → get list.
2. Apply fixes (on the source, or in the dump) — rename reserved words, convert charsets/engines.
3. **Re-run** the checker.
4. Repeat until **zero Errors** remain (Warnings/Notices reviewed and accepted).

A clean checker run is your green light that the import will go smoothly.

---

## 6. Where this fits our timeline

In an ideal project you run the checker **before** taking the dump (Day 2). We introduce it on Day 3 for teaching flow — but state clearly: *in real projects, run the upgrade checker first, fix at the source, then dump.* It prevents most of the file-14 import errors entirely.

> **Trainer note (Luqman):** If you pre-seeded the source with a reserved-word column and a utf8mb3/MyISAM table (as suggested in file 12), the checker will light up with exactly those — a satisfying, concrete demo. Show the report, fix one item live, re-run to show it disappear.

---

## Done

You can generate an authoritative 5→8 compatibility report and drive fixes from it. Next: **`17-post-migration-validation.md`** — prove the migrated data is complete and correct.
