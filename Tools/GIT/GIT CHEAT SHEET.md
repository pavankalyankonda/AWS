---

# 🌟 Git Cheat Sheet (With Simple Explanations)

---

## ## 1. **Basic Setup**

Set your identity so Git knows who is committing.

```bash
git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"
```

---

## ## 2. **SSH Setup (Login to GitHub Without Password)**

SSH keys let you connect to GitHub securely without typing passwords.

### 🔑 Generate SSH Key Pair

Creates a private + public key.

```bash
ssh-keygen -t ed25519 -C "your-email@example.com"
```

### ▶️ Start SSH Agent

```bash
eval "$(ssh-agent -s)"
```

### ➕ Add Private Key

```bash
ssh-add ~/.ssh/id_ed25519
```

### 📋 Copy Public Key

```bash
cat ~/.ssh/id_ed25519.pub
```

Add this to **GitHub → Settings → SSH Keys**.

---

## ## 3. **Check Status**

Shows modified, staged, and untracked files.

```bash
git status
```

---

## ## 4. **Add & Commit**

Stage files:

```bash
git add .
```

Save your changes:

```bash
git commit -m "your message"
```

---

## ## 5. **Push & Pull**

Send your code to GitHub:

```bash
git push origin branch-name
```

Get new changes from GitHub:

```bash
git pull
```

---

## ## 6. **Branches**

### 🌿 What is a branch?

A separate line of work — like creating a safe copy of your project.

---

### 📌 `checkout` vs `switch` (Simple Explanation)

#### **1. `git checkout` — old + powerful**

* Switch branches
* Create branches
* Restore files
* Checkout commits
* More confusing

Examples:

```bash
git checkout main
git checkout -b feature
git checkout file.txt
```

---

#### **2. `git switch` — new, simple, safer**

ONLY for branch switching.

Examples:

```bash
git switch main
git switch -c feature
```

---

### ✔️ Create a branch

```bash
git branch newbranch
```

### 🔁 Switch branch (using checkout)

```bash
git checkout newbranch
```

### 🌟 Create + Switch together

```bash
git checkout -b newbranch
```

---

## ## 7. **Rename Branch**

Rename current branch:

```bash
git branch -m newname
```

Push renamed branch to GitHub:

```bash
git push origin -u newname
```

---

## ## 8. **Delete Branch**

### 📍 Delete local branch

```bash
git branch -d branchname
```

### 📍 Delete branch on GitHub

```bash
git push origin --delete branchname
```

---

## ## 9. **Remotes**

Show remote URLs:

```bash
git remote -v
```

Change remote URL:

```bash
git remote set-url origin git@github.com:USERNAME/REPO.git
```

---

## ## 10. **Undo / Reset**

Undo last commit but keep changes:

```bash
git reset --soft HEAD~1
```

Undo last commit AND delete changes:

```bash
git reset --hard HEAD~1
```

---

## ## 11. **View Commit History**

Compact, simple:

```bash
git log --oneline
```

---

## ## 12. **Create a New Repo Locally & Push to GitHub**

```bash
git init
git add .
git commit -m "first commit"
git branch -M main
git remote add origin git@github.com:USERNAME/REPO.git
git push -u origin main
```

---