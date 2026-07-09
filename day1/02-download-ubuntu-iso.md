# 02 — Download & Verify the Ubuntu Server ISO

**Goal:** Download the Ubuntu Server installer (an `.iso` file) and verify it is genuine and undamaged before we install it.

**Time:** ~20 minutes (mostly download time)

---

## 1. Why Ubuntu Server (not Desktop)?

We install **Ubuntu Server**, not Ubuntu Desktop:

- No graphical desktop → lighter, faster, closer to a real production server.
- You manage it entirely from the **command line** and over **SSH** — exactly the skills this course teaches.

We use the current **LTS** (Long Term Support) release. LTS versions get 5 years of updates and are what companies run in production.

> This lab uses **Ubuntu Server 24.04 LTS**. If a newer LTS is out when you take the course, use that and adjust the version number in the filenames.

---

## 2. Download the ISO

1. Go to <https://ubuntu.com/download/server>
2. Choose **Manual server installation** / **Download Ubuntu Server**.
3. Download the file, e.g. `ubuntu-24.04.x-live-server-amd64.iso` (~2–3 GB).
4. Save it somewhere easy to find, e.g. `C:\Users\<you>\Downloads\`.

> ⚠️ Make sure the filename contains **`server`** and **`amd64`**. If it says *desktop*, you downloaded the wrong image.

📌 **Checkpoint:** The `.iso` file is in your Downloads folder and is roughly 2–3 GB in size.

---

## 3. Verify the download (integrity check)

A large download can arrive corrupted, or from a tampered mirror. We confirm the file is exactly what Ubuntu published by comparing its **SHA256 checksum**.

### 3a. Get the official checksum

On the same Ubuntu download page, find the **SHA256SUMS** link (near the download button, sometimes under "verify your download"). Open it and copy the long hash that matches your exact `.iso` filename. It looks like:

```
a1b2c3d4e5f6...  *ubuntu-24.04.x-live-server-amd64.iso
```

### 3b. Compute the checksum on Windows

Open **PowerShell**, then run (adjust the path/filename to yours):

```powershell
Get-FileHash "$HOME\Downloads\ubuntu-24.04.x-live-server-amd64.iso" -Algorithm SHA256
```

This prints a hash after a few seconds.

### 3c. Compare

The hash from PowerShell must **exactly match** the one from Ubuntu's SHA256SUMS (case-insensitive).

- ✅ **Match** → the file is genuine and intact. Continue.
- ❌ **No match** → the download is corrupt or wrong. **Delete it and download again.**

📌 **Checkpoint:** Your computed SHA256 equals Ubuntu's published SHA256.

> **Trainer note (Luqman):** This step feels tedious to beginners, but it's a genuine security habit — a real migration engineer never installs an unverified image on a database server. Do it once together, slowly, so they understand *why*.

---

## 4. Attach the ISO to both VMs

Now we plug the installer "CD" into each virtual machine.

For **each** VM (`ubuntu-source` and `ubuntu-target`):

1. Select the VM → **Settings → Storage**.
2. Under the **Controller: IDE** (or SATA), click the **Empty** optical drive (the CD icon).
3. On the right, click the small **blue disk icon → Choose a disk file…**.
4. Select your verified `ubuntu-24.04.x-live-server-amd64.iso`.
5. Click **OK**.

📌 **Checkpoint:** Under Storage, the optical drive now shows the Ubuntu ISO filename instead of "Empty".

---

## Done

Both VMs are loaded with the installer. Next: **`03-ubuntu-installation.md`** — install Ubuntu Server on both machines.
