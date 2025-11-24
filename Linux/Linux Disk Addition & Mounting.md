# Linux Disk Addition & Mounting Documentation

## 1. Overview

This document explains how to add a new disk to a Linux server, partition it, format it, mount it, and persist the mount across reboots.

---

## 2. Identify the New Disk

Use the following command to list available disks:

```bash
lsblk
```

This shows devices like `/dev/xvda`, `/dev/xvdf`, etc.

---

## 3. Partition the Disk Using `fdisk`

Run:

```bash
sudo fdisk /dev/xvdf
```

Inside `fdisk`, you typically:

* Press `n` → create new partition
* Select `p` for primary
* Accept defaults or specify start/end sectors
* Press `w` to write changes

This creates something like `/dev/xvdf1`.

---

## 4. Format the Partition Using `mkfs.ext4`

```bash
sudo mkfs.ext4 /dev/xvdf1
```

This applies the EXT4 filesystem to the partition.

---

## 5. Create a Mount Point

```bash
sudo mkdir /data
```

This folder will serve as the location where the disk's filesystem becomes accessible.

---

## 6. Mount the Disk

```bash
sudo mount /dev/xvdf1 /data
```

This attaches the filesystem on `/dev/xvdf1` to `/data`. Now all files stored inside `/data` go to the new disk.

---

## 7. Verify Mount

```bash
lsblk
```

You should see `/data` in the MOUNTPOINT column.

---

## 8. Make the Mount Persistent Across Reboots

1. Get the UUID of the partition:

```bash
sudo blkid /dev/xvdf1
```

2. Edit `/etc/fstab`:

```bash
sudo nano /etc/fstab
```

3. Add an entry:

```
UUID=<your-uuid>   /data   ext4   defaults,nofail   0   2
```

This ensures the disk mounts automatically on every reboot.

---

## 9. Resizing a Disk Using `growpart`

If your cloud provider extends the disk size:

```bash
sudo growpart /dev/xvdf 1
sudo resize2fs /dev/xvdf1
```

This increases the partition and filesystem size.

---

## 10. Summary of Commands

* `fdisk` → Create partitions
* `mkfs.ext4` → Format partition with EXT4
* `lsblk` → View block devices
* `blkid` → Get UUID
* `mount` → Mount the formatted partition
* `growpart` → Extend a partition when disk size is increased

---

## 11. Key Concepts

### Mount Point

A normal empty directory (e.g., `/data`) where a disk is attached.

### UUID

A unique identifier assigned to partitions. Used in `/etc/fstab` for persistent mounts.

### Persistence Behavior

If you do not update `/etc/fstab`, the mount point folder remains but the disk will not attach after reboot. Data remains on the disk but is not accessible until you manually remount it.

---

