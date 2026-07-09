# 05 — System Services, SSH & Firewall

**Goal:** Understand how Linux services work, connect to both VMs over **SSH** from Windows, and enable the **UFW firewall** with SSH allowed — without locking yourself out.

**Time:** ~50 minutes

> This is the lab that makes the VMs *remotely usable and secured*. Do it on **both** VMs.

---

## Part A — Services with `systemctl`

Background programs on Linux (SSH, later Apache and MySQL) are managed by **systemd**. You control them with **`systemctl`**.

```bash
$ systemctl status ssh       # is the SSH service running?
$ sudo systemctl start ssh   # start it
$ sudo systemctl stop ssh    # stop it
$ sudo systemctl restart ssh # restart it
$ sudo systemctl enable ssh  # start automatically at boot
$ sudo systemctl disable ssh # don't start at boot
```

Read a status output:

```
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (...; enabled; ...)      ← 'enabled' = starts at boot
     Active: active (running) since ...       ← 'active (running)' = it's up
```

📌 **Checkpoint:** `systemctl status ssh` shows **active (running)** and **enabled**. If SSH isn't running:

```bash
$ sudo systemctl enable --now ssh
```

`--now` enables *and* starts it in one step.

---

## Part B — Connect over SSH from Windows

SSH lets you control the VM from a comfortable Windows terminal instead of the small VirtualBox console window.

### B1. Find the VM's IP

On the VM:

```bash
$ ip a | grep inet
```

Look for the `inet 192.168.x.x` line on the main adapter (usually `enp0s3` or `eth0`). Note it — call it `<VM-IP>`.

### B2. Connect from Windows

Windows 10/11 has a built-in SSH client. Open **PowerShell** (or Windows Terminal) on your host and run:

```powershell
ssh student@<VM-IP>
```

Example:

```powershell
ssh student@192.168.1.50
```

- First time, it asks to trust the host key → type **`yes`** → Enter.
- Enter your `student` password.

You should land at:

```
student@ubuntu-source:~$
```

You're now controlling the VM from Windows. 🎉

📌 **Checkpoint:** You can open a PowerShell window on Windows and SSH into **both** `ubuntu-source` and `ubuntu-target`.

> ⚠️ **Bridged IP changed?** If SSH suddenly can't connect after a reboot, the DHCP IP may have changed — re-check with `ip a` on the console. (Static IPs are covered on Day 3.)

> **Trainer note (Luqman):** Get everyone SSH-ing in successfully before moving to the firewall. Two terminals side by side — one for `source`, one for `target` — is how we'll work for the rest of the course.

### B3. (Optional but recommended) SSH keys instead of passwords

Passwords work, but key-based login is more secure and saves typing. On your **Windows** host:

```powershell
ssh-keygen -t ed25519          # press Enter through the prompts
ssh-copy-id student@<VM-IP>    # if ssh-copy-id is unavailable, see note below
```

If `ssh-copy-id` isn't available on Windows, paste your key manually — on the VM:

```bash
$ mkdir -p ~/.ssh && chmod 700 ~/.ssh
$ nano ~/.ssh/authorized_keys
# paste the contents of C:\Users\<you>\.ssh\id_ed25519.pub, save, exit
$ chmod 600 ~/.ssh/authorized_keys
```

Now `ssh student@<VM-IP>` logs in without a password.

> We keep password login enabled for the course. On Day 3 (security hardening) we discuss disabling password login and root SSH entirely.

---

## Part C — The Firewall (UFW) — Day 1 of the firewall thread

The firewall controls which network ports are reachable. Ubuntu ships **UFW** (Uncomplicated Firewall). Today we only need one rule: **allow SSH**. Apache (80/443) and MySQL (3306) come on later days.

### C1. The golden rule

> ⚠️ **Allow SSH *before* you enable the firewall.** If you enable UFW first, its default is to block all incoming traffic — including your SSH session — and you lock yourself out. Order matters.

### C2. Check current state

```bash
$ sudo ufw status
Status: inactive
```

### C3. Allow SSH first

```bash
$ sudo ufw allow OpenSSH
```

`OpenSSH` is a named profile UFW already knows (it maps to TCP port 22). Equivalent explicit form:

```bash
$ sudo ufw allow 22/tcp
```

### C4. Now enable the firewall

```bash
$ sudo ufw enable
```

It warns *"Command may disrupt existing ssh connections"* → type **`y`**. Because we allowed SSH first, your session survives.

### C5. Verify

```bash
$ sudo ufw status verbose
```

Expected:

```
Status: active
...
To                         Action      From
--                         ------      ----
22/tcp (OpenSSH)           ALLOW IN    Anywhere
22/tcp (OpenSSH (v6))      ALLOW IN    Anywhere (v6)
```

📌 **Checkpoint:** UFW is **active** and lists **OpenSSH / 22 ALLOW**. Prove it survives a reboot:

```bash
$ sudo reboot
```

Wait ~30 seconds, then SSH back in from Windows. If you reconnect, the firewall is correctly configured.

### C6. Useful UFW commands (reference)

```bash
$ sudo ufw status numbered     # list rules with numbers
$ sudo ufw delete <number>     # remove a rule by its number
$ sudo ufw default deny incoming    # default: block inbound (already the default)
$ sudo ufw default allow outgoing   # default: allow outbound
$ sudo ufw disable             # turn the firewall off entirely
```

> **The firewall thread continues:**
> - **Day 2 AM** — allow Apache: `sudo ufw allow 'Apache Full'` (ports 80/443)
> - **Day 2 PM** — allow MySQL from the source VM only: `sudo ufw allow from <source-IP> to any port 3306`
> - **Day 3** — consolidated hardening review

---

## Part D — Wrap up Day 1: take a snapshot

Now that both VMs are installed, updated, SSH-accessible, and firewalled, we save a clean restore point.

For **each** VM, in VirtualBox Manager:

1. Select the VM.
2. Open the **Snapshots** view (menu / list icon top-right of the VM entry).
3. Click **Take** (camera icon).
4. Name it: **`day1-clean`**
5. Description: `Ubuntu installed, updated, SSH + UFW configured`
6. **OK**.

> **Why snapshot?** If anything breaks on Day 2/3, we can roll back to this exact clean state in seconds instead of reinstalling.

📌 **Checkpoint:** Both VMs show a snapshot named `day1-clean`.

---

## Day 1 final checklist (both VMs)

- [ ] `systemctl status ssh` → active & enabled
- [ ] Can SSH in from Windows PowerShell
- [ ] (Optional) key-based SSH login works
- [ ] `sudo ufw status` → active, OpenSSH allowed
- [ ] Firewall survives a reboot (reconnected after `sudo reboot`)
- [ ] System fully updated
- [ ] `day1-clean` snapshot taken

If every box is ticked on **both** `ubuntu-source` and `ubuntu-target`, **Day 1 is complete.** 🎯

Tomorrow (Day 2) we build the LAMP stack and a working PHP app on the target, then begin the MySQL migration.
