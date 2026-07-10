# Day 3 — Finish Migration + Deepen LAMP & Security

**AM mode:** Instructor demo
**PM mode:** Hands-on / discussion

**Goal:** Watch the trainer finish the MySQL 5 → 8 migration properly (resolve differences, validate), then go deeper — hands-on — on MySQL administration and hardening your own two-tier stack.

---

## Where we are

- **Your stack:** the two-tier LAMP from Day 2 (`day2-two-tier` snapshot) — app on `ubuntu-app`, MySQL 8 on `ubuntu-db`.
- **The demo:** the trainer's CentOS → Ubuntu migration ended at `day2-migration-loaded` — the CentOS data is inside MySQL 8 but **not yet validated** and possibly with a few 5→8 rough edges. This morning the trainer finishes it while you watch.

---

## Morning (AM) — finish the migration demo, instructor-led

| # | File | Covers |
|---|------|--------|
| 15 | `15-mysql5-vs-mysql8-differences.md` | The real differences and how to fix each |
| 16 | `16-upgrade-checker.md` | Use MySQL Shell's upgrade checker to find issues automatically |
| 17 | `17-post-migration-validation.md` | Prove the migration is complete and correct |

## Afternoon (PM) — depth + hardening, hands-on/discussion

| # | File | Covers |
|---|------|--------|
| 18 | `18-mysql-admin-deeper.md` | Backups, logs, config, performance basics |
| 19 | `19-security-hardening.md` | Consolidated hardening: OS, SSH, firewall, MySQL, web |
| 20 | `20-troubleshooting-workshop.md` | Guided practice fixing broken scenarios |

---

## The firewall thread — consolidation day

Days 1–2 built up the rules across two machines (SSH 22 on both; web 80/443 on `ubuntu-app`; MySQL 3306-from-app-IP on `ubuntu-db`). Today's **file 19** reviews the whole two-tier firewall posture in one place, confirms the principle of *least exposure*, and discusses production-grade choices (static IPs, disabling password SSH, keeping 3306 scoped to exactly the app server).

---

## Day 3 success checklist

- [ ] (Demo) 5→8 differences identified and resolved (reserved words, auth plugin, engine, charset)
- [ ] (Demo) Upgrade checker run; reported issues understood
- [ ] (Demo) Migration validated (row counts, checksums, key objects present)
- [ ] Deeper MySQL admin practiced on `ubuntu-db` (backup, logs, config)
- [ ] Full two-tier hardening pass completed and firewall posture reviewed
- [ ] Troubleshooting workshop scenarios worked through
- [ ] Final snapshot `day3-complete` taken on both `ubuntu-app` and `ubuntu-db`

> **Pending decision (flagged in file 17):** whether to keep the optional "app still works" validation check in the demo. It's included but clearly marked optional — the trainer decides on the day based on time.

At the end of Day 3 the trainees can: install and secure Ubuntu, stand up a **two-tier** LAMP stack (app and DB on separate servers, linked over a scoped network path), administer and harden it — and they understand how a MySQL 5.x → 8 migration is planned, executed, and validated (having watched a real CentOS → Ubuntu one).
