# Day 3 — Validate, Deepen & Harden

**AM mode:** Hands-on validation + discussion
**PM mode:** Hands-on / discussion

**Goal:** Prove yesterday's database copy was correct, understand what a *cross-version* migration adds on top, then go deeper — hands-on — on MySQL administration and hardening all three servers.

---

## Where we are

Day 2 left you with a working three-VM setup and a completed copy:

```
   ubuntu-app                 ubuntu-old-db              ubuntu-new-db
   ┌──────────────┐           ┌──────────────┐           ┌──────────────┐
   │ Nginx + PHP  │ ── SQL ──►│  MySQL 8     │  copied ─►│  MySQL 8     │
   │ (cut over ───┼───────────┼──────────────┼──────────►│  appdb       │
   │  to new-db)  │           │  appdb       │           │  (now live)  │
   └──────────────┘           └──────────────┘           └──────────────┘
```

The app is serving from `ubuntu-new-db`. But "it works" is not the same as "the copy was correct" — you haven't *proven* the schema and data survived intact. That's this morning's first job.

---

## Morning (AM) — validate, and understand cross-version migration

| # | File | Mode | Covers |
|---|------|------|--------|
| 17 | `17-post-migration-validation.md` | **hands-on** | **Prove your copy is correct** — schema `diff`, row counts, checksums (`old-db` vs `new-db`) |
| 15 | `15-mysql5-vs-mysql8-differences.md` | discussion | What a real **5→8** migration must fix — the differences your same-version copy didn't hit |
| 16 | `16-upgrade-checker.md` | discussion | MySQL Shell's upgrade checker: find those issues automatically |

> **Do file 17 first — it's the hands-on payoff of Day 2.** Files 15 and 16 are the *cross-version* story: they explain what your same-version copy got to skip, and what the trainer's separate CentOS → Ubuntu migration has to deal with. Cover them as time permits.

## Afternoon (PM) — depth + hardening, hands-on/discussion

| # | File | Covers |
|---|------|--------|
| 18 | `18-mysql-admin-deeper.md` | Backups, logs, config, performance basics |
| 19 | `19-security-hardening.md` | Consolidated hardening: OS, SSH, firewall, MySQL, web |
| 20 | `20-troubleshooting-workshop.md` | Guided practice fixing broken scenarios |

---

## The firewall thread — consolidation day

Days 1–2 built the rules across three machines (SSH 22 everywhere; web 80/443 on `ubuntu-app`; MySQL 3306-from-app-IP on **both** `ubuntu-old-db` and `ubuntu-new-db`). Today's **file 19** reviews the whole posture in one place, confirms *least exposure*, and discusses production-grade choices (static host-only IPs, disabling password SSH, keeping 3306 scoped to exactly the app server on every database VM).

---

## Day 3 success checklist

- [ ] Copy **validated**: schema `diff` identical, row counts match, checksums match on unchanged tables
- [ ] Can explain the difference between a same-version **copy** and a cross-version **migration**
- [ ] (Discussion) 5→8 differences understood; upgrade checker's role clear
- [ ] Deeper MySQL admin practiced (backup, logs, config)
- [ ] Full hardening pass across all three servers; firewall posture reviewed
- [ ] Troubleshooting workshop scenarios worked through
- [ ] Final snapshot `day3-complete` taken on all three VMs

At the end of Day 3 you can: install and secure Ubuntu; stand up an **Nginx + PHP-FPM + MySQL 8** stack split across separate app and database servers, linked over a scoped network path; **copy a database between servers and prove the copy correct**; administer and harden the whole thing; and you understand how a cross-version MySQL 5.x → 8 migration differs from the same-version copy you performed.
