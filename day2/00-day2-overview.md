# Day 2 — LAMP + App (AM) / Migration Begins (PM)

**AM mode:** Hands-on labs
**PM mode:** Instructor demo

**AM goal:** A full **LAMP stack** (Linux + Apache + MySQL 8 + PHP) on the target VM, serving a working one-page PHP app backed by MySQL.
**PM goal:** Begin the **MySQL 5 → 8 migration** — plan it, dump the source, and get the data into MySQL 8 on the target.

---

## Where we are

Day 1 left you with two clean Ubuntu VMs (`day1-clean` snapshot):

- **ubuntu-source** — will host the old **MySQL 5.x** database (our migration *source*).
- **ubuntu-target** — gets the full LAMP stack today and receives the migrated data.

---

## Morning (AM) — build LAMP, hands-on

You build the stack piece by piece on **ubuntu-target**:

| # | File | You achieve |
|---|------|-------------|
| 06 | `06-mysql-architecture.md` | Understand how MySQL is structured (before installing) |
| 07 | `07-install-mysql8.md` | Install & run MySQL 8 Community |
| 08 | `08-mysql-security-basics.md` | Secure MySQL, create users & a database |
| 09 | `09-apache-setup.md` | Install Apache, open the firewall for web |
| 10 | `10-php-setup.md` | Install PHP and connect it to MySQL |
| 11 | `11-sample-app.md` | Deploy a one-page PHP + MySQL app |

By lunch: browse to the target VM's IP and see a live PHP page reading from MySQL 8.

## Afternoon (PM) — migration begins, instructor demo

The trainer drives; trainees watch, take notes, and follow along conceptually:

| # | File | Covers |
|---|------|--------|
| 12 | `12-migration-planning.md` | Strategy, risks, what "server-to-server" means here |
| 13 | `13-backup-and-dump.md` | Prepare source, take a consistent `mysqldump` |
| 14 | `14-migration-execution.md` | Load the dump into MySQL 8 on the target |

> **Scope reminder:** This is a **database** migration (MySQL 5.x → MySQL 8), **server-to-server**. Application migration is **out of scope**. The sample PHP app exists only to prove the target stack works.

---

## The firewall thread today

- **AM (Apache):** open web ports → `sudo ufw allow 'Apache Full'` (80/443) — in file 09.
- **PM (MySQL):** open 3306 **only from the source VM's IP** → in file 14.

We never open 3306 to the whole network. That restraint is part of the lesson.

---

## Timing & risk note (for the trainer)

The mechanical migration is quick (~20–40 min), but the *narrated demo* runs 2.5–4 hours once you explain each step and field questions. The main risk is **troubleshooting overrun**.

Safeguards baked into today:

- **Pre-test** the full migration before the session and snapshot both VMs.
- Take a fresh **snapshot of both VMs** right before the PM demo.
- **Split the work:** today (Day 2 PM) we only *get the data across*. Resolving 5→8 differences is **Day 3 AM**.
- Keep a **known-good dump file** on standby in case the live dump misbehaves.
- Aim for a **clean stopping point** at the end of PM: data is in MySQL 8, even if not yet validated.

---

## Day 2 success checklist

- [ ] MySQL 8 running and secured on target; test DB + user created
- [ ] Apache serving the default page over HTTP (firewall opened)
- [ ] PHP installed; `phpinfo()` works
- [ ] Sample app loads in a browser and reads/writes MySQL 8
- [ ] Source MySQL 5.x dump produced successfully
- [ ] Dump imported into MySQL 8 on target (data present, even if unvalidated)
- [ ] Snapshot `day2-migration-loaded` taken on both VMs

Next: **Day 3** — finish the migration (resolve 5→8 differences, validate) and go deeper on LAMP and security.
