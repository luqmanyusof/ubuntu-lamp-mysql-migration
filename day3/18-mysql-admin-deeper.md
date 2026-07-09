# 18 — MySQL Administration (Deeper)

**Mode:** Hands-on / discussion
**Goal:** Practise the day-to-day administration you'll need to run the migrated MySQL 8 server: backups, logs, configuration, users, and basic performance.

**Time:** ~50 minutes

> All hands-on on **ubuntu-target**.

---

## 1. Backups you can rely on

You already used `mysqldump` for migration. As a **routine backup** habit:

```bash
# Full logical backup of one database, dated
$ sudo mysqldump --single-transaction --routines --triggers \
    sourcedb > ~/backup_sourcedb_$(date +%F).sql

# All databases (server-wide)
$ sudo mysqldump --single-transaction --all-databases > ~/backup_all_$(date +%F).sql
```

**Restore** (to a named DB):

```bash
$ sudo mysql sourcedb < ~/backup_sourcedb_2026-07-10.sql
```

Discussion points:
- **Test your restores** — an untested backup is a hope, not a backup.
- **Retention & offsite** — keep multiple dated copies, ideally off the server.
- **Logical vs physical** — `mysqldump` is logical (portable, slower to restore for big DBs); tools like `mysqlbackup`/`xtrabackup` do physical backups for large systems.

📌 **Checkpoint:** You produce a dated backup and successfully restore it into a scratch database.

---

## 2. Reading the logs

```bash
$ sudo tail -f /var/log/mysql/error.log       # startup problems, crashes, warnings
```

Enable and inspect the **slow query log** to find slow SQL:

```sql
mysql> SET GLOBAL slow_query_log = 'ON';
mysql> SET GLOBAL long_query_time = 1;        -- log queries slower than 1s
mysql> SHOW VARIABLES LIKE 'slow_query_log_file';
```

```bash
$ sudo tail -f /var/log/mysql/mysql-slow.log
```

📌 **Checkpoint:** You can locate the error log and enable the slow query log.

---

## 3. Configuration

Main config on Ubuntu:

```bash
$ sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
```

Settings worth knowing (don't change blindly):

| Setting | Meaning |
|---------|---------|
| `bind-address` | Which IPs MySQL listens on (`127.0.0.1` = localhost only) |
| `max_connections` | Max simultaneous client connections |
| `innodb_buffer_pool_size` | RAM InnoDB uses to cache data — biggest performance lever |
| `datadir` | Where data files live |

After editing, apply and check:

```bash
$ sudo systemctl restart mysql
$ sudo systemctl status mysql
$ sudo tail -n 20 /var/log/mysql/error.log
```

> ⚠️ A bad config stops MySQL from starting. Always check `status` and the error log after a restart, and change one thing at a time.

---

## 4. Managing users and privileges

```sql
mysql> SELECT user, host, plugin FROM mysql.user;      -- who exists
mysql> SHOW GRANTS FOR 'sourceapp'@'localhost';        -- what can they do
mysql> CREATE USER 'reporter'@'localhost' IDENTIFIED BY 'Str0ng!';
mysql> GRANT SELECT ON sourcedb.* TO 'reporter'@'localhost';   -- read-only user
mysql> REVOKE INSERT ON sourcedb.* FROM 'someuser'@'localhost';
mysql> DROP USER 'olduser'@'localhost';
mysql> FLUSH PRIVILEGES;
```

Principle repeated from Day 2: **least privilege** — grant only what each user needs.

📌 **Checkpoint:** You create a read-only `reporter` user and confirm it can `SELECT` but not `INSERT`.

---

## 5. Health & activity at a glance

```sql
mysql> SHOW GLOBAL STATUS LIKE 'Threads_connected';    -- current connections
mysql> SHOW GLOBAL STATUS LIKE 'Uptime';
mysql> SHOW PROCESSLIST;                                -- what's running now
mysql> SHOW ENGINE INNODB STATUS\G                      -- deep InnoDB state
mysql> SELECT * FROM sys.schema_table_statistics LIMIT 10;   -- sys schema helpers
```

The **`sys`** schema (built into MySQL 8) provides friendly views over performance data — worth exploring.

---

## 6. Basic performance: indexing & EXPLAIN

The single biggest everyday performance tool is the **index** — and `EXPLAIN` shows whether a query uses one:

```sql
mysql> EXPLAIN SELECT * FROM orders WHERE customer_id = 42;
```

- `type: ALL` and no `key` → a **full table scan** (slow on big tables).
- Add an index and re-check:
  ```sql
  mysql> CREATE INDEX idx_orders_customer ON orders(customer_id);
  mysql> EXPLAIN SELECT * FROM orders WHERE customer_id = 42;   -- should now use the index
  ```

📌 **Checkpoint:** You use `EXPLAIN` to show a full scan, add an index, and show the query now using it.

---

## Done

You can back up, restore, configure, monitor, and tune the basics of MySQL 8. Next: **`19-security-hardening.md`** — lock down the whole stack.
