# 11 — Sample PHP + MySQL App

**Goal:** Deploy a **one-page PHP app** on ubuntu-target that reads from and writes to MySQL 8 — proving the whole LAMP stack works end to end.

**Time:** ~40 minutes

> All commands on **ubuntu-target**. This is the AM finale.
> **Scope note:** this app exists only to demonstrate a working target stack. It is **not** the app being migrated — application migration is out of scope for this course.

---

## 1. Create a table and seed data

Log into MySQL and add a simple table to `appdb`:

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
         ('System', 'LAMP stack is alive!'),
         ('Trainer', 'If you can read this in the browser, MySQL 8 works.');

mysql> SELECT * FROM messages;
mysql> EXIT;
```

📌 **Checkpoint:** `SELECT * FROM messages;` shows two rows.

---

## 2. Store the DB credentials outside the web root (good practice)

Never hard-code passwords inside a public web file if you can avoid it. Create a small config file **above** the web root:

```bash
$ sudo nano /var/www/appconfig.php
```

```php
<?php
// Not inside /var/www/html, so it can't be served directly.
return [
    'host' => '127.0.0.1',
    'db'   => 'appdb',
    'user' => 'appuser',
    'pass' => 'ChangeMe_Str0ng!',   // use the password you set in file 08
];
```

Save and exit. Lock it down:

```bash
$ sudo chown root:www-data /var/www/appconfig.php
$ sudo chmod 640 /var/www/appconfig.php
```

> This lets Apache (`www-data`) read it, but not the world.

---

## 3. Write the app page

Remove the default HTML page and create the PHP app:

```bash
$ sudo rm -f /var/www/html/index.html
$ sudo nano /var/www/html/index.php
```

Paste:

```php
<?php
$cfg = require '/var/www/appconfig.php';

// Connect using mysqli
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
<head><meta charset="utf-8"><title>LAMP Demo</title></head>
<body style="font-family: sans-serif; max-width: 600px; margin: 2rem auto;">
  <h1>LAMP Demo App</h1>
  <p>Served by Apache + PHP, data from MySQL 8.</p>

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
> - **Prepared statements** (`prepare` + `bind_param`) prevent SQL injection.
> - **`htmlspecialchars`** on output prevents cross-site scripting (XSS).
> - Credentials live **outside** the web root.
> These are the same habits we reinforce in the Day 3 security lab.

---

## 4. See it in the browser

From your **Windows host**:

```
http://<target-IP>/
```

You should see the heading, the two seeded messages, and a form. **Add a message** — it should appear at the top of the list after submitting.

📌 **Checkpoint:** You can read the seeded rows **and** add a new one that persists (refresh — it's still there because it's in MySQL).

---

## 5. If something breaks

```bash
$ sudo tail -n 30 /var/log/apache2/error.log
```

Common causes:
- Wrong password in `appconfig.php` → connection failed message.
- Table not created → check `USE appdb; SHOW TABLES;`.
- Blank page → PHP error; check the log above.

---

## Morning wrap-up

You've built and verified a complete LAMP stack:

- [ ] Apache serves the page over HTTP
- [ ] PHP renders it dynamically
- [ ] MySQL 8 stores and returns data
- [ ] You can add a record through the browser

> **Trainer note (Luqman):** This is the clean handoff to the PM session. Take a **snapshot of ubuntu-target now** named `day2-lamp-ready` before the migration demo — so if the demo goes sideways, we can return to a known-good LAMP target.

Next (PM, instructor demo): **`12-migration-planning.md`** — plan the MySQL 5 → 8 migration.
