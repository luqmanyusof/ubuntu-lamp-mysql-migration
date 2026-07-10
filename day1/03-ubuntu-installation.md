# 03 — Install Ubuntu Server

**Goal:** Install Ubuntu Server onto **both** VMs, with OpenSSH enabled, so each boots to a working, remotely-accessible Linux system.

**Time:** ~30 minutes per VM (much of it unattended)

> Do the whole lab on **`ubuntu-app`** first. Then repeat every step on **`ubuntu-db`**, changing only the hostname (see section 9).

---

## 1. Start the installer

1. In VirtualBox Manager, select **`ubuntu-app`**.
2. Click **Start** (green arrow).
3. A console window opens and boots from the ISO.
4. At the GRUB menu, choose **Try or Install Ubuntu Server** (or just wait — it auto-selects).

> ⚠️ Once you click into the VM window, your mouse/keyboard are "captured" by the VM. Press the **Host key** (shown bottom-right of the window, usually **Right Ctrl**) to release them back to Windows.

📌 **Checkpoint:** After a minute of scrolling text you reach a blue-and-white text menu — the Ubuntu installer.

---

## 2. Language and keyboard

- **Language:** `English` → Enter.
- **Keyboard:** accept the default (`English (US)`) unless yours differs.

> Navigate the installer with **arrow keys**, **Tab**, **Space** (to toggle), and **Enter**. The mouse is not used here.

---

## 3. Installation type

- Choose **Ubuntu Server** (the standard install), **not** "minimized".
- Continue.

---

## 4. Network

The installer auto-detects the bridged adapter and requests an IP via DHCP. You should see a line like:

```
eth0 / enp0s3   DHCPv4   192.168.1.50/24
```

- **Write down this IP address** — you need it to SSH in later.
- Continue.

📌 **Checkpoint:** An IPv4 address is shown (not blank, not `169.254.x.x`). If it's blank, go back to VM **Settings → Network** and confirm Bridged Adapter is set correctly (lab 01, section 5).

> **Tip:** DHCP addresses can change on reboot. That's fine for the course. On Day 3 we discuss setting a static IP for production.

---

## 5. Proxy and mirror

- **Proxy address:** leave **blank** → Continue.
- **Mirror:** accept the default → Continue.

---

## 6. Storage / disk

- Choose **Use an entire disk**.
- Select the 20 GB virtual disk.
- Leave **Set up this disk as an LVM group** ticked (default).
- Continue → review the summary → **Continue** again.
- A confirmation warns the disk will be erased → **Continue**. (This is the *virtual* disk only, not your Windows disk.)

📌 **Checkpoint:** Installation summary shows one ~20 GB disk being formatted.

---

## 7. Profile setup (your user account)

Fill in carefully — you will type these often:

| Field | Value for this course |
|-------|-----------------------|
| Your name | `Trainee` (anything) |
| Your server's name (hostname) | `ubuntu-app` |
| Pick a username | `student` |
| Choose a password | something you'll remember |
| Confirm password | same |

> ⚠️ **Remember this username and password.** There is no "reset" button — if you forget it, you reinstall.

---

## 8. SSH — the most important screen

On the **SSH Setup** screen:

- ✅ **Tick "Install OpenSSH server"** (press Space to select it).
- Leave "Import SSH identity" as **No**.

This single checkbox is what makes the VM reachable over SSH. Do not skip it.

📌 **Checkpoint:** "Install OpenSSH server" shows `[X]`.

---

## 9. Featured server snaps

- Do **not** select any (LAMP, Docker, etc.). We install those manually later.
- Continue.

---

## 10. Install and reboot

- The installer copies files and downloads updates. This takes several minutes.
- When you see **Install complete!** and **Reboot Now**, select **Reboot Now**.
- If it says *"Please remove the installation medium"* and hangs, just press **Enter**. (VirtualBox usually ejects the ISO automatically; if not, VM **Devices → Optical Drives → Remove disk from virtual drive**, then reboot.)

📌 **Checkpoint:** The VM reboots and lands on a text **login prompt**:

```
ubuntu-app login:
```

---

## 11. First login

At the prompt:

```
ubuntu-app login: student
Password: (type your password — nothing shows as you type, that's normal)
```

You should land at a shell prompt:

```
student@ubuntu-app:~$
```

Run a first command to confirm it's alive and note the IP again:

```bash
$ ip a
```

📌 **Checkpoint:** You are logged in and `ip a` shows your VM's IP address (the `inet 192.168.x.x` line under the main adapter).

---

## 12. Now do it all again for `ubuntu-db`

Repeat sections 1–11 on the **`ubuntu-db`** VM, with **one change**:

- On the profile screen (section 7), set the **hostname to `ubuntu-db`**.

Everything else is identical. Use the same username `student` on both — it keeps later commands consistent.

📌 **Checkpoint:** You now have two VMs, both at a login prompt. **Write down both IPs — you'll wire them together tomorrow:**
- `ubuntu-app` — IP: __________
- `ubuntu-db` — IP: __________

---

## Done

Both servers run Ubuntu with SSH installed. Next: **`04-linux-admin-essentials.md`** to learn the commands you'll use for the rest of the course.
