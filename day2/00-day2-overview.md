# Day 2 — Two-Tier LAMP (AM) / Migration Demo (PM)

**AM mode:** Hands-on labs
**PM mode:** Instructor demo

**AM goal:** A working **two-tier** setup — **MySQL 8** on `ubuntu-db`, **Apache + PHP** on `ubuntu-app`, and a one-page PHP app on `ubuntu-app` that reads/writes the database **over the network** on `ubuntu-db`.
**PM goal:** Watch the trainer perform a real **MySQL 5 → 8 migration** (from a CentOS source) and understand how it's planned, executed, and validated.

---

## Where we are

Day 1 left you with two clean Ubuntu VMs (`day1-clean` snapshot), both SSH-accessible:

- **ubuntu-app** — gets **Apache + PHP** today (the web/application tier).
- **ubuntu-db** — gets **MySQL 8** today (the database tier).

The whole point of today's AM is that these are **separate machines**. The app does not find its database on `localhost` — it connects across the network to `ubuntu-db`. Making that link work *safely* is the core skill.

```
   ubuntu-app (192.168.x.A)              ubuntu-db (192.168.x.B)
   ┌──────────────────────┐             ┌──────────────────────┐
   │  Apache + PHP        │  ── SQL ──► │  MySQL 8             │
   │  index.php           │   TCP 3306  │  appdb / appuser     │
   └──────────────────────┘             └──────────────────────┘
     opens 80/443 (web)                   opens 3306 FROM app-IP only
```

---

## Morning (AM) — build the two tiers, hands-on

Work on the machine each file names in its header — **watch your prompt** (`ubuntu-app` vs `ubuntu-db`).

| # | File | On | You achieve |
|---|------|----|-------------|
| 06 | `06-mysql-architecture.md` | (concept) | Understand how MySQL is structured, incl. network access |
| 07 | `07-install-mysql8.md` | `ubuntu-db` | Install & run MySQL 8; bind it to the network |
| 08 | `08-mysql-security-basics.md` | `ubuntu-db` | Secure MySQL; create `appdb` + a **remote** app user; open 3306 to the app only |
| 09 | `09-apache-setup.md` | `ubuntu-app` | Install Apache; open the web firewall |
| 10 | `10-php-setup.md` | `ubuntu-app` | Install PHP + the MySQL driver |
| 11 | `11-sample-app.md` | `ubuntu-app` | Deploy a PHP app that connects to MySQL on `ubuntu-db` |

By lunch: browse to `ubuntu-app`'s IP and see a live PHP page whose data lives on a **different server**.

## Afternoon (PM) — migration demo, instructor-led

The trainer drives a real **CentOS MySQL 5.x → Ubuntu MySQL 8** migration; trainees watch, take notes, and follow conceptually. **Participants do not migrate anything themselves.**

| # | File | Covers |
|---|------|--------|
| 12 | `12-migration-planning.md` | Strategy, risks, what "server-to-server" means |
| 13 | `13-backup-and-dump.md` | Prepare source, take a consistent `mysqldump` |
| 14 | `14-migration-execution.md` | Load the dump into MySQL 8 |

> **Scope reminder:** the migration is a **database** migration (MySQL 5.x → 8) that the **trainer** performs on a separate CentOS→Ubuntu pair. Your `ubuntu-db` is *not* the migration target — it stays the clean home of your own app's `appdb`.

---

## The firewall thread today

- **On `ubuntu-app` (web):** open ports 80/443 → `sudo ufw allow 'Apache Full'` — file 09.
- **On `ubuntu-db` (MySQL):** open 3306 **only from `ubuntu-app`'s IP** → `sudo ufw allow from <app-IP> to any port 3306` — file 08.

We never open 3306 to the whole network. Scoping it to exactly one source IP is the lesson.

---

## Day 2 success checklist

- [ ] MySQL 8 running and secured on `ubuntu-db`; bound to the network
- [ ] `appdb` + a **remote** `appuser@'<app-IP>'` created with least privilege
- [ ] `ubuntu-db` firewall allows 3306 **from `ubuntu-app` only**
- [ ] Apache serving the default page over HTTP on `ubuntu-app` (web firewall opened)
- [ ] PHP installed on `ubuntu-app`; `mysqli`/`pdo_mysql` present
- [ ] Sample app on `ubuntu-app` reads/writes MySQL 8 on `ubuntu-db` across the network
- [ ] Migration demo understood (plan → dump → import)
- [ ] Snapshot `day2-two-tier` taken on both VMs

Next: **Day 3** — the trainer finishes the migration demo (resolve 5→8 differences, validate), then you go deeper on MySQL admin and harden the whole two-tier stack.
