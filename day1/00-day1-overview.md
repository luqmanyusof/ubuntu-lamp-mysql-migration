# Day 1 — Ubuntu Foundations

**Mode:** Hands-on labs
**Goal:** By the end of today you will have **two secured Ubuntu Server VMs** (an *app server* and a *database server*) running in VirtualBox, both reachable over SSH from your Windows host.

These two VMs are the foundation for the rest of the course — a small but realistic **two-tier** setup where the application and the database live on **separate machines**:

- **ubuntu-app** — will later run **Apache + PHP** (the web/application tier).
- **ubuntu-db** — will later run **MySQL 8** (the database tier).

Tomorrow the app on `ubuntu-app` connects to MySQL on `ubuntu-db` **over the network** — which is exactly why we get comfortable SSH-ing into both today.

Today we do not install any software yet. Today is purely about getting Ubuntu installed, understood, and locked down on both.

---

## What you will build today

```
Windows Host (your laptop)
│
├── VirtualBox
│   ├── VM: ubuntu-app   (Ubuntu Server — later Apache + PHP)   SSH on port 22
│   └── VM: ubuntu-db    (Ubuntu Server — later MySQL 8)        SSH on port 22
│
└── You connect to both VMs via SSH from a Windows terminal
    (and tomorrow, ubuntu-app talks to ubuntu-db over the network)
```

---

## Files in this folder (do them in order)

| # | File | What you achieve |
|---|------|------------------|
| 00 | `00-day1-overview.md` | This page — the map for the day |
| 01 | `01-virtualbox-setup.md` | Install VirtualBox and create the two empty VMs (`ubuntu-app`, `ubuntu-db`) |
| 02 | `02-download-ubuntu-iso.md` | Download and verify the Ubuntu Server ISO |
| 03 | `03-ubuntu-installation.md` | Install Ubuntu Server on **both** VMs |
| 04 | `04-linux-admin-essentials.md` | Learn the everyday Linux admin commands |
| 05 | `05-system-services-security.md` | Services, SSH, and the firewall (UFW) |

---

## How to read these labs

- **Commands** appear in code blocks. Type them yourself — don't copy blindly; read what each does.
- Lines beginning with `$` are run as your **normal user**.
- Lines beginning with `#` (in a command block) are run as **root** / with `sudo`.
- 📌 **Checkpoint** boxes tell you how to confirm a step worked before moving on.
- ⚠️ **Watch out** boxes flag the common mistakes.

> **Trainer note (Luqman):** We do every step twice — once on `ubuntu-app`, once on `ubuntu-db`. Do the first VM together as a group, then let each trainee do the second VM on their own to build muscle memory.

---

## The firewall thread starts today

Firewall is taught across all three days, not in one block. Today (Day 1) you learn:

- What **UFW** (Uncomplicated Firewall) is
- How to enable it **without locking yourself out**
- How to **allow SSH (port 22)** so you keep remote access

Later days add web ports on `ubuntu-app` (80/443) and MySQL on `ubuntu-db` (3306, opened **only** to the app server). Keep this progression in mind.

---

## Day 1 success checklist

You are done with Day 1 when **all** of these are true for **both** VMs:

- [ ] VM boots to a login prompt
- [ ] You can log in with your user and use `sudo`
- [ ] `ip a` shows a working IP address
- [ ] You can SSH in from the Windows host
- [ ] `sudo ufw status` shows the firewall **active** with SSH allowed
- [ ] System is fully updated (`sudo apt update && sudo apt upgrade`)
- [ ] You have taken a **VirtualBox snapshot** named `day1-clean` on each VM

The snapshot at the end is important — it's our safe restore point before we start installing software on Day 2 (Apache + PHP on `ubuntu-app`, MySQL 8 on `ubuntu-db`).
