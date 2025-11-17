Here is your **complete Git notes + cheat sheet** in **clean Markdown format** with explanations + commands.
You can **copy everything directly**.

---

# 📘 **GIT CHEAT SHEET (Beginner-Friendly, With Explanations)**

*Markdown format — fully copy-ready*

---

# #️⃣ **1. Configure Git (One-time setup)**

### **What it does:**

Sets who you are for all commits.

```
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

---

# #️⃣ **2. Create a Git repository**

### **What it does:**

Turns a folder into a Git-enabled folder.

```
git init
```

---

# #️⃣ **3. Check repository status**

### **What it does:**

Shows changed, staged, and untracked files.

```
git status
```

---

# #️⃣ **4. Add files to staging area**

### **What it does:**

Moves changes into the “ready to commit” area.

```
git add file.txt
git add .        # add everything
```

---

# #️⃣ **5. Commit changes**

### **What it does:**

Creates a permanent snapshot.

```
git commit -m "message"
```

---

# #️⃣ **6. Connect local repo to GitHub**

### **What it does:**

Links your local folder with GitHub’s repository.

```
git remote add origin git@github.com:username/repo.git
```

Check connection:

```
git remote -v
```

---

# #️⃣ **7. Push code to GitHub**

### **What it does:**

Uploads your local commits to GitHub.

```
git push -u origin main
```

Future pushes:

```
git push
```

---

# #️⃣ **8. Branching Basics**

## ✳️ Create a new branch

### **Switch method (recommended):**

```
git switch -c newbranch
```

### **Checkout method (old but still works):**

```
git checkout -b newbranch
```

---

## ✳️ Switch between branches

### **Recommended method:**

```
git switch branchname
```

### **Old method:**

```
git checkout branchname
```

---

## ✳️ List all branches

```
git branch
```

---

# #️⃣ **9. Delete a branch**

### **Delete local branch**

```
git branch -d branchname
```

Force delete:

```
git branch -D branchname
```

### **Delete remote branch (GitHub)**

```
git push origin --delete branchname
```

⚠️ Cannot delete the **default branch** until you change it in GitHub settings.

---

# #️⃣ **10. Pull latest changes**

### **What it does:**

Downloads and merges the latest code from GitHub.

```
git pull
```

---

# #️⃣ **11. View commit history**

```
git log
git log --oneline
```

---

# #️⃣ **12. Restore files (modern safe method)**

### **What it does:**

Undo changes without switching branches.

Restore a modified file:

```
git restore file.txt
```

Restore everything:

```
git restore .
```

---

# #️⃣ **13. Important SSH key concepts**

## **SSH key = secure login method**

* **Private key** → stays on your computer
* **Public key** → added to GitHub

Generate new key:

```
ssh-keygen -t ed25519 -C "your@email.com"
```

List keys:

```
ls ~/.ssh
```

Copy public key:

```
cat ~/.ssh/id_ed25519.pub
```

Add the key to GitHub → Settings → SSH and GPG Keys → New SSH Key.

---

# #️⃣ **14. Fix “Permission denied (publickey)”**

### **Check if agent has your key:**

```
ssh-add -l
```

Add it if missing:

```
ssh-add ~/.ssh/id_ed25519
```

Test GitHub connection:

```
ssh -T git@github.com
```

---

# #️⃣ **15. Rename the default branch**

Rename local:

```
git branch -m master
```

Push the new name:

```
git push origin master
```

Change GitHub default branch:
GitHub → Repo Settings → Branches → Change default → master

Delete old branch:

```
git push origin --delete main
```

---

# 📦 **SUMMARY TABLE (Quick Copy)**

```
git init
git status
git add .
git commit -m "msg"
git remote add origin git@github.com:user/repo.git
git push -u origin main

git switch -c feature
git switch main
git branch -d feature
git push origin --delete branchname

git restore file.txt
git log --oneline

ssh-keygen -t ed25519 -C "email"
ssh-add ~/.ssh/id_ed25519
ssh -T git@github.com
```

---

# 🚀 Want me to generate this as a downloadable **PDF** also?
