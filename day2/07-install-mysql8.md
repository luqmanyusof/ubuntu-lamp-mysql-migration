# 07 — Install MySQL 8 Community

**Goal:** Install and run **MySQL 8 Community Server** on **ubuntu-db**, confirm it's running, and log in for the first time.

**Time:** ~30 minutes

> All commands run on **ubuntu-db** (SSH in from Windows). Check your prompt says `student@ubuntu-db`.
> **Edition:** we use **MySQL 8 Community**. (Enterprise is a later decision and installs from a different repository; nothing in this course depends on Enterprise.)

---

## 1. Refresh the package list

```bash
$ sudo apt update
```

---

## 2. Install MySQL 8

Ubuntu 24.04's default repository ships MySQL 8, so a plain install gives you version 8:

```bash
$ sudo apt install mysql-server -y
```

> **Note:** If your Ubuntu release's default `mysql-server` is *not* 8.0, install Oracle's official APT repo instead (`mysql-apt-config`). On 24.04 LTS the default is 8.0, so the command above is enough. Confirm the version in the next step.

Confirm the version:

```bash
$ mysql --version
mysql  Ver 8.0.x for Linux ...
```

📌 **Checkpoint:** Version string shows **8.0.x**.

---

## 3. Confirm the service is running

```bash
$ sudo systemctl status mysql
```

Look for **active (running)** and **enabled**. If it's not running:

```bash
$ sudo systemctl enable --now mysql
```

📌 **Checkpoint:** `systemctl status mysql` → active (running), enabled.

---

## 4. Log in for the first time

On a fresh Ubuntu install, the `root` MySQL user authenticates via the **auth_socket** plugin — meaning the Linux `root` user can log in without a MySQL password:

```bash
$ sudo mysql
```

You land at the MySQL prompt:

```
mysql>
```

Run a few commands to look around:

```sql
mysql> SELECT VERSION();
mysql> SHOW DATABASES;
mysql> SELECT user, host, plugin FROM mysql.user;
```

That last query shows each account and its authentication plugin — notice `root` uses `auth_socket`, and new users will default to `caching_sha2_password` (the MySQL 8 change we noted in file 06).

Exit the prompt:

```sql
mysql> EXIT;
```

📌 **Checkpoint:** You can enter the `mysql>` prompt with `sudo mysql`, run `SELECT VERSION();`, and it returns 8.0.x.

---

## 5. Where things live (quick tour)

```bash
$ sudo ls /var/lib/mysql        # data directory (databases as folders)
$ ls /etc/mysql/mysql.conf.d/   # config directory
$ sudo tail -n 20 /var/log/mysql/error.log   # error log
```

You met these paths in file 06 — now you can see them for real.

---

## 6. A note on binding and the network (we open this up in file 08)

Check where MySQL is currently listening:

```bash
$ grep -i bind-address /etc/mysql/mysql.conf.d/mysqld.cnf
$ sudo ss -tlnp | grep 3306
```

By default MySQL 8 on Ubuntu binds to `127.0.0.1` (localhost only) — it does **not** accept network connections yet. On a single-server LAMP box that's ideal. **But our app lives on a different machine** (`ubuntu-app`), so MySQL must be reachable over the network.

We change `bind-address` and open the firewall **in the next file (08)**, together with creating the remote app user — so the "expose it" steps and the "secure it" steps happen as one deliberate, scoped operation.

> Do **not** change `bind-address` yet. Finish this file first; file 08 does it properly alongside the firewall rule and the `'appuser'@'<app-IP>'` account.

---

## Done

MySQL 8 is installed, running, and you can log in. Next: **`08-mysql-security-basics.md`** — secure it and create a working database and user.
