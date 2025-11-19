Below is a **clean, complete, beginner-friendly Markdown guide** explaining **all correct ways to execute a `.sh` script on Linux**, including permissions, paths, and when to use each method.

You can **copy-paste** this into your notes.

---

## 📘 **How to Execute a `.sh` File in Linux (Full Guide)**

This guide explains:

* How to set correct permissions
* How to execute a script from different directories
* Difference between `./script.sh`, `/root/script.sh`, `bash script.sh`, etc.
* Common errors and how to fix them

---

## 🧩 **1. Make the Script Executable**

Before you can run a script directly, you must give it **execute permission**.

```bash
chmod +x script.sh
```

✔ This sets execute (x) permission for the script.

Check permissions:

```bash
ls -l script.sh
```

You should see:

```
-rwxr-xr-x
```

---

## 🧩 **2. Executing a Script (All Possible Ways)**

Below are **all valid methods** and **when** to use each.

---

### ✅ **A. Execute using relative path (`./script.sh`)**

Use this when:

* You are **in the same directory** as the script
* Script is executable

Example:

```bash
./script.sh
```

Why `./`?

Because Linux **does NOT search the current folder automatically**.
`./` means “run the script in this folder.”

---

### ✅ **B. Execute using full absolute path**

Useful when:

* You are *not* inside the folder
* Script is located in a different directory

Example (script is in `/root`):

```bash
/root/script.sh
```

or if your script is in `/home/ubuntu/scripts/test.sh`:

```bash
/home/ubuntu/scripts/test.sh
```

This works **only if** the script has execute permission.

---

## ✅ **C. Execute using `bash script.sh` (NO execute permission required)**

Use this when:

* Script is not executable
* Script came from Windows (CRLF issues)
* You don’t want to change permissions
* Permissions are restricted by system

Example:

```bash
bash script.sh
```

This works even if script is:

* Not executable (`-rw-r--r--`)
* Stored anywhere
* Called without `./`

Useful for troubleshooting.

---

## ✅ **D. Execute using `sh script.sh`**

Same idea as `bash`, but uses `/bin/sh`.

```bash
sh script.sh
```

Use when:

* Script is POSIX-compatible
* You don’t care about `bash`-specific features
* `/bin/bash` is not installed

---

## 🧩 **3. Running Script From Another Directory**

Example:

Your script is in `/root/nginxscript.sh`, and you are in `/home/ubuntu`.

Three valid ways:

### **1️⃣ Full path**

```bash
sudo /root/nginxscript.sh
```

### **2️⃣ Using bash**

```bash
sudo bash /root/nginxscript.sh
```

### **3️⃣ Move into the folder and run**

```bash
cd /root
sudo ./nginxscript.sh
```

---

## 🧩 **4. When each method should be used (Summary Table)**

| Method                 | When to Use                              | Needs execute permission? |
| ---------------------- | ---------------------------------------- | ------------------------- |
| `./script.sh`          | You are in same directory                | ✅ Yes                     |
| `/full/path/script.sh` | You are in any directory                 | ✅ Yes                     |
| `bash script.sh`       | Permission issues, Windows CRLF, testing | ❌ No                      |
| `sh script.sh`         | Simple POSIX shell scripts               | ❌ No                      |

---

## 🧩 **5. Common Errors and Fixes**

### ❌ *Error:* `command not found` when running `./script.sh`

**Fix:** File is not executable

```bash
chmod +x script.sh
```

---

### ❌ *Error:* `./script.sh: bad interpreter: /bin/bash^M`

**Fix:** Windows CRLF line endings

```bash
apt install dos2unix -y
dos2unix script.sh
```

---

### ❌ *Error:* `Permission denied`

Fix using root:

```bash
sudo ./script.sh
```

---

## 🧩 **6. Recommended Best Practice**

### ✔ Always add a shebang at top of the script:

```bash
#!/bin/bash
```

This tells Linux which shell to use.

---

## 🧩 **7. Example Script Execution (From /root)**

Your script `/root/nginxscript.sh`

### Option 1 — Most common

```bash
sudo /root/nginxscript.sh
```

### Option 2 — Enter folder, run with relative path:

```bash
cd /root
sudo ./nginxscript.sh
```

### Option 3 — Using bash:

```bash
sudo bash /root/nginxscript.sh
```

---

## ✅ **Copy-Ready Final Summary**

```
# Give execute permission
chmod +x script.sh

# Run from same folder
./script.sh

# Run from any folder (absolute path)
/root/script.sh

# Run without execute permission
bash script.sh
sh script.sh

# Fix Windows CRLF
dos2unix script.sh

# Best practice: Shebang
#!/bin/bash
```

---