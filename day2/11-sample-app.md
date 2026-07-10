# 11 — Link the App to the Remote Database

**Goal:** Deploy a **one-page PHP app** on `ubuntu-app` that reads from and writes to **MySQL 8 on `ubuntu-db`** — proving the two tiers work together **over the network**.

**Time:** ~45 minutes

> This lab spans **both** VMs. Watch every command's header:
> - 🟦 **on `ubuntu-db`** — create the table/data (the database lives here).
> - 🟩 **on `ubuntu-app`** — write and serve the PHP app (the web tier lives here).
>
> You'll need both IPs: `<db-IP>` (ubuntu-db) and `<app-IP>` (ubuntu-app).

---

## 1. 🟦 On `ubuntu-db` — create a table and seed data

SSH into **ubuntu-db** and log into MySQL:

```bash
$ sudo mysql
```

```sql
mysql> USE appdb;

mysql> CREATE TABLE messages (
         id        INT AUTO_INCREMENT PRIMARY KEY,
         author    VARCHAR(100) NOT NULL,
         body      VARCHAR(255) NOT NULL,
         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
       );

mysql> INSERT INTO messages (author, body) VALUES
         ('System', 'Two-tier LAMP is alive!'),
         ('Trainer', 'If you can read this in the browser, the app reached ubuntu-db.');

mysql> SELECT * FROM messages;
mysql> EXIT;
```

📌 **Checkpoint:** `SELECT * FROM messages;` shows two rows on `ubuntu-db`.

---

## 2. 🟩 On `ubuntu-app` — prove the network path *before* writing any PHP

The most common two-tier failure is a blocked or misconfigured connection. Test it directly with the MySQL client first, so you debug the *link* separately from the *code*.

Install just the client (no server) on `ubuntu-app`:

```bash
$ sudo apt install mysql-client -y
```

Now connect **across the network** to `ubuntu-db`, as the app user:

```bash
$ mysql -h <db-IP> -u appuser -p appdb
Enter password: (the password you set in file 08)
```

At the prompt:

```sql
mysql> SELECT @@hostname;        -- should print: ubuntu-db  (you reached the other VM!)
mysql> SELECT * FROM messages;   -- the two seeded rows
mysql> EXIT;
```

📌 **Checkpoint:** From `ubuntu-app` you log into MySQL on `ubuntu-db` and see the messages. **If this fails, fix it now** using §6 before touching PHP — the web page can only work once this does.

---

## 3. 🟩 On `ubuntu-app` — store the DB credentials outside the web root

Never hard-code passwords inside a public web file. Create a config file **above** the web root:

```bash
$ sudo nano /var/www/appconfig.php
```

```php
<?php
// Not inside /var/www/html, so it can't be served directly.
return [
    'host' => '<db-IP>',        // ubuntu-db — the REMOTE database server
    'db'   => 'appdb',
    'user' => 'appuser',
    'pass' => 'ChangeMe_Str0ng!',   // the password you set in file 08
];
```

> The single most important line here is `'host' => '<db-IP>'`. On a single-server app this would be `127.0.0.1`; in our two-tier setup it points across the network to `ubuntu-db`.

Lock it down:

```bash
$ sudo chown root:www-data /var/www/appconfig.php
$ sudo chmod 640 /var/www/appconfig.php
```

> This lets Apache (`www-data`) read it, but not the world.

---

## 4. 🟩 On `ubuntu-app` — write the app page

Remove the default HTML page and create the PHP app:

```bash
$ sudo rm -f /var/www/html/index.html
$ sudo nano /var/www/html/index.php
```

Paste:

