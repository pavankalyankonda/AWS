Here is a clean, simple explanation of every field in your /etc/fstab entry:

Your example:

UUID=abcd-1234-efgh-5678   /datavolume   ext4   defaults,nofail   0   2


The spaces/tabs between fields DO matter → each field must be separated by at least one space or a tab.
Let’s break down every column:

✅ fstab Fields Explained (6 fields)
1️⃣ Device / Identifier
UUID=abcd-1234-efgh-5678


This tells Linux which disk/partition to mount.
We use UUID because:

It is unique

It never changes (device names like /dev/xvdf can change on reboot)

Safer for permanent mounts

2️⃣ Mount Point
/datavolume


This is the directory where the disk will appear.

If the folder doesn’t exist → the mount will fail.

This should be an empty directory.

3️⃣ Filesystem Type
ext4


Defines the filesystem used on that partition.

Examples:

ext4

xfs

ntfs

vfat

This must match whatever you created with mkfs.

4️⃣ Mount Options
defaults,nofail


This is the most important and confusing field.
You can give multiple comma-separated options.

⭐ Common options:
Option	Meaning
defaults	Standard recommended settings (rw, suid, dev, exec, auto, nouser, async)
nofail	Boot will continue even if this disk is missing
auto	Automatically mount at boot
noauto	Do NOT mount automatically
rw	Mount read-write
ro	Read-only
uid=1000	Set owner UID (useful for NTFS/vfat)
noatime	Improve performance by not updating file access timestamp
user	Allow normal users to mount

For you:

defaults → normal behavior

nofail → important for AWS; system still boots even if EBS volume is detached

5️⃣ Dump (Backup) value
0


Legacy option used by old dump backup tool.

Use:

0 → don’t back up

1 → do backup

➡️ Modern systems almost always use 0.

6️⃣ fsck (Filesystem Check Order)
2


Tells Linux in which order to run filesystem checks on boot.

Values:

0 → do NOT check

1 → check root filesystem first (/)

2 → check other filesystems after root

For your data disk:
2 is correct → filesystem will be checked safely on boot.

⭐ Correct fstab syntax with spacing

Yes — spaces or tabs are enough between fields:

UUID=abcd-1234-efgh-5678 /datavolume ext4 defaults,nofail 0 2


You can use multiple spaces; fstab doesn’t care as long as:

At least one space or a tab separates fields

No commas between fields (only inside field 4)

No trailing spaces at the end of line

🔥 Summary Table
Field	Meaning
1	Device (UUID, /dev/sdX, label)
2	Mount point directory
3	Filesystem type
4	Mount options (comma-separated)
5	dump backup flag
6	fsck order (0/1/2)