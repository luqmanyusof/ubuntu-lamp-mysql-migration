# 11 — A PHP App on Top of a Real Schema

**Goal:** Build a **three-table relational schema** with foreign keys on `ubuntu-old-db`, seed it with dummy data, and deploy a **PHP app** on `ubuntu-app` that reads and writes it **over the network**.

**Time:** ~60 minutes

> This lab spans **two** VMs. Watch every command's header:
> - 🟦 **on `ubuntu-old-db`** — build and seed the database (the data lives here).
> - 🟩 **on `ubuntu-app`** — write and serve the PHP app (the web tier lives here).
>
> You'll need both **host-only** IPs (`192.168.56.x`, *never* `10.0.2.15`): `<old-db-IP>` and `<app-IP>`.

---

## Why the schema is not one flat table

The database you build here is the **payload** for the next lab, where you copy it to `ubuntu-new-db`. A single flat table would copy without incident and teach you nothing.

Real migrations go wrong at the **structure**, not the rows:

- **Foreign keys** — load the child table before the parent and the import dies on a constraint error. Order matters.
- **Column types and sizes** — `DECIMAL(10,2)` silently becoming `DOUBLE`, or `VARCHAR(120)` truncating to `VARCHAR(50)`, corrupts data *quietly*. Row counts still match.
- **`ENUM` values, charset and collation** — the classic MySQL 5→8 trip hazard (`utf8` vs `utf8mb4`, collation defaults changed).
- **`AUTO_INCREMENT` counters** — copy the rows but lose the counter, and your next insert collides with an existing key.

So we build something with all of that in it. After the copy, "did it work?" becomes a question you can *check* — not just a row count, but `SHOW CREATE TABLE` on both sides, matching line for line.

```
  departments ──1───┬──N── employees ──1──┐
   (parent)         │       (child)       │ leads
                    └──N── projects ──────┘
                            (child of both)
```

---

## 1. 🟦 On `ubuntu-old-db` — build the schema

SSH into **ubuntu-old-db** and open MySQL:

```bash
$ sudo mysql
```

```sql
mysql> USE appdb;
```

**Table 1 — `departments`** (the parent):

