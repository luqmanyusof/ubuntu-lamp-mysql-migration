# 04 — Linux Admin Essentials

**Goal:** Learn the everyday Linux commands you need to run these servers with confidence — navigating, editing files, managing packages, users, and permissions.

**Time:** ~60 minutes

> Do this lab on **`ubuntu-source`** (log in at its console, or SSH in once you've done lab 05). Every command here is safe to run and repeat.

---

## 1. Understanding the prompt

```
student@ubuntu-source:~$
│       │             │ │
│       │             │ └─ $ = normal user   (# would mean root)
│       │             └─── ~ = your home directory (/home/student)
│       └───────────────── the machine's hostname
└───────────────────────── your username
```

---

## 2. `sudo` — running admin commands

Your `student` user is a normal user. To do admin tasks (install software, edit system files) you prefix the command with **`sudo`** ("superuser do"). It asks for *your* password the first time.

```bash
$ sudo whoami
root
```

> **Rule of thumb:** run as your normal user; add `sudo` only when a command needs admin rights. Avoid logging in as root directly.

---

## 3. Moving around the filesystem

Linux has one big tree starting at `/` (root). Key commands:

```bash
$ pwd            # print working directory — where am I?
$ ls             # list files here
$ ls -l          # long listing: permissions, owner, size, date
$ ls -la         # also show hidden files (those starting with .)
$ cd /etc        # change directory to /etc
$ cd ~           # go to your home directory
$ cd ..          # go up one level
$ cd -           # go back to the previous directory
```

Important directories to know:

| Path | What lives there |
|------|------------------|
| `/etc` | System configuration files |
| `/var/log` | Log files |
| `/home/student` | Your personal files |
| `/usr/bin` | Installed programs |
| `/tmp` | Temporary files (wiped on reboot) |

📌 **Checkpoint:** `cd /var/log` then `ls` — you should see files like `syslog` and `auth.log`.

---

## 4. Looking at files

```bash
$ cat /etc/hostname          # dump a whole (small) file
$ less /var/log/syslog       # scroll a big file: ↑ ↓ PgUp PgDn, q to quit
$ head -n 20 /var/log/syslog # first 20 lines
$ tail -n 20 /var/log/syslog # last 20 lines
$ tail -f /var/log/syslog    # live-follow a log (Ctrl+C to stop)
```

`tail -f` is your best friend when watching a service in real time.

---

## 5. Editing files with `nano`

`nano` is the beginner-friendly text editor. We'll use it throughout the course.

```bash
$ nano notes.txt
```

Inside nano:
- Type normally to edit.
- **Ctrl+O** then **Enter** = save (write Out).
- **Ctrl+X** = exit.
- **Ctrl+K** = cut a line, **Ctrl+U** = paste.

To edit a system file you need sudo:

```bash
$ sudo nano /etc/hosts
```

> ⚠️ Editing system files carelessly can break things. When a lab says edit a config file, change only the lines it tells you to.

---

## 6. Package management with APT

Ubuntu installs software from **repositories** using `apt`. Two commands you'll run constantly:

```bash
$ sudo apt update            # refresh the list of available packages
$ sudo apt upgrade           # install available updates
```

Installing and removing software:

```bash
$ sudo apt install tree      # install a package (example: 'tree')
$ tree /etc/apt              # try the tool you just installed
$ sudo apt remove tree       # remove it
$ apt search htop            # search for a package
```

**Update your system fully now** (do this on both VMs):

```bash
$ sudo apt update && sudo apt upgrade -y
```

The `&&` means "run the second command only if the first succeeded". `-y` auto-answers yes.

📌 **Checkpoint:** `apt upgrade` finishes with `0 to upgrade` when run a second time — the system is current.

---

## 7. Users and groups (a first look)

```bash
$ whoami                 # your username
$ id                     # your user id and group memberships
$ groups                 # groups you belong to (note: sudo)
```

Creating a user (we don't need extra users today, but know the command):

```bash
$ sudo adduser bob       # interactive: creates user 'bob' + home dir
$ sudo usermod -aG sudo bob   # give bob admin rights (add to sudo group)
$ sudo deluser bob       # remove a user
```

> **Why it matters for migration:** MySQL and Apache run as their own dedicated Linux users (`mysql`, `www-data`). Understanding users now makes those services make sense later.

---

## 8. File permissions

Every file has an **owner**, a **group**, and permission bits. `ls -l` shows them:

```
-rw-r--r-- 1 student student 220 Jul 10 09:00 notes.txt
│└┬┘└┬┘└┬┘   └──┬──┘ └──┬──┘
│ │  │  │       owner   group
│ │  │  └─ others: r--  (read only)
│ │  └──── group:  r--  (read only)
│ └─────── owner:  rw-  (read + write)
└───────── type:   -    (- = file, d = directory)
```

Changing permissions and ownership:

```bash
$ chmod 640 notes.txt          # owner rw, group r, others none
$ sudo chown student:student notes.txt   # set owner:group
```

The three digits are owner/group/others, where **4=read, 2=write, 1=execute** added together (so `6 = 4+2 = rw`, `7 = rwx`).

📌 **Checkpoint:** `chmod 600 notes.txt` then `ls -l notes.txt` shows `-rw-------`.

---

## 9. Disk, memory, and processes

```bash
$ df -h            # disk space, human-readable
$ free -h          # memory usage
$ top              # live process viewer (q to quit)
$ ps aux | grep ssh   # find running processes matching 'ssh'
```

The `|` (pipe) sends the output of one command into another — here `ps aux` into `grep`.

---

## 10. Getting help

```bash
$ man ls           # full manual for a command (q to quit)
$ ls --help        # quick usage summary
```

---

## Command cheat-sheet

| Task | Command |
|------|---------|
| Where am I | `pwd` |
| List files | `ls -la` |
| Change dir | `cd /path` |
| View file | `less file` |
| Edit file | `nano file` |
| Update system | `sudo apt update && sudo apt upgrade` |
| Install software | `sudo apt install <name>` |
| Disk space | `df -h` |
| Memory | `free -h` |
| Processes | `top` |
| Who am I | `whoami` / `id` |

---

## Done

You can now navigate and administer the system. Next: **`05-system-services-security.md`** — services, SSH access, and the firewall.
