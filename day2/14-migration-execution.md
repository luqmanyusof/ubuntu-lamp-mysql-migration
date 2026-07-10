# 14 — Migration Execution

**Mode:** Instructor demo (trainees watch)
**Goal:** Transfer the CentOS dump to the Ubuntu target and **import it into MySQL 8**, reaching a clean stopping point with the data loaded.

**Time:** ~30–40 minutes narrated

> We move a **file** between servers, then import **locally** on the Ubuntu target. Because we import locally, MySQL 8 needn't accept a live network connection from the source — minimal exposure.

---

## 1. Transfer the dump: CentOS source → Ubuntu target

We use `scp` (secure copy over SSH). Run this **on the CentOS source**, sending to the Ubuntu target's IP:

```bash
# scp ~/sourcedb_dump.sql.gz  student@<ubuntu-target-IP>:~/
```

Enter the target's `student` password when prompted.

> **About the firewall & port 3306:** This method copies a *file* over SSH (port 22, already open) and imports *locally* on the target — so we do **not** need to open 3306 for MySQL at all.
>
> **If** instead you demonstrate a *direct network import* (`mysql -h <ubuntu-target-IP>` from the CentOS source), then — and only then — open 3306 narrowly **on the Ubuntu target**:
> ```bash
> $ sudo ufw allow from <centos-source-IP> to any port 3306
> ```
> Never open 3306 to `Anywhere`. (On the CentOS side the equivalent rule is `firewall-cmd`, not UFW — see the trainer runbook.) For the file-transfer method shown here, you can skip it.

📌 **Checkpoint:** `sourcedb_dump.sql.gz` now exists in the Ubuntu target's home directory (`ls ~` on the target).

---

## 2. On the target, decompress the dump

SSH into the **Ubuntu target** (`ubuntu-db-new`):

```bash
$ gunzip ~/sourcedb_dump.sql.gz
$ ls -lh ~/sourcedb_dump.sql
```

---

## 3. Import into MySQL 8

Because the dump includes `CREATE DATABASE sourcedb` (we used `--databases`), we import as the MySQL admin:

```bash
$ sudo mysql < ~/sourcedb_dump.sql
```

This runs every statement in the file. On a small database it finishes in seconds to a couple of minutes.

> **Watch the output.** Errors here are the interesting part — they're the 5→8 differences we discussed. Common ones:
> - `ERROR 1064 ... near 'rank'` → reserved word (Day 3 file 15 fixes this).
> - Collation or `utf8mb4` warnings.
> - Authentication-plugin notes when users are recreated.
>
> **If the import stops on an error**, note it, and either fix inline or fall back to the known-good dump. Remember: **fully resolving differences is Day 3.** Today's target is "data is in MySQL 8."

📌 **Checkpoint:** The import completes (warnings are okay; a hard stop we handle case-by-case).

---

## 4. Confirm the data landed

```bash
$ sudo mysql
```

```sql
mysql> SHOW DATABASES;                 -- sourcedb should be listed
mysql> USE sourcedb;
mysql> SHOW TABLES;                    -- compare count to what you noted in file 13
mysql> SELECT COUNT(*) FROM some_table;   -- compare row count to file 13
mysql> EXIT;
```

📌 **Checkpoint:** `sourcedb` exists in MySQL 8, tables are present, and at least one row count matches what you recorded on the source. **This is our clean stopping point.**

---

## 5. Recreate the application user on MySQL 8 (if the app connects to migrated data)

A `mysqldump` of a single database does **not** carry over the global `mysql.user` accounts. If an application needs to connect to the migrated `sourcedb`, create its user on MySQL 8 using the modern auth plugin:

```sql
mysql> CREATE USER 'sourceapp'@'localhost' IDENTIFIED BY 'Str0ng_Pass!';
mysql> GRANT SELECT, INSERT, UPDATE, DELETE ON sourcedb.* TO 'sourceapp'@'localhost';
mysql> FLUSH PRIVILEGES;
```

> This is where the **auth-plugin change** bites in real projects: old apps expecting `mysql_native_password` may need
> `IDENTIFIED WITH mysql_native_password BY '...'` instead. We explore this properly in **file 15**.

---

## 6. Snapshot the loaded state (trainer's demo hosts)

Take a snapshot on **both** demo hosts now:

- Name: **`day2-migration-loaded`**
- Description: `CentOS dump imported into Ubuntu MySQL 8; pre-validation`

This is the restore point the demo starts Day 3 from. (Trainees already snapshotted their own `ubuntu-app`/`ubuntu-db` as `day2-two-tier` in file 11 — those are untouched by this demo.)

📌 **Checkpoint:** Snapshot `day2-migration-loaded` exists on both demo hosts.

---

## Day 2 wrap-up

**Participant stack (AM, hands-on):**
- [ ] Two-tier LAMP working: app on `ubuntu-app`, MySQL 8 on `ubuntu-db`
- [ ] App reaches the database across the network; `day2-two-tier` snapshot taken

**Migration demo (PM, watched):**
- [ ] CentOS source dumped consistently, known-good copy kept
- [ ] Dump transferred and imported into the Ubuntu MySQL 8 target
- [ ] Data present in MySQL 8 (counts match source)
- [ ] Demo hosts snapshotted at `day2-migration-loaded`

> **Trainer note (Luqman):** End the demo here even if some warnings appeared. The data is across — that's the Day 2 PM goal. Tomorrow morning you resolve the 5→8 differences and validate properly. Resist fixing everything now; the split protects your timing. Keep the runbook (`trainer-only/…`) open for the CentOS-side commands.

Next: **Day 3** — finish the migration demo (files 15–17), then trainees deepen MySQL admin & harden their two-tier stack (18–20).
