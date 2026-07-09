# 08 — MySQL Security Basics

**Goal:** Harden the fresh MySQL 8 install, then create a **database** and an **application user** with correct privileges — the account our PHP app will use.

**Time:** ~30 minutes

> All commands on **ubuntu-target**.

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

> **Note on the root password prompt:** Because Ubuntu's `root` uses `auth_socket`, the wizard may not ask you to set a root password — that's expected. We keep `root` on socket auth (log in with `sudo mysql`). We do **not** switch root to password auth; it's more secure as-is.

📌 **Checkpoint:** The script finishes with "All done!".

---

## 2. Create the application database and user

Log in:

```bash
$ sudo mysql
```

Create a database for our sample app:

```sql
mysql> CREATE DATABASE appdb CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
```

> We explicitly set **utf8mb4** — the MySQL 8 default, full 4-byte Unicode (emoji, all languages). Good habit for every new database.

Create a dedicated **application user** (never let the app use root):

```sql
mysql> CREATE USER 'appuser'@'localhost' IDENTIFIED BY 'ChangeMe_Str0ng!';
```

Grant it rights **only** on `appdb` (least privilege):

```sql
mysql> GRANT SELECT, INSERT, UPDATE, DELETE ON appdb.* TO 'appuser'@'localhost';
mysql> FLUSH PRIVILEGES;
```

> ⚠️ Replace `ChangeMe_Str0ng!` with your own strong password and remember it — the PHP app in file 11 will use it.

Verify:

```sql
mysql> SHOW GRANTS FOR 'appuser'@'localhost';
mysql> EXIT;
```

📌 **Checkpoint:** `SHOW GRANTS` lists SELECT/INSERT/UPDATE/DELETE on `appdb.*` for `appuser`.

---

## 3. Test the new user

Log in **as the app user** (not via sudo) to prove the credentials work:

```bash
$ mysql -u appuser -p appdb
Enter password: (type the app user's password)
```

At the prompt:

```sql
mysql> SELECT DATABASE();     -- should print: appdb
mysql> SHOW TABLES;           -- empty for now, that's fine
mysql> EXIT;
```

📌 **Checkpoint:** You can log in as `appuser` and land inside `appdb`.

---

## 4. Understanding the `@'localhost'` choice

We created `appuser@'localhost'` — it can connect **only from the target machine itself**. Our PHP app runs on the same machine, so localhost is exactly right and keeps the account off the network entirely.

Contrast with the **migration user** we'll create later, which may need a specific host/IP. Same principle, scoped as tightly as the task allows.

---

## 5. Security habits recap

- ✅ App uses a **dedicated least-privilege user**, never root.
- ✅ Passwords meet the validation policy.
- ✅ Anonymous users and the `test` DB removed.
- ✅ root cannot log in remotely.
- ✅ New DB uses `utf8mb4`.

These same principles get expanded in the Day 3 hardening lab (file 19).

---

## Done

MySQL 8 is secured and ready with `appdb` + `appuser`. Next: **`09-apache-setup.md`** — install the web server.
