---
#practice this later


# 📘 **tmux Basic Documentation (Linux)**

---

# ✅ **1. Start tmux**

Start a new tmux session:

```bash
tmux
```

This opens a default session named `0`.

---

# ✅ **2. Create a Named Session**

```bash
tmux new -s mysession
```

This is useful when you want to run multiple sessions with names.

---

# ✅ **3. List All Sessions**

```bash
tmux ls
```

---

# ✅ **4. Attach to a Session**

```bash
tmux attach -t mysession
```

If you only have one session:

```bash
tmux attach
```

---

# ⚡ **5. Inside tmux — Important Keys**

All tmux commands use:

```
Ctrl + b
```

Then you press another key.

---

# 🔲 **6. Split the tmux Window**

### **Horizontal Split** (top & bottom)

```
Ctrl + b  then  %
```

### **Vertical Split** (left & right)

```
Ctrl + b  then  "
```

*(mnemonic: “%” looks like a split, “quotes” split vertically)*

---

# 🔁 **7. Switch Between Panes**

```
Ctrl + b  then  arrow keys
```

---

# 🪟 **8. Create New Window in Same Session**

```
Ctrl + b  then  c
```

---

# 🔄 **9. Switch Between Windows**

```
Ctrl + b  then  n    # next window
Ctrl + b  then  p    # previous window
Ctrl + b  then  0-9  # jump to window number
```

---

# 🚪 **10. Detach from a Session (Keep it Running)**

```
Ctrl + b  then  d
```

You return to your normal shell but everything in tmux keeps running.

---

# 🔥 **11. Kill a Particular Session**

```bash
tmux kill-session -t mysession
```

Or by number:

```bash
tmux kill-session -t 2
```

---

# 💣 **12. Kill ALL tmux Sessions**

```bash
tmux kill-server
```

(Warning: This closes *all* sessions and panes.)

---

# 🚀 Small Example Workflow

```bash
tmux new -s project
```

Inside tmux:

```
Ctrl+b  "      # split vertically
Ctrl+b  %      # split horizontally
Ctrl+b  d      # detach
```

Later:

```bash
tmux attach -t project
```

---
