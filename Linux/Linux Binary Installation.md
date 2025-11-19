---

## **1. What decides where a program is installed?**

A program’s location in Linux depends on:

1. **Who installs it**
2. **How it is installed (apt vs manual)**
3. ** whether it is a normal program or an admin (system) tool**

---

## **2. System Directories & Their Purpose**

| Directory           | Purpose                                   | Who can run binaries inside |
| ------------------- | ----------------------------------------- | --------------------------- |
| **/usr/bin**        | Normal programs available to all users    | Everyone                    |
| **/usr/sbin**       | System administration tools               | Usually only root           |
| **/usr/local/bin**  | Manually installed programs for all users | Everyone                    |
| **/usr/local/sbin** | Manually installed admin tools            | Root                        |
| **~/.local/bin**    | Programs installed by a normal user       | Only that user              |

---

# 📌 **3. When ROOT installs using APT**

### Command:

```
sudo apt install <package>
```

### Rules:

* Binaries go to **/usr/bin** if they are normal user programs
* Binaries go to **/usr/sbin** if they require admin rights

### Examples:

### ✔ **nginx (installed by root using apt)**

* Installs main server binary → `/usr/sbin/nginx`
* Reason: this is a system service
* Only root can start/stop nginx

### ✔ **net-tools (installed by root using apt)**

Installs a mix of tools:

| Tool       | Location             | Reason                    |
| ---------- | -------------------- | ------------------------- |
| `ifconfig` | `/usr/sbin/ifconfig` | admin-only network config |
| `route`    | `/usr/sbin/route`    | admin-only network config |
| `hostname` | `/usr/bin/hostname`  | safe for all users        |
| `netstat`  | `/usr/bin/netstat`   | view-only tool            |

APT decides the location based on the tool’s purpose — **not based on who installs it**.

---

# 📌 **4. When ROOT installs manually (download link / script)**

### Example:

Installing AWS CLI manually:

```
sudo ./install
```

### Binary usually goes to:

* **/usr/local/bin**

### Why?

* `/usr/local` is for software **not managed by the package manager**
* Keeps manual installations separate from apt packages

### Example Result:

```
/usr/local/bin/aws
```

---

# 📌 **5. When a NORMAL USER installs manually**

User (no sudo) installs something like jq:

```
wget jq
chmod +x jq
mv jq ~/.local/bin/
```

### Binary goes to:

* **~/.local/bin**

### Why?

* Normal users do **not** have permission to write to `/usr/bin` or `/usr/sbin`

### Who can run it?

* Only that user

---

# 📌 **6. Quick Summary Table**

| Who installs?   | Method                 | Where binary goes?                  | Example          |
| --------------- | ---------------------- | ----------------------------------- | ---------------- |
| **root**        | apt                    | `/usr/bin`, `/usr/sbin`             | nginx, net-tools |
| **root**        | manual installer       | `/usr/local/bin`, `/usr/local/sbin` | aws, terraform   |
| **normal user** | manual install         | `~/.local/bin`                      | jq               |
| **root**        | copies binary manually | Anywhere root chooses               | custom scripts   |

---

# 📌 **7. Difference Between bin and sbin (simple)**

| Directory                        | Meaning |
| -------------------------------- | ------- |
| **bin** = user programs          |         |
| **sbin** = system admin programs |         |

Not related to who installs.
It’s related to what the program **does**.

Example:

* `ifconfig` goes to **/usr/sbin** because it changes network settings
* `curl` goes to **/usr/bin** because any user can run it

---

# 📌 **8. Visual Diagram**

```
                 ┌───────────── APT ─────────────┐
                 │                                │
            Normal programs                 Admin/system tools
                 │                                │
          /usr/bin                        /usr/sbin
                 │                                │
                 └────────────────────────────────┘

                 ┌──────────── Manual ────────────┐
                 │                                │
            installed by root               installed by user
                 │                                │
       /usr/local/bin or sbin              ~/.local/bin
```

---