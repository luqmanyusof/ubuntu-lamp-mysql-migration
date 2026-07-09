# 01 — VirtualBox Setup

**Goal:** Install VirtualBox on your Windows host and create **two empty virtual machines** — `ubuntu-source` and `ubuntu-target` — ready to receive Ubuntu Server.

**Time:** ~30 minutes

---

## 1. What is VirtualBox?

VirtualBox is a free tool from Oracle that lets your Windows laptop run other computers *inside* it. Each of those pretend computers is a **Virtual Machine (VM)**. We will run two Ubuntu Linux VMs on your one Windows machine.

- **Host** = your real Windows laptop.
- **Guest** = each Ubuntu VM running inside VirtualBox.

---

## 2. Check your host has enough resources

Each VM will use 2 GB RAM and 1 CPU. You are running **two** of them plus Windows. Check you have:

- **RAM:** 8 GB minimum (16 GB comfortable)
- **Disk:** 40 GB free
- **CPU virtualization enabled** in BIOS (usually on by default)

📌 **Checkpoint — is virtualization on?**
Open Windows **Task Manager → Performance → CPU**. Look for **Virtualization: Enabled**. If it says *Disabled*, you must enable **Intel VT-x** or **AMD-V** in your laptop's BIOS/UEFI before continuing. Ask the trainer if unsure.

---

## 3. Install VirtualBox

1. Go to <https://www.virtualbox.org/wiki/Downloads>
2. Under **VirtualBox platform packages**, click **Windows hosts**.
3. Run the downloaded installer (e.g. `VirtualBox-7.x-Win.exe`).
4. Accept all defaults. Click **Yes** if it warns about resetting your network briefly.
5. Finish and launch **Oracle VirtualBox**.

> ⚠️ **Watch out:** During install your Wi-Fi may blink off for a second — that's normal, it's installing the virtual network driver.

📌 **Checkpoint:** VirtualBox Manager window opens and shows an empty machine list on the left.

---

## 4. Create the first VM — `ubuntu-source`

We create the VM shell now; we install Ubuntu into it in lab 03.

1. Click **New** (blue star icon).
2. Fill in the **Name and operating system** page:
   - **Name:** `ubuntu-source`
   - **ISO Image:** leave as `<not selected>` for now
   - **Type:** `Linux`
   - **Version:** `Ubuntu (64-bit)`
   - ⚠️ Leave **"Skip Unattended Installation"** ticked. We want to install Ubuntu manually so you learn each screen.
3. Click **Next**.
4. **Hardware** page:
   - **Base Memory:** `2048 MB`
   - **Processors:** `1 CPU` (2 is fine if your host has ≥ 8 cores)
5. Click **Next**.
6. **Virtual Hard disk** page:
   - **Create a Virtual Hard Disk Now**
   - **Disk Size:** `20 GB`
   - Leave *Pre-allocate Full Size* unticked (dynamic disk grows as needed).
7. Click **Next → Finish**.

📌 **Checkpoint:** `ubuntu-source` appears in the machine list, marked **Powered Off**.

---

## 5. Configure the network (important)

We want each VM to (a) reach the internet, and (b) be reachable by SSH from your Windows host. The simplest reliable option in a classroom is a **Bridged Adapter**.

1. Select `ubuntu-source` → click **Settings** (gear icon).
2. Go to **Network → Adapter 1**.
3. Set:
   - **Enable Network Adapter:** ✅ ticked
   - **Attached to:** `Bridged Adapter`
   - **Name:** choose your active host network card (your Wi-Fi or Ethernet adapter)
4. Click **OK**.

> **Why bridged?** It puts the VM on the *same network as your laptop*, so it gets its own IP address (like `192.168.1.50`) that you can SSH to directly. Easy to understand and easy to reach.

> **Trainer note (Luqman):** If the classroom network blocks bridged mode (some corporate Wi-Fi does), fall back to **NAT + port forwarding**: keep Adapter 1 on NAT, then add a forward rule Host `2222` → Guest `22`. Tell trainees which mode we are using so their SSH commands match. This lab assumes bridged.

📌 **Checkpoint:** Network shows **Bridged Adapter** attached to a real adapter name (not "Not selected").

---

## 6. Create the second VM — `ubuntu-target`

Repeat **sections 4 and 5** exactly, but name it:

- **Name:** `ubuntu-target`

Same settings: 2048 MB RAM, 1 CPU, 20 GB disk, Bridged network.

📌 **Checkpoint:** Your machine list now shows **two** powered-off VMs:

```
ubuntu-source   (Powered Off)
ubuntu-target   (Powered Off)
```

---

## Done

Both VM shells exist but are empty. Next: **`02-download-ubuntu-iso.md`** to get the Ubuntu installer, then **`03`** to install it into these VMs.
