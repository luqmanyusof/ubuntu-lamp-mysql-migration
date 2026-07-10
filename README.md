# Ubuntu Two-Tier LAMP + MySQL 5→8 Migration — 3-Day Coaching

A hands-on, 3-day training program that takes you from a bare VirtualBox host to a secured **two-tier** Ubuntu setup — an **application server** and a **database server** on separate VMs, linked over a scoped network path — plus an instructor-led walkthrough of a real **MySQL 5.x → 8 migration**.

Materials are trainee-facing, step-by-step lab guides — every command, expected output, and checkpoint included.

---

## What you'll build

Two Ubuntu Server VMs in VirtualBox, wired together as two tiers:

- **ubuntu-app** — Apache + PHP (the web/application tier)
- **ubuntu-db** — MySQL 8 (the database tier)

The PHP app on `ubuntu-app` connects to MySQL on `ubuntu-db` **across the network**, secured by a firewall rule scoped to the app server and a host-scoped database user.

```
   ubuntu-app                              ubuntu-db
   ┌──────────────────────┐               ┌──────────────────────┐
   │  Apache + PHP        │  ── SQL ───►  │  MySQL 8             │
   │  (web tier)          │   TCP 3306    │  (database tier)     │
   └──────────────────────┘  app-IP only  └──────────────────────┘
```

By the end you can install and secure Ubuntu, stand up a two-tier Apache + PHP + MySQL 8 stack, **link an app to a remote database safely**, harden the whole thing, and troubleshoot failures methodically — and you'll understand how a MySQL 5.x → 8 migration is planned, executed, and validated (from watching a real one).

---

## Two audiences: participants vs. trainer

- **Participants** build and secure the **two-tier LAMP** stack (Day 1–2 AM, Day 3 PM). They **do not perform any migration** — they watch it as a demo.
- **The trainer** performs the real migration: the legacy database runs on **CentOS + MySQL 5.x**, migrated to a **separate Ubuntu MySQL 8 server**. The full operational runbook is in **`trainer-only/`** — private, not for participants.

---

## Structure

### Day 1 — Ubuntu Foundations (hands-on)
Two secured, SSH-accessible Ubuntu Server VMs: `ubuntu-app` and `ubuntu-db`.

| File | Topic |
|------|-------|
| `day1/00-day1-overview.md` | Day map & checklist |
| `day1/01-virtualbox-setup.md` | VirtualBox + the two VMs |
| `day1/02-download-ubuntu-iso.md` | Download & verify the ISO |
| `day1/03-ubuntu-installation.md` | Install Ubuntu Server |
| `day1/04-linux-admin-essentials.md` | Everyday Linux administration |
| `day1/05-system-services-security.md` | Services, SSH (to both VMs), UFW firewall |

### Day 2 — Two-Tier LAMP (AM) / Migration Demo (PM)
MySQL 8 on `ubuntu-db`, Apache + PHP on `ubuntu-app`, app linked to the remote DB — then watch the trainer's migration.

| File | On | Topic |
|------|----|-------|
| `day2/00-day2-overview.md` | — | Day map & checklist |
| `day2/06-mysql-architecture.md` | concept | How MySQL is structured, incl. network access |
| `day2/07-install-mysql8.md` | `ubuntu-db` | Install MySQL 8 Community |
| `day2/08-mysql-security-basics.md` | `ubuntu-db` | Secure MySQL; remote user; bind + firewall to app only |
| `day2/09-apache-setup.md` | `ubuntu-app` | Apache + web firewall rules |
| `day2/10-php-setup.md` | `ubuntu-app` | PHP + the MySQL driver |
| `day2/11-sample-app.md` | both | PHP app linked to the **remote** database |
| `day2/12-migration-planning.md` | demo | Migration strategy & risks |
| `day2/13-backup-and-dump.md` | demo | Consistent `mysqldump` (CentOS source) |
| `day2/14-migration-execution.md` | demo | Transfer & import into MySQL 8 |

### Day 3 — Finish Migration Demo + Deepen & Harden
Trainer resolves 5→8 differences and validates; participants deepen MySQL admin and harden the two-tier stack.

| File | On | Topic |
|------|----|-------|
| `day3/00-day3-overview.md` | — | Day map & checklist |
| `day3/15-mysql5-vs-mysql8-differences.md` | demo | The real differences & fixes |
| `day3/16-upgrade-checker.md` | demo | MySQL Shell upgrade checker |
| `day3/17-post-migration-validation.md` | demo | Prove it's complete & correct |
| `day3/18-mysql-admin-deeper.md` | `ubuntu-db` | Backups, logs, config, tuning |
| `day3/19-security-hardening.md` | both | Consolidated two-tier hardening |
| `day3/20-troubleshooting-workshop.md` | both | Guided break/fix scenarios |

### Trainer-only — the real migration runbook
Private operational material for the trainer. **Not for participants.**

| File | Topic |
|------|-------|
| `trainer-only/00-README.md` | Why this exists; how it maps to the course |
| `trainer-only/centos-mysql5-to-ubuntu-mysql8-migration.md` | End-to-end CentOS MySQL 5.x → Ubuntu MySQL 8 runbook |

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

- **Firewall thread** — UFW is taught progressively, per role: SSH on both VMs (Day 1) → web ports on `ubuntu-app` + scoped MySQL (3306-from-app-IP) on `ubuntu-db` (Day 2) → consolidated two-tier review (Day 3).
- **The three-layer DB link** — reaching MySQL from the app requires firewall + `bind-address` + host-scoped user to all line up. Introduced in Day 2 file 08, reinforced in troubleshooting.
- **Snapshots** — key milestones end with a named VirtualBox snapshot as a safe restore point (`day1-clean`, `day2-two-tier`, `day3-complete`).
- **Security by default** — least-privilege DB users scoped to the app's IP, prepared statements, credentials outside the web root, minimal per-role exposure.

---

## Notes

- Database edition used: **MySQL 8 Community**.
- Architecture: **two-tier** — application (`ubuntu-app`) and database (`ubuntu-db`) on separate servers, linked over a scoped network path.
- Migration type: **server-to-server, cross-OS** (CentOS MySQL 5.x → Ubuntu MySQL 8), logical dump-and-load. **Trainer-only** — participants watch it as a demo and do not migrate anything themselves.
- Application migration is **out of scope**; the sample PHP app only demonstrates a working two-tier stack.

## License

Provided as-is for educational use.
