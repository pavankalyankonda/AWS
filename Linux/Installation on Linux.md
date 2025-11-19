---

# 🔥 Why AWS CLI installed in `/usr/local/bin`, not `/usr/sbin`

### 👉 Because you **did NOT install AWS CLI using apt**.

You used the **AWS zipped installer**, which installs software in:

```
/usr/local/aws-cli/       (the full AWS program)
/usr/local/bin/aws        (symlink)
```

This is the correct location for **software installed manually**, NOT by the system package manager.

### Meanwhile:

* `nginx` was installed using **apt**, so its binary was placed in system-managed paths:

```
/usr/sbin/nginx
/usr/bin/<other tools>
```

---

##  Key Concept: There are two types of installations in Linux

## **1️⃣ System-managed installation → using apt**

Example:

```
sudo apt install nginx
sudo apt install net-tools
sudo apt install jq
```

APT installs files into:

| Path          | What goes here                            |
| ------------- | ----------------------------------------- |
| **/usr/bin**  | Programs for normal users                 |
| **/usr/sbin** | Programs for system administrators (root) |
| **/usr/lib**  | Libraries                                 |
| **/etc**      | Config files                              |
| **/var**      | Logs, runtime files                       |

APT also:

* tracks versions
* handles upgrades & removal
* maintains consistency
* installs dependencies

### Example: Nginx binary location

```
/usr/sbin/nginx
```

---

## **2️⃣ Manually installed applications → downloaded via script or link**

Example:

```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
```

**Manually installed software does NOT use apt**
→ So it must NOT go into system-managed directories (`/usr/bin` or `/usr/sbin`).

Instead, Linux follows FHS (Filesystem Hierarchy Standard):

### Manually-installed software goes into:

```
/usr/local/bin     ← executables
/usr/local/lib     ← libraries
/usr/local/share   ← shared files
```

AWS CLI v2 follows this standard.

### So AWS CLI goes here:

```
/usr/local/aws-cli/               ← main directory
/usr/local/bin/aws                ← symlink to executable
```

This avoids conflicts with apt-managed software.

---

## So what is inside `/usr/local/bin` and `/usr/bin`?

### **/usr/bin**

Programs installed and **managed by the OS package manager (apt)**
Examples:

* ping
* ls
* jq
* curl

### **/usr/sbin**

System administration tools
Examples:

* nginx
* useradd
* ufw

### **/usr/local/bin**

Programs installed **manually by the user**, not by apt.
Examples:

* aws (AWS CLI v2)
* terraform (if installed manually)
* kubectl (if installed manually)

---

## 🧱 Are these binaries? Yes.

Every program in:

```
/usr/bin
/usr/sbin
/usr/local/bin
```

is a **binary executable**.

Example:

```bash
file /usr/local/bin/aws
```

Will return something like:

```
ELF 64-bit LSB executable, x86-64
```

That means it’s a COMPiled program (a binary), not a script.

---

## How Linux decides where software gets placed

### Installation method | Install location

| Method                | Example            | Where binaries go       |
| --------------------- | ------------------ | ----------------------- |
| **apt install**       | nginx              | `/usr/bin`, `/usr/sbin` |
| **Manual installer**  | AWS CLI zip        | `/usr/local/bin`        |
| **Script downloaded** | kubectl, terraform | `/usr/local/bin`        |
| **Compiled manually** | make install       | `/usr/local/bin`        |
| **Container apps**    | Docker, snap apps  | app-specific folders    |

APT never touches `/usr/local/bin`.
Manual installers never touch `/usr/bin` or `/usr/sbin`.

---

## 🔥 Summary — Why AWS CLI is in `/usr/local/bin`?

Because:

* You **manually installed** it
* It is **not** managed by apt
* According to Linux standards, manual tools go into `/usr/local/*`
* To avoid conflict with OS-managed programs

Meanwhile:

* nginx was installed using apt, so it goes into `/usr/sbin`

---