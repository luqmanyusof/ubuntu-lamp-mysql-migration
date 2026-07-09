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
2. **TCP port 3306** — a network connection. Used by remote clients and, critically, by our **migration** when data crosses from source to target.

> This is why the firewall thread later opens **3306 from the source IP only** — the migration needs a network path, but we keep it tightly scoped.

---

## 6. Users and privileges (preview)

A MySQL user is written as **`'username'@'host'`** — the *host* part matters:

- `'app'@'localhost'` — can connect only from the same machine.
- `'app'@'192.168.1.50'` — can connect only from that IP.
- `'app'@'%'` — can connect from anywhere (avoid unless necessary).

Privileges (SELECT, INSERT, CREATE, …) are granted **per user, per database**. We set these up in file 08.

---

## 7. MySQL 5.x vs 8 — the headline (full detail on Day 3)

You're migrating from **5.x** to **8**. Big-picture changes to keep in mind:

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
- [ ] Why will we open port 3306 only from the source IP?

If yes, continue to **`07-install-mysql8.md`**.
