# Trainer-only materials

> **Private. Not for participants.** This folder is your (Luqman's) operational reference. Nothing here is a participant lab.

## Why this exists

Two facts changed the shape of the course:

1. **The real legacy database runs on CentOS**, not Ubuntu — it's a **CentOS + MySQL 5.x** server. The migration to MySQL 8 is a **real, one-time job you perform yourself**. Participants do **not** migrate anything; they watch the migration as an instructor demo.
2. **The migration target is a separate, real Ubuntu MySQL 8 server** — independent of the two training VMs the participants build. Keep it distinct from the classroom `ubuntu-db` so nobody confuses the demo with their own lab box.

## Files

| File | Purpose |
|------|---------|
| `00-README.md` | This note |
| `centos-mysql5-to-ubuntu-mysql8-migration.md` | The full end-to-end migration runbook: CentOS MySQL 5.x → a separate Ubuntu MySQL 8 server. Exact commands, CentOS-specifics (yum/firewalld/SELinux), rollback, and a pre-flight inventory. |

## How this maps to the participant course

- The **teaching narrative** of the migration lives in the participant files (`day2/12–14`, `day3/15–17`). Those explain *what/why/risks/validation* while you demo.
- **This runbook** is the *operational checklist* you actually run — including everything CentOS-specific that the Ubuntu-focused participant files deliberately leave out.

Run the migration for real (or a rehearsed CentOS→Ubuntu VM pair) ahead of the session, take snapshots, and keep a known-good dump on standby. Then drive the demo from the teaching files with this runbook open beside you.
