# Day 3 — Finish Migration + Deepen LAMP & Security

**AM mode:** Instructor demo
**PM mode:** Hands-on / discussion

**Goal:** Complete the MySQL 5 → 8 migration properly (resolve differences, validate), then go deeper on MySQL administration and security hardening.

---

## Where we are

Day 2 ended at snapshot `day2-migration-loaded`: the source data is inside MySQL 8 on the target, but **not yet validated** and possibly with a few 5→8 rough edges. Today we finish the job.

---

## Morning (AM) — finish the migration, instructor demo

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

Days 1–2 built up the rules (SSH 22, Apache 80/443, MySQL 3306-from-source). Today's **file 19** reviews the whole firewall posture in one place, confirms the principle of *least exposure*, and discusses production-grade choices (static IPs, disabling password SSH, closing 3306 again after migration).

---

## Day 3 success checklist

- [ ] 5→8 differences identified and resolved (reserved words, auth plugin, engine, charset)
- [ ] Upgrade checker run; reported issues understood
- [ ] Migration validated (row counts, checksums, key objects present)
- [ ] (Optional) Sample app confirmed still reading migrated data — *see file 17*
- [ ] Deeper MySQL admin practiced (backup, logs, config)
- [ ] Full security hardening pass completed and firewall posture reviewed
- [ ] Troubleshooting workshop scenarios worked through
- [ ] Final snapshot `day3-complete` taken on both VMs

> **Pending decision (flagged in file 17):** whether to keep the optional "app still works" validation check. It's included but clearly marked optional — the trainer decides on the day based on time.

At the end of Day 3 the trainees can: install and secure Ubuntu, stand up a LAMP stack, migrate a MySQL 5.x database to MySQL 8, validate it, and harden the result.
