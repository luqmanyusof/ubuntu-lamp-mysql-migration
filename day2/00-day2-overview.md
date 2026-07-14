# Day 2 — Build the Stack (AM) / Copy the Database (PM)

**Mode:** Hands-on all day. Everything today, you do yourself.

**AM goal:** A working stack — **MySQL 8** on two database VMs, **Nginx + PHP-FPM** on `ubuntu-app`, and a PHP app that reads and writes a **three-table relational database** living on `ubuntu-old-db`, **over the network**.

**PM goal:** **Copy** that database from `ubuntu-old-db` to `ubuntu-new-db` — three different ways — then **cut the live app over** to the new server.

---

## Where we are

Day 1 left you with clean, SSH-accessible Ubuntu VMs. Today they take on their roles:

```
   ubuntu-app                 ubuntu-old-db              ubuntu-new-db
   ┌──────────────┐           ┌──────────────┐           ┌──────────────┐
   │ Nginx + PHP  │ ── SQL ──►│  MySQL 8     │  ─ copy ─►│  MySQL 8     │
   │ (web tier)   │  TCP 3306 │  appdb       │   (PM)    │  appdb       │
   └──────────────┘           └──────────────┘           └──────────────┘
     opens 80/443              3306 FROM app-IP only       3306 FROM app-IP only
                                                           (after cutover)
```

Two things define today:

1. **The app never finds its database on `localhost`.** It reaches across the network. Making that link work *safely* — firewall + `bind-address` + host-scoped user — is the core AM skill.
2. **In the afternoon, the database moves.** The app follows it, by changing **one line**.

> ⚠️ **IP addresses.** Every `<app-IP>`, `<old-db-IP>`, `<new-db-IP>` in today's files means the **host-only `192.168.56.x`** address (`ip -4 addr show enp0s8`). The `10.0.2.15` you also see is the NAT address — it is **identical on all three VMs** and routes nowhere. Using it is the most common mistake of the day.

---

## Morning (AM) — build the stack

Work on the machine each file names in its header — **watch your prompt**.

| # | File | On | You achieve |
|---|------|----|-------------|
| 06 | `06-mysql-architecture.md` | (concept) | How MySQL is structured, incl. network access |
| 07 | `07-install-mysql8.md` | **both DB VMs** | Install MySQL 8 — **run it twice**, on `old-db` *and* `new-db` |
| 08 | `08-mysql-security-basics.md` | **both DB VMs** | Harden both; on `old-db` create `appdb` + a **remote** `appuser`; open 3306 to the app only |
| 09 | `09-nginx-setup.md` | `ubuntu-app` | Install **Nginx**; open the web firewall |
| 10 | `10-php-setup.md` | `ubuntu-app` | Install **PHP-FPM** and wire it into Nginx (Nginx can't run PHP by itself) |
| 11 | `11-sample-app.md` | `ubuntu-app` + `old-db` | Build a **3-table schema with foreign keys**; deploy a PHP app that reads and writes it remotely |

By lunch: browse to `ubuntu-app`'s IP and see a live page — employees joined to departments, projects joined to both — whose data lives on a **different server**.

## Afternoon (PM) — copy the database, then cut over

| # | File | Covers |
|---|------|--------|
| 12 | `12-database-copy-planning.md` | What moves, what doesn't, the three methods, the risk map, prep `new-db` |
| 13 | `13-copy-method-1-dump-file.md` | **Method 1:** dump → file → `scp` → import. **Read the dump file.** |
| 14 | `14-copy-methods-2-3-and-cutover.md` | **Methods 2 & 3:** SSH pipe; remote pull. Then **repoint the app** at `new-db` |

> **The afternoon's punchline:** the copy will succeed perfectly and the app will *still* fail with `Access denied` — because a database dump does **not** contain users and grants. You'll predict that failure in file 13 before you cause it in file 14.

---

## The firewall thread today

- **On `ubuntu-app` (web):** open 80/443 → `sudo ufw allow 'Nginx Full'` — file 09.
- **On `ubuntu-old-db`:** open 3306 **only from `ubuntu-app`'s IP** → `sudo ufw allow from <app-IP> to any port 3306` — file 08.
- **On `ubuntu-new-db`:** same rule, added at **cutover** — file 14. (Plus a temporary rule allowing `old-db` in, if you use copy method 3.)

We never open 3306 to the whole network. Scoping it to exactly one source IP is the lesson, and it applies to **every** database server you build — including the new one.

---

## Day 2 success checklist

- [ ] MySQL 8 running, hardened, and network-bound on **both** `ubuntu-old-db` and `ubuntu-new-db`
- [ ] `appdb` on `old-db`: **departments / employees / projects**, with foreign keys enforced
- [ ] A remote `appuser` with **only** `SELECT, INSERT`, scoped to the app's IP
- [ ] Nginx + PHP-FPM serving the app on `ubuntu-app` (`.php` handed to FPM over the socket)
- [ ] The app reads **and writes** the database across the network
- [ ] `appdb` copied to `ubuntu-new-db` — and verified **structurally** (`SHOW CREATE TABLE`), not just by row count
- [ ] You can name **three** copy methods and say when you'd choose each
- [ ] The app repointed to `ubuntu-new-db`; the page proves it by printing the DB hostname
- [ ] Snapshots taken: `day2-app-working`, `new-db-empty`, `day2-cutover-complete`

Next: **Day 3** — validate the copy properly, go deeper on MySQL administration, and harden all three servers.
