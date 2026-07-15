# 16 — Upgrade Checker

**Mode:** Discussion / optional hands-on (cover if time permits)
**Goal:** Use **MySQL Shell's Upgrade Checker** to automatically detect 5→8 compatibility problems *before* migrating — turning the manual list from file 15 into a generated report.

**Time:** ~30 minutes

> **This is a cross-version tool**, so it belongs to the same "real upgrade" story as file 15 — not to your same-version copy. You *can* run it against your own `ubuntu-old-db` (§3) and it will come back clean, which is itself instructive: a clean report is what a same-version move looks like. The interesting output only appears when the source is MySQL 5.x, as in the trainer's CentOS migration.

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

## 3. Run the checker

**Try it on your own `ubuntu-old-db`** to see what a *clean* report looks like — install `mysql-shell` there and run against localhost:

```bash
$ mysqlsh root@localhost:3306
```
```js
 MySQL> util.checkForServerUpgrade();
```

Because `old-db` is already MySQL 8, the report will show **0 errors** — the "nothing to fix" baseline. That's exactly why your copy to `new-db` was uneventful.

**The revealing run is against a MySQL 5.x source** — the trainer's CentOS server. From a machine that can reach it:

```bash
$ mysqlsh -- util check-for-server-upgrade \
    { --user=root --host=<centos-source-IP> --port=3306 } \
    --target-version=8.0.0 \
    --output-format=TEXT
```

> **Firewall note:** reaching the CentOS source over 3306 needs that port open on it for the checking host — on CentOS that's a **`firewall-cmd`** rich rule scoped to the checking IP (not UFW). Or install `mysql-shell` **on the CentOS box** and run against `localhost`. See the trainer runbook.

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

## 6. Where this fits a real project

For a genuine cross-version upgrade, the checker runs **first** — before you ever take the dump: run it, fix issues at the source, *then* dump the corrected database. Doing it in that order prevents import errors entirely, rather than discovering them mid-load.

Your Day 2 copy skipped this step legitimately: same-version moves have nothing for the checker to find. But make the habit explicit — *the first action in any 5→8 project is to run the upgrade checker against the source.*

> **Trainer note (Luqman):** For a live demo, run it against your CentOS 5.x source seeded with a reserved-word column and a utf8mb3/MyISAM table — the checker lights up with exactly those. Show the report, fix one item, re-run to show it disappear. Contrast with the clean `ubuntu-old-db` run participants can do themselves.

---

## Done

You can generate an authoritative 5→8 compatibility report and drive fixes from it. Next: **`17-post-migration-validation.md`** — prove the migrated data is complete and correct.
