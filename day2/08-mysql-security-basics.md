# 08 — MySQL Security + Exposing It to the App (Safely)

**Goal:** Harden the fresh MySQL 8 install, create a **database** and a **remote application user**, then open MySQL to the network **only** for `ubuntu-app` — via `bind-address` and a tightly scoped firewall rule.

**Time:** ~40 minutes

> All commands on **ubuntu-db**. Check your prompt says `student@ubuntu-db`.
> You'll need **`ubuntu-app`'s IP address** in this lab — have it written down (`ip a` on `ubuntu-app`). We call it `<app-IP>`.

---

## 1. Run the secure-installation wizard

MySQL ships an interactive script that removes insecure defaults:

```bash
$ sudo mysql_secure_installation
```

Answer as follows:

| Prompt | Answer | Why |
|--------|--------|-----|
| Setup VALIDATE PASSWORD component? | `y`, then level `1` (MEDIUM) | Enforces reasonable password strength |
| Remove anonymous users? | `y` | Anonymous access is a risk |
| Disallow root login remotely? | `y` | root should never log in over the network |
| Remove test database? | `y` | The default `test` DB is world-accessible |
| Reload privilege tables now? | `y` | Apply changes immediately |

> **Note on the root password prompt:** Because Ubuntu's `root` uses `auth_socket`, the wizard may not ask you to set a root password — that's expected. We keep `root` on socket auth (log in with `sudo mysql`) and never expose it to the network.

📌 **Checkpoint:** The script finishes with "All done!".

---

## 2. Create the application database and a *remote* user

Log in:

```bash
$ sudo mysql
```

Create a database for our sample app:

```sql
mysql> CREATE DATABASE appdb CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
```

> We explicitly set **utf8mb4** — the MySQL 8 default, full 4-byte Unicode. Good habit for every new database.

Now the key difference from a single-server setup: our app runs on **`ubuntu-app`**, a *different machine*. So the user's host is **`ubuntu-app`'s IP**, not `localhost`:

```sql
mysql> CREATE USER 'appuser'@'<app-IP>' IDENTIFIED BY 'ChangeMe_Str0ng!';
```

Grant it rights **only** on `appdb` (least privilege):

```sql
mysql> GRANT SELECT, INSERT, UPDATE, DELETE ON appdb.* TO 'appuser'@'<app-IP>';
mysql> FLUSH PRIVILEGES;
```

> ⚠️ Replace `<app-IP>` with the real IP of `ubuntu-app` (e.g. `192.168.1.50`), and `ChangeMe_Str0ng!` with your own strong password. The PHP app in file 11 uses both.

> **DHCP tip:** if the app's IP changes on reboot and login starts failing, either re-create the user with the new IP, or scope it to the subnet: `'appuser'@'192.168.1.%'`. Tighter (single IP) is better; subnet is a pragmatic fallback.

Verify:

```sql
mysql> SELECT user, host FROM mysql.user WHERE user='appuser';
mysql> SHOW GRANTS FOR 'appuser'@'<app-IP>';
mysql> EXIT;
```

📌 **Checkpoint:** `appuser` exists with host = `<app-IP>`, and `SHOW GRANTS` lists SELECT/INSERT/UPDATE/DELETE on `appdb.*`.

---

## 3. Bind MySQL to the network

Right now MySQL only listens on `127.0.0.1`, so `ubuntu-app` can't reach it. Change the bind address:

```bash
$ sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
```

Find the line:

```
bind-address = 127.0.0.1
```

Change it to listen on all interfaces:

```
bind-address = 0.0.0.0
```

> **Why `0.0.0.0` and not the VM's own IP?** On a DHCP-addressed VM the IP can change; `0.0.0.0` avoids MySQL failing to start when that happens. We are **not** relying on the bind address for security — the **firewall** (next step) plus the **`@'<app-IP>'` user** are what actually restrict access. Defence in layers.

Restart and confirm it's now listening on the network:

```bash
$ sudo systemctl restart mysql
$ sudo ss -tlnp | grep 3306          # should show 0.0.0.0:3306 (not 127.0.0.1:3306)
```

📌 **Checkpoint:** `ss` shows MySQL listening on `0.0.0.0:3306`.

---

## 4. Firewall thread — open 3306 to the app server *only*

MySQL now listens on the network, but the firewall must still let `ubuntu-app` in — and **nobody else**:

```bash
$ sudo ufw allow from <app-IP> to any port 3306 proto tcp
$ sudo ufw status
```

Expected — SSH (from Day 1) plus a **scoped** MySQL rule:

```
To                         Action      From
--                         ------      ----
22/tcp (OpenSSH)           ALLOW IN    Anywhere
3306/tcp                   ALLOW IN    <app-IP>
```

> ⚠️ **Never** `sudo ufw allow 3306` on its own — that opens your database to the entire network. Always scope it `from <app-IP>`. Notice the `From` column shows the specific IP, not `Anywhere`.

📌 **Checkpoint:** `ufw status` shows 3306 allowed **only** from `<app-IP>`.

---

## 5. Understanding the three layers you just built

Reaching this database from the app now requires **all three** to line up — that's the point:

| Layer | What it enforces | Set in |
|-------|------------------|--------|
| **Firewall** (UFW) | Only packets from `<app-IP>` reach port 3306 | §4 |
| **`bind-address`** | MySQL listens on the network at all | §3 |
| **User host** `'appuser'@'<app-IP>'` | MySQL only *authenticates* a login coming from that IP | §2 |

A single-server app would use `'appuser'@'localhost'` and no open port. A two-tier app trades that for a **narrow, deliberate** network path. We verify the whole path end-to-end from `ubuntu-app` in file 11.

---

## 6. Security habits recap

- ✅ App uses a **dedicated least-privilege user**, never root.
- ✅ The app user is scoped to the **app server's IP**, not the world.
- ✅ Port 3306 is open to **one source IP only**.
- ✅ Anonymous users and the `test` DB removed; root not remotely reachable.
- ✅ New DB uses `utf8mb4`.

These get expanded in the Day 3 hardening lab (file 19).

---

## Done

MySQL 8 is secured, exposed only to `ubuntu-app`, and ready with `appdb` + a remote `appuser`. Now switch to **`ubuntu-app`** for **`09-apache-setup.md`** — install the web server.