```sql
mysql> CREATE TABLE departments (
         dept_id    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
         code       CHAR(4)        NOT NULL UNIQUE,          -- fixed width: 'FIN ', 'IT  '
         name       VARCHAR(60)    NOT NULL,
         budget     DECIMAL(12,2)  NOT NULL DEFAULT 0.00,    -- money: never use FLOAT
         created_at TIMESTAMP      DEFAULT CURRENT_TIMESTAMP
       ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

**Table 2 — `employees`** (child of `departments`):

```sql
mysql> CREATE TABLE employees (
         emp_id     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
         dept_id    INT UNSIGNED   NOT NULL,
         name       VARCHAR(100)   NOT NULL,
         email      VARCHAR(120)   NOT NULL UNIQUE,
         salary     DECIMAL(10,2)  NOT NULL,
         hired_on   DATE           NOT NULL,
         is_active  TINYINT(1)     NOT NULL DEFAULT 1,       -- MySQL's "boolean"
         notes      TEXT,                                     -- unbounded, stored off-page
         CONSTRAINT fk_emp_dept
           FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
           ON DELETE RESTRICT                                 -- can't delete a dept with staff
       ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

**Table 3 — `projects`** (child of **both** — two foreign keys):

```sql
mysql> CREATE TABLE projects (
         proj_id    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
         dept_id    INT UNSIGNED   NOT NULL,
         lead_id    INT UNSIGNED   NULL,                      -- nullable: a project may have no lead
         title      VARCHAR(120)   NOT NULL,
         status     ENUM('planning','active','on_hold','done') NOT NULL DEFAULT 'planning',
         start_date DATE           NOT NULL,
         updated_at DATETIME       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
         CONSTRAINT fk_proj_dept
           FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
           ON DELETE RESTRICT,
         CONSTRAINT fk_proj_lead
           FOREIGN KEY (lead_id) REFERENCES employees(emp_id)
           ON DELETE SET NULL                                 -- lead leaves → project survives, lead goes NULL
       ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

📌 **Checkpoint:** `SHOW TABLES;` lists **departments, employees, projects**.

> **What we deliberately put in here, and why it matters after the copy:**
>
> | Feature | Where | What it can break in a migration |
> |---------|-------|----------------------------------|
> | `AUTO_INCREMENT` PK | all 3 | Counter not carried over → next insert collides |
> | `FOREIGN KEY` | `employees`, `projects` | Import in the wrong order → constraint error |
> | `ON DELETE RESTRICT` / `SET NULL` | — | Different behaviours; both must survive |
> | `DECIMAL(12,2)` / `(10,2)` | budget, salary | Becomes `FLOAT`/`DOUBLE` → money rounds wrong |
> | `CHAR(4)` vs `VARCHAR` | `code` | Trailing-space handling differs |
> | `ENUM` | `status` | Value list must match exactly, or rows fail |
> | `TINYINT(1)` | `is_active` | The display width `(1)` is deprecated in MySQL 8 |
> | `utf8mb4_0900_ai_ci` | all 3 | **Doesn't exist in MySQL 5.7** — the #1 5→8 collation clash |
> | `UNIQUE` on `email`, `code` | — | Duplicate rows silently rejected if index lost |

---

## 2. 🟦 Seed the dummy data — parents first

**Order matters.** A foreign key means a child row cannot exist without its parent. Insert `departments` **before** `employees`, and `employees` before `projects` — the same order the import will need in the next lab.

```sql
-- 1. Parents
mysql> INSERT INTO departments (code, name, budget) VALUES
         ('FIN',  'Finance',    850000.00),
         ('IT',   'Information Technology', 1200000.50),
         ('HR',   'Human Resources', 300000.00),
         ('OPS',  'Operations', 640000.75);

-- 2. Children of departments
mysql> INSERT INTO employees (dept_id, name, email, salary, hired_on, is_active, notes) VALUES
         (1, 'Aisyah Rahman', 'aisyah@example.com',  7200.00, '2019-03-11', 1, 'Team lead, budgeting'),
         (2, 'Ben Tan',       'ben@example.com',     9500.50, '2020-07-01', 1, NULL),
         (3, 'Chandra Menon', 'chandra@example.com', 6100.00, '2018-01-22', 1, 'Handles onboarding'),
         (2, 'Divya Nair',    'divya@example.com',   8800.00, '2021-11-15', 1, 'On secondment'),
         (4, 'Farid Hassan',  'farid@example.com',   5400.25, '2017-05-30', 0, 'Left in 2024'),
         (1, 'Grace Lim',     'grace@example.com',   6750.00, '2022-02-14', 1, NULL);

-- 3. Children of both
mysql> INSERT INTO projects (dept_id, lead_id, title, status, start_date) VALUES
         (2, 2, 'MySQL 8 Upgrade',       'active',   '2025-01-15'),
         (2, 4, 'Intranet Refresh',      'planning', '2025-06-01'),
         (1, 1, 'Budget Automation',     'done',     '2024-02-01'),
         (3, 3, 'Onboarding Portal',     'on_hold',  '2024-09-10'),
         (4, NULL, 'Warehouse Stocktake','active',   '2025-03-20');   -- no lead assigned
```

Confirm what you've got:

```sql
mysql> SELECT COUNT(*) FROM departments;   -- 4
mysql> SELECT COUNT(*) FROM employees;     -- 6
mysql> SELECT COUNT(*) FROM projects;      -- 5
```

📌 **Checkpoint:** **4 departments, 6 employees, 5 projects.** Write these three numbers down — they are your first (but not only) test that the copy to `ubuntu-new-db` was complete.

> **Watch the foreign key defend itself.** Try to break the rules:
> ```sql
> mysql> INSERT INTO employees (dept_id, name, email, salary, hired_on)
>        VALUES (99, 'Ghost', 'ghost@example.com', 1000, '2025-01-01');
> ERROR 1452: Cannot add or update a child row: a foreign key constraint fails
>
> mysql> DELETE FROM departments WHERE dept_id = 1;
> ERROR 1451: Cannot delete or update a parent row: a foreign key constraint fails
> ```
> Department 99 doesn't exist, so the employee can't exist. Department 1 has staff, so `ON DELETE RESTRICT` refuses. **This integrity is a property of the schema — and it must still be there after the migration.** A copy that moves the rows but loses the constraints looks fine and isn't.

---

## 3. 🟦 Give the app exactly the access it needs

The app reads the three tables and adds an employee — `SELECT` and `INSERT`, nothing more. Not `ALL PRIVILEGES`. If the web server is ever compromised, the attacker still cannot modify, delete, or drop anything.

```sql
-- <app-IP> is ubuntu-app's 192.168.56.x host-only address
mysql> CREATE USER 'appuser'@'<app-IP>' IDENTIFIED BY 'ChangeMe_Str0ng!';
mysql> GRANT SELECT, INSERT ON appdb.* TO 'appuser'@'<app-IP>';
mysql> FLUSH PRIVILEGES;
mysql> SHOW GRANTS FOR 'appuser'@'<app-IP>';
mysql> EXIT;
```

`SHOW GRANTS` should read **`GRANT SELECT, INSERT ON \`appdb\`.*`** — and nothing more.

📌 **Checkpoint:** `appuser` holds `SELECT, INSERT` only.

> **If file 08 already created `appuser`** with wider rights, don't create it twice — tighten it:
> ```sql
> mysql> REVOKE ALL PRIVILEGES ON appdb.* FROM 'appuser'@'<app-IP>';
> mysql> GRANT SELECT, INSERT ON appdb.* TO 'appuser'@'<app-IP>';
> ```

> ⚠️ **The host part is not decoration.** `'appuser'@'192.168.56.101'` means *this user may only connect from that exact IP*. Wrong or changed IP → `Access denied` (§7).

---

## 4. 🟩 On `ubuntu-app` — prove the network path *before* writing any PHP

Debug the **link** separately from the **code**. Install the client only (no server):

```bash
$ sudo apt install mysql-client -y
```

Connect across the network:

```bash
$ mysql -h <old-db-IP> -u appuser -p appdb
Enter password: (from §3)
```

```sql
mysql> SELECT @@hostname;      -- prints: ubuntu-old-db  (you reached the other VM!)

-- a real relational query: employees with their department name
mysql> SELECT e.name, d.name AS dept, e.salary
       FROM employees e JOIN departments d ON e.dept_id = d.dept_id
       ORDER BY e.emp_id;

mysql> EXIT;
```

📌 **Checkpoint:** From `ubuntu-app` you reach MySQL on `ubuntu-old-db` and the `JOIN` returns 6 employees with department names. **If this fails, fix it with §7 before touching PHP.**

---

## 5. 🟩 Store the DB credentials outside the web root

```bash
$ sudo nano /var/www/appconfig.php
```

```php
<?php
// Outside /var/www/html, so it can never be served or downloaded.
return [
    'host' => '<old-db-IP>',        // ← ubuntu-old-db. THE ONE LINE we change after the copy.
    'db'   => 'appdb',
    'user' => 'appuser',
    'pass' => 'ChangeMe_Str0ng!',
];
```

> That `host` line is the hinge of the course. On a single-server app it would say `127.0.0.1`. Here it points across the network at `ubuntu-old-db` — and in the next lab, after you copy the data, you point it at `ubuntu-new-db` and the page just works.

```bash
$ sudo chown root:www-data /var/www/appconfig.php
$ sudo chmod 640 /var/www/appconfig.php
```

> `640` = owner read/write, group (`www-data`, which PHP-FPM runs as) read, **everyone else nothing**.

---

## 6. 🟩 Write the app

```bash
$ sudo rm -f /var/www/html/index.nginx-debian.html
$ sudo nano /var/www/html/index.php
```

```php
<?php
$cfg = require '/var/www/appconfig.php';

$dsn = "mysql:host={$cfg['host']};dbname={$cfg['db']};charset=utf8mb4";
try {
    $pdo = new PDO($dsn, $cfg['user'], $cfg['pass'], [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    ]);
} catch (PDOException $e) {
    http_response_code(500);
    exit('Database connection failed: ' . $e->getMessage());
}

// --- WRITE: the form posted a new employee ---------------------------------
$error = null;
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        $stmt = $pdo->prepare(
            'INSERT INTO employees (dept_id, name, email, salary, hired_on)
             VALUES (?, ?, ?, ?, ?)'
        );
        $stmt->execute([
            $_POST['dept_id'],   // must be a real department — the FK enforces it
            $_POST['name'],
            $_POST['email'],
            $_POST['salary'],
            $_POST['hired_on'],
        ]);
        header('Location: /');   // redirect after POST: a refresh won't re-insert
        exit;
    } catch (PDOException $e) {
        $error = $e->getMessage();   // e.g. duplicate email, or bad dept_id
    }
}

// --- READ -------------------------------------------------------------------
$dbHost = $pdo->query('SELECT @@hostname')->fetchColumn();

// JOIN across two tables
$employees = $pdo->query(
    'SELECT e.emp_id, e.name, e.email, e.salary, e.hired_on, e.is_active, d.code, d.name AS dept
     FROM employees e
     JOIN departments d ON e.dept_id = d.dept_id
     ORDER BY e.emp_id'
)->fetchAll(PDO::FETCH_ASSOC);

// JOIN across three tables — LEFT JOIN, because a project may have no lead
$projects = $pdo->query(
    'SELECT p.title, p.status, p.start_date, d.name AS dept, COALESCE(l.name, "—") AS lead
     FROM projects p
     JOIN departments d ON p.dept_id = d.dept_id
     LEFT JOIN employees l ON p.lead_id = l.emp_id
     ORDER BY p.proj_id'
)->fetchAll(PDO::FETCH_ASSOC);

$departments = $pdo->query('SELECT dept_id, code, name FROM departments ORDER BY dept_id')
                   ->fetchAll(PDO::FETCH_ASSOC);
?>
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Company Directory</title>
  <style>
    body   { font-family: sans-serif; max-width: 900px; margin: 2rem auto; }
    table  { border-collapse: collapse; width: 100%; margin-bottom: 2rem; }
    th, td { border: 1px solid #ccc; padding: .45rem .7rem; text-align: left; }
    th     { background: #f2f2f2; }
    .meta  { color: #666; font-size: .9rem; }
    .err   { background: #fdd; border: 1px solid #c00; padding: .6rem; }
    form   { background: #f9f9f9; border: 1px solid #ddd; padding: 1rem; }
    input, select { padding: .4rem; margin: .2rem; }
  </style>
</head>
<body>
  <h1>Company Directory</h1>

  <p class="meta">
    Served by <strong>Nginx + PHP-FPM</strong> on <strong>ubuntu-app</strong>.<br>
    Data in MySQL at <strong><?= htmlspecialchars($cfg['host']) ?></strong>
    — database host: <strong><?= htmlspecialchars($dbHost) ?></strong>.
  </p>

  <?php if ($error): ?>
    <p class="err"><strong>Insert rejected by the database:</strong><br>
       <?= htmlspecialchars($error) ?></p>
  <?php endif; ?>

  <h2>Employees (<?= count($employees) ?>)</h2>
  <table>
    <tr><th>#</th><th>Name</th><th>Dept</th><th>Email</th><th>Salary</th><th>Hired</th><th>Active</th></tr>
    <?php foreach ($employees as $e): ?>
      <tr>
        <td><?= (int)$e['emp_id'] ?></td>
        <td><?= htmlspecialchars($e['name']) ?></td>
        <td><?= htmlspecialchars($e['dept']) ?> (<?= htmlspecialchars(trim($e['code'])) ?>)</td>
        <td><?= htmlspecialchars($e['email']) ?></td>
        <td><?= number_format((float)$e['salary'], 2) ?></td>
        <td><?= htmlspecialchars($e['hired_on']) ?></td>
        <td><?= $e['is_active'] ? 'yes' : 'no' ?></td>
      </tr>
    <?php endforeach; ?>
  </table>

  <h2>Projects (<?= count($projects) ?>)</h2>
  <table>
    <tr><th>Title</th><th>Dept</th><th>Lead</th><th>Status</th><th>Start</th></tr>
    <?php foreach ($projects as $p): ?>
      <tr>
        <td><?= htmlspecialchars($p['title']) ?></td>
        <td><?= htmlspecialchars($p['dept']) ?></td>
        <td><?= htmlspecialchars($p['lead']) ?></td>
        <td><?= htmlspecialchars($p['status']) ?></td>
        <td><?= htmlspecialchars($p['start_date']) ?></td>
      </tr>
    <?php endforeach; ?>
  </table>

  <h2>Add an employee</h2>
  <form method="post">
    <select name="dept_id" required>
      <option value="">— department —</option>
      <?php foreach ($departments as $d): ?>
        <option value="<?= (int)$d['dept_id'] ?>"><?= htmlspecialchars($d['name']) ?></option>
      <?php endforeach; ?>
    </select>
    <input name="name"     placeholder="Full name" required>
    <input name="email"    type="email"  placeholder="Email" required>
    <input name="salary"   type="number" step="0.01" placeholder="Salary" required>
    <input name="hired_on" type="date"   required>
    <button type="submit">Add</button>
  </form>
</body>
</html>
```

> **Teaching points in this code:**
> - The app connects to a **remote** host (`$cfg['host']`), not localhost.
> - **The dropdown is populated from `departments`** — the app can only offer real parent rows. And if a bad `dept_id` gets through anyway, the **foreign key rejects it at the database**. Validation in the app is a convenience; the constraint is the guarantee.
> - **Prepared statements** (`prepare()` + `execute([...])`) mean values never become SQL text — an employee named `Bobby'); DROP TABLE employees;--` is stored as a harmless string. That's the SQL-injection defence.
> - The **`LEFT JOIN`** on `projects` is why "Warehouse Stocktake" still appears with no lead — a plain `JOIN` would hide it. That's `NULL` handling made visible.
> - **`htmlspecialchars()`** on every output prevents XSS.
> - The page prints the **database's own hostname** — your proof of *which server* answered, and what makes the switch to `ubuntu-new-db` self-evident next lab.

---

## 7. See it in the browser

From your **Windows host**: `http://<app-IP>/` (e.g. `http://192.168.56.101/`)

You should see **Employees (6)** with department names joined in, **Projects (5)** with leads (and one dash), and the line *"database host: **ubuntu-old-db**"*.

**Now exercise the schema from the browser:**

1. **Add yourself** using the form → the row appears, count goes to **7**.
2. **Add someone with an email that already exists** (e.g. `ben@example.com`) → red box: *Duplicate entry … for key 'email'*. The `UNIQUE` index did that, not the PHP.

📌 **Checkpoint:** The joined tables render, you added an employee, and the duplicate email was **rejected by the database**. Confirm your row crossed the network — 🟦 on `ubuntu-old-db`:

```sql
mysql> SELECT e.name, d.name AS dept FROM appdb.employees e
       JOIN appdb.departments d ON e.dept_id = d.dept_id
       ORDER BY e.emp_id DESC LIMIT 1;
```

---

## 8. If it fails — debug the link by layer

```bash
# 🟩 on ubuntu-app — can you even reach the port?
$ nc -zv <old-db-IP> 3306      # "succeeded" = firewall + bind OK; "timed out" = blocked
```

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| `nc` times out | Firewall closed to the app, or MySQL bound to localhost | On `old-db`: `sudo ufw allow from <app-IP> to any port 3306`; `bind-address = 0.0.0.0` (file 08) |
| `Access denied for user 'appuser'@'192.168.56.x'` | User's host doesn't match the app's real IP | Recreate with the real IP, or `'appuser'@'192.168.56.%'` (§3) |
| Page reads fine, **form fails** with `INSERT command denied` | Grant has `SELECT` but not `INSERT` | `GRANT SELECT, INSERT ...` (§3) |
| `Cannot add or update a child row … foreign key constraint fails` | `dept_id` doesn't exist in `departments` | Working as designed — pick a real department |
| `Duplicate entry … for key 'email'` | `UNIQUE` index | Working as designed — use a different email |
| `502 Bad Gateway` | **Not a database problem** — Nginx can't reach PHP-FPM | file 10 §5 |
| Blank white page | PHP fatal error | `sudo tail -n 30 /var/log/nginx/error.log` |

> **The three-layer rule.** Reaching a remote MySQL needs three things to line up, and they fail in this order:
> 1. **Port** — firewall allows the app's IP; MySQL bound to the network, not `127.0.0.1`.
> 2. **Auth** — the user exists *for that source IP*, with the right password.
> 3. **Grant** — the user may run *that verb* on that database. Reading can work while writing fails; that's layer 3.
>
> Note the last two table rows are **not failures** — they're the schema defending itself. Learn to tell "broken" from "working correctly and refusing you".

---

## Wrap-up — snapshot the working stack

- [ ] Three related tables on `ubuntu-old-db`: **4 departments, 6 employees, 5 projects**
- [ ] Foreign keys enforced — bad `dept_id` rejected, parent department undeletable
- [ ] Nginx + PHP-FPM serve the joined data from `ubuntu-app`
- [ ] The app connects **across the network** as a user holding only `SELECT, INSERT`, scoped to the app's IP
- [ ] Adding an employee writes to `ubuntu-old-db`; a duplicate email is refused
- [ ] The page names `ubuntu-old-db` as the database host

Snapshot **both** VMs:

- Name: **`day2-app-working`**
- Description: `Nginx+PHP app on ubuntu-app reading/writing 3-table schema on ubuntu-old-db`

> **Trainer note (Luqman):** The §2 foreign-key demo is the one to slow down on — `ERROR 1452` and `ERROR 1451` are what make the next lab's "import the parent table first" rule feel inevitable rather than arbitrary. Also make everyone run `SHOW CREATE TABLE employees;` and actually *look* at it before lunch; they'll be diffing it against `ubuntu-new-db` in the copy lab, and it's much easier if they've seen it once already.

Next: **`12-database-copy.md`** — copy this schema *and* its data to `ubuntu-new-db`, then repoint the app and watch the hostname change.