```php
<?php
$cfg = require '/var/www/appconfig.php';

// Connect to the REMOTE MySQL on ubuntu-db using mysqli
$mysqli = new mysqli($cfg['host'], $cfg['user'], $cfg['pass'], $cfg['db']);
if ($mysqli->connect_errno) {
    http_response_code(500);
    exit('Database connection failed: ' . $mysqli->connect_error);
}

// Handle a new message submitted via the form (prepared statement = safe)
if ($_SERVER['REQUEST_METHOD'] === 'POST' && !empty($_POST['author']) && !empty($_POST['body'])) {
    $stmt = $mysqli->prepare('INSERT INTO messages (author, body) VALUES (?, ?)');
    $stmt->bind_param('ss', $_POST['author'], $_POST['body']);
    $stmt->execute();
    $stmt->close();
    header('Location: /');   // redirect to avoid double-post on refresh
    exit;
}

// Read messages
$result = $mysqli->query('SELECT author, body, created_at FROM messages ORDER BY id DESC');
?>
<!doctype html>
<html>
<head><meta charset="utf-8"><title>Two-Tier LAMP Demo</title></head>
<body style="font-family: sans-serif; max-width: 600px; margin: 2rem auto;">
  <h1>Two-Tier LAMP Demo</h1>
  <p>Page served by Apache + PHP on <strong>ubuntu-app</strong>;
     data stored in MySQL 8 on <strong>ubuntu-db</strong>.</p>

  <form method="post">
    <input name="author" placeholder="Your name" required>
    <input name="body" placeholder="A message" required>
    <button type="submit">Add</button>
  </form>

  <h2>Messages</h2>
  <ul>
    <?php while ($row = $result->fetch_assoc()): ?>
      <li>
        <strong><?= htmlspecialchars($row['author']) ?></strong>:
        <?= htmlspecialchars($row['body']) ?>
        <em>(<?= $row['created_at'] ?>)</em>
      </li>
    <?php endwhile; ?>
  </ul>
</body>
</html>
```

Save and exit.

> **Teaching points in this code:**
> - The app connects to a **remote** host (`$cfg['host']` = `ubuntu-db`), not localhost.
> - **Prepared statements** (`prepare` + `bind_param`) prevent SQL injection.
> - **`htmlspecialchars`** on output prevents cross-site scripting (XSS).
> - Credentials live **outside** the web root.

---

## 5. See it in the browser

From your **Windows host**:

```
http://<app-IP>/
```

You should see the heading, the two seeded messages, and a form. **Add a message** — it appears at the top after submitting.

📌 **Checkpoint:** You read the seeded rows **and** add a new one that persists. Refresh — it's still there, because it lives in MySQL on `ubuntu-db`. To *prove* it crossed the network, check on `ubuntu-db`:

```sql
mysql> SELECT * FROM appdb.messages ORDER BY id DESC LIMIT 3;   -- your new row is here
```

---

## 6. If the connection fails — debug the link by layer

`Database connection failed` almost always means the network path is broken. Check, in order:

```bash
# 🟩 on ubuntu-app — can you even reach the port?
$ nc -zv <db-IP> 3306          # "succeeded" = firewall+bind OK; "timed out" = blocked
```

| Symptom | Likely cause | Fix (on `ubuntu-db`) |
|---------|--------------|----------------------|
| `nc` times out | Firewall not open to this app, or MySQL bound to localhost | `sudo ufw allow from <app-IP> to any port 3306`; set `bind-address = 0.0.0.0` (file 08 §3–4) |
| `Access denied for user 'appuser'@'<app-IP>'` | User host doesn't match the app's real IP | Recreate `'appuser'@'<real-app-IP>'` or use `'appuser'@'subnet.%'` (file 08 §2) |
| `Unknown database 'appdb'` | DB not created on `ubuntu-db` | `CREATE DATABASE appdb ...` (file 08 §2) |
| Wrong password | Mismatch with `appconfig.php` | Fix the password in either place |

Also check the app's own error log:

```bash
$ sudo tail -n 30 /var/log/apache2/error.log     # on ubuntu-app
```

> **Lesson:** in a two-tier app, "it can't connect" is a **layered** problem — port (firewall/bind) → auth (user host/password) → database → query. Test each layer in that order and you'll never guess.

---

## Morning wrap-up — snapshot the working two-tier stack

You've built and verified a two-tier LAMP setup:

- [ ] Apache + PHP serve the page from `ubuntu-app`
- [ ] MySQL 8 on `ubuntu-db` stores the data
- [ ] The app connects **across the network**, scoped by firewall + user host
- [ ] You can add a record through the browser and see it on `ubuntu-db`

Take a snapshot on **both** VMs now:

- Name: **`day2-two-tier`**
- Description: `Two-tier LAMP working: app on ubuntu-app, MySQL 8 on ubuntu-db`

> **Trainer note (Luqman):** This is the clean handoff to the PM session. With the participants' stack snapshotted, the afternoon migration demo (which you run on your *own* CentOS→Ubuntu pair) can't affect their boxes. If anyone's link is flaky, fix it against `day2-two-tier` before lunch.

Next (PM, instructor demo): **`12-migration-planning.md`** — plan the MySQL 5 → 8 migration you'll watch the trainer perform.
