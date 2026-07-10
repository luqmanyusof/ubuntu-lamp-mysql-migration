# 06 — MySQL Architecture (before we install)

**Goal:** Understand how MySQL is put together *before* you install it, so the install and later migration steps make sense instead of being magic.

**Time:** ~30 minutes (mostly concept + a little exploring)

> Concept-heavy lab. Read it, then keep it open as reference while you install in file 07.

---

## 1. What MySQL actually is

MySQL is a **relational database server**. It's a background service (`mysqld`) that:

- stores data in **databases → tables → rows/columns**,
- listens on a network **port (default 3306)**,
- accepts **SQL** commands from clients (like our PHP app, or the `mysql` command-line tool),
- enforces **users, passwords, and privileges**.

```
   Client (PHP app / mysql CLI)
            │  SQL over TCP 3306 (or local socket)
            ▼
   ┌───────────────────────────┐
   │        mysqld (server)     │
   │  ┌─────────────────────┐   │
   │  │  SQL layer          │   │  parse, optimize, run queries
   │  ├─────────────────────┤   │
   │  │  Storage engine     │   │  InnoDB (default) reads/writes data
   │  │      (InnoDB)        │   │
   │  └─────────────────────┘   │
   └───────────┬───────────────┘
               ▼
        Data files on disk (/var/lib/mysql)
```

---

## 2. The logical hierarchy

```
MySQL server
└── database (a.k.a. schema)   e.g.  companydb
    └── table                  e.g.  employees
        └── row                one employee record
            └── column         name, email, salary ...
```

- A single MySQL server holds **many databases**.
- Some databases are **system databases** — `mysql`, `information_schema`, `performance_schema`, `sys`. Don't touch these directly; they run the server itself.
- **Your** data lives in databases *you* create.

---

## 3. The storage engine: InnoDB

MySQL can use different "storage engines" to physically store tables. The modern default is **InnoDB**, which gives you:

- **Transactions** (all-or-nothing changes),
- **Foreign keys** (enforced relationships),
- **Row-level locking** (good concurrency),
- **Crash recovery**.

The old alternative, **MyISAM**, lacks transactions and foreign keys.

> **Why this matters for the migration:** A MySQL 5.x database may contain **MyISAM** tables. Part of a good 5→8 migration is checking for MyISAM and typically **converting to InnoDB**. We flag this on Day 3. Note it now.

---

## 4. Key files and directories (on Ubuntu)

| Path | What it is |
|------|-----------|
| `/usr/sbin/mysqld` | The server binary |
| `/var/lib/mysql/` | The actual data files (one folder per database) |
| `/etc/mysql/` | Configuration files |
| `/etc/mysql/mysql.conf.d/mysqld.cnf` | Main server config on Ubuntu |
| `/var/log/mysql/error.log` | Where MySQL reports problems |
| `/var/run/mysqld/mysqld.sock` | Local socket for same-machine connections |

You'll revisit these in file 07 (install) and file 18 (deeper admin).

---

## 5. How clients connect

Two ways in:

1. **Local socket** — a same-machine connection via the `.sock` file. Fast, used when you run `mysql` on the server itself.
2. **TCP port 3306** — a network connection. Used by remote clients — and, critically for us, by the **PHP app on `ubuntu-app`**, which lives on a *different machine* and must reach MySQL across the network.

> This is why the firewall thread opens **3306 from the app server's IP only** — the app genuinely needs a network path to the database, but we keep that path scoped to exactly one source.

---

## 6. Users and privileges (preview)

A MySQL user is written as **`'username'@'host'`** — the *host* part matters, and in a two-tier setup it matters a lot:

- `'app'@'localhost'` — can connect only from the DB machine itself. **Not** what we want: our app is on another machine.
- `'app'@'192.168.1.50'` — can connect only from that IP. **This is what we use** — the IP of `ubuntu-app`.
- `'app'@'192.168.1.%'` — can connect from that whole subnet (looser; handy if the app IP changes via DHCP).
- `'app'@'%'` — can connect from anywhere (avoid unless necessary).

Because our app runs on `ubuntu-app`, we create the user as `'appuser'@'<app-IP>'`, not `@'localhost'`. Privileges (SELECT, INSERT, CREATE, …) are granted **per user, per database**. We set these up in file 08.

---

## 7. MySQL 5.x vs 8 — the headline (full detail on Day 3)

The trainer will demo a **5.x → 8** migration this afternoon. You don't perform it, but understanding the big-picture changes helps you follow along — and they're good MySQL 8 knowledge regardless:

- **Default authentication plugin** changed to `caching_sha2_password` in 8 (was `mysql_native_password` in 5.x). This is the single most common thing that breaks app/tool connections after migration.
- **Character set** default is now `utf8mb4` (true 4-byte UTF-8).
- Stricter **SQL modes** and some **reserved words** added.
- `information_schema` and account handling improvements.

We only *flag* these today. File 15 covers them in full.

---

## 📌 Checkpoint

You can answer, in your own words:

- [ ] What is the difference between a *database* and a *table*?
- [ ] What is InnoDB and why do we prefer it over MyISAM?
- [ ] What are the two ways a client connects to MySQL?
- [ ] Why do we create the app user as `'appuser'@'<app-IP>'` and open 3306 only from the app server?

If yes, continue to **`07-install-mysql8.md`**.
