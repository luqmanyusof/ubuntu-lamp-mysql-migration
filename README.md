# Ubuntu + LAMP & MySQL 5→8 Migration — 3-Day Coaching

A hands-on, 3-day training program that takes you from a bare VirtualBox host to two secured Ubuntu servers running a full LAMP stack, and through a complete **server-to-server MySQL 5.x → 8 migration**.

Materials are trainee-facing, step-by-step lab guides — every command, expected output, and checkpoint included.

---

## What you'll build

Two Ubuntu Server VMs in VirtualBox:

- **source** — hosts the legacy MySQL 5.x database (migrate *from*)
- **target** — full LAMP stack + MySQL 8 (migrate *to*)

By the end you can install and secure Ubuntu, stand up Apache + PHP + MySQL 8, migrate a MySQL 5.x database, validate it, harden the whole stack, and troubleshoot failures methodically.

---

## Structure

### Day 1 — Ubuntu Foundations (hands-on)
Two secured, SSH-accessible Ubuntu Server VMs.

| File | Topic |
|------|-------|
| `day1/00-day1-overview.md` | Day map & checklist |
| `day1/01-virtualbox-setup.md` | VirtualBox + VM creation |
| `day1/02-download-ubuntu-iso.md` | Download & verify the ISO |
| `day1/03-ubuntu-installation.md` | Install Ubuntu Server |
| `day1/04-linux-admin-essentials.md` | Everyday Linux administration |
| `day1/05-system-services-security.md` | Services, SSH, UFW firewall |

### Day 2 — LAMP + App (AM) / Migration Begins (PM)
LAMP stack + working PHP app, then the migration starts.

| File | Topic |
|------|-------|
| `day2/00-day2-overview.md` | Day map & checklist |
| `day2/06-mysql-architecture.md` | How MySQL is structured |
| `day2/07-install-mysql8.md` | Install MySQL 8 Community |
| `day2/08-mysql-security-basics.md` | Secure MySQL; users & DB |
| `day2/09-apache-setup.md` | Apache + web firewall rules |
| `day2/10-php-setup.md` | PHP + MySQL connectivity |
| `day2/11-sample-app.md` | One-page PHP + MySQL app |
| `day2/12-migration-planning.md` | Migration strategy & risks |
| `day2/13-backup-and-dump.md` | Consistent `mysqldump` |
| `day2/14-migration-execution.md` | Transfer & import into MySQL 8 |

### Day 3 — Finish Migration + Deepen LAMP & Security
Resolve 5→8 differences, validate, then admin & hardening.

| File | Topic |
|------|-------|
| `day3/00-day3-overview.md` | Day map & checklist |
| `day3/15-mysql5-vs-mysql8-differences.md` | The real differences & fixes |
| `day3/16-upgrade-checker.md` | MySQL Shell upgrade checker |
| `day3/17-post-migration-validation.md` | Prove it's complete & correct |
| `day3/18-mysql-admin-deeper.md` | Backups, logs, config, tuning |
| `day3/19-security-hardening.md` | Consolidated hardening pass |
| `day3/20-troubleshooting-workshop.md` | Guided break/fix scenarios |

---

## How to use these guides

- Commands are in code blocks. `$` = normal user, `#`/`sudo` = admin.
- 📌 **Checkpoint** boxes confirm a step worked before you move on.
- ⚠️ **Watch out** boxes flag the common mistakes.
- **Trainer notes** give live-delivery cues for instructors.

---

## Prerequisites

- A host machine with ≥ 8 GB RAM, ~40 GB free disk, CPU virtualization enabled
- [VirtualBox](https://www.virtualbox.org/) (free)
- An Ubuntu Server LTS ISO (guides use 24.04 LTS)

---

## Recurring themes

- **Firewall thread** — UFW is taught progressively: SSH (Day 1) → web ports (Day 2 AM) → scoped MySQL access (Day 2 PM) → consolidated review and least-exposure cleanup (Day 3).
- **Snapshots** — each day ends with a named VirtualBox snapshot as a safe restore point.
- **Security by default** — least-privilege DB users, prepared statements, credentials outside the web root, minimal exposure.

---

## Notes

- Database edition used: **MySQL 8 Community**.
- Migration type: **server-to-server** (logical dump-and-load).
- Application migration is **out of scope**; the sample PHP app only demonstrates a working target stack.

## License

Provided as-is for educational use.
