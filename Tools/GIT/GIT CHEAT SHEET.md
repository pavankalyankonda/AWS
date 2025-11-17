🌟 GIT CHEAT SHEET (WITH SIMPLE EXPLANATIONS)
1. BASIC SETUP
✔️ Set your name & email

Git uses this for commit history.

git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"

2. SSH KEY SETUP (FOR GITHUB ACCESS WITHOUT PASSWORDS)
✔️ Generate SSH key

Creates 1 private + 1 public key for authentication.
Public key goes to GitHub, private key stays on your system.

ssh-keygen -t ed25519 -C "your-email@example.com"

✔️ Start SSH agent
eval "$(ssh-agent -s)"

✔️ Add private key to agent
ssh-add ~/.ssh/id_ed25519

✔️ Copy public key
cat ~/.ssh/id_ed25519.pub


Paste it into: GitHub → Settings → SSH Keys.

3. CHECKING REPO STATUS
✔️ See what changed

Shows modified files, staged files, untracked files.

git status

4. ADDING & COMMITTING
✔️ Stage files (tell git to track them)
git add .

✔️ Commit (save your changes)
git commit -m "your message"

5. PUSH & PULL
✔️ Push your code to GitHub
git push origin branch-name

✔️ Pull new code from GitHub
git pull

6. BRANCHING (VERY IMPORTANT)
✅ What is a branch?

A separate line of work. Like making a copy of your project where you can work safely without affecting main code.

🌿 CREATE BRANCH
✔️ Create a new branch
git branch newbranch


Creates branch but does NOT switch to it.

🔁 SWITCH BRANCHES
✔️ What does checkout do?

It moves you to another branch so you can start working on it.

✔️ Switch to a branch
git checkout newbranch

🌟 Create + Switch together
git checkout -b newbranch

7. RENAME BRANCH
✔️ Rename current branch
git branch -m newname

✔️ Push renamed branch to GitHub
git push origin -u newname

8. DELETE BRANCH
✔️ Delete local branch
git branch -d branchname

✔️ Delete branch from GitHub
git push origin --delete branchname

9. REMOTES
✔️ Show remotes
git remote -v

✔️ Change remote URL
git remote set-url origin git@github.com:USERNAME/REPO.git

10. UNDO/RESET
✔️ Undo last commit but keep changes
git reset --soft HEAD~1

✔️ Undo last commit and delete changes
git reset --hard HEAD~1

11. LOGS
✔️ Compact history
git log --oneline

12. CREATE NEW REPO LOCALLY AND PUSH
git init
git add .
git commit -m "first commit"
git branch -M main
git remote add origin git@github.com:USERNAME/REPO.git
git push -u origin main

✅ FULL COPY-READY CHEAT SHEET (WITH SIMPLE EXPLANATIONS)

👇 COPY THIS WHOLE BLOCK 👇

==================== GIT CHEAT SHEET WITH SIMPLE EXPLANATIONS ====================

1. BASIC SETUP
- Set your identity so Git knows who is committing.
git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"

2. SSH SETUP (LOGIN TO GITHUB WITHOUT PASSWORD)
- Generate SSH key pair
ssh-keygen -t ed25519 -C "your-email@example.com"

- Start SSH agent
eval "$(ssh-agent -s)"

- Add private key
ssh-add ~/.ssh/id_ed25519

- Copy public key
cat ~/.ssh/id_ed25519.pub
(Add this to GitHub → Settings → SSH Keys)

3. CHECK STATUS
- Shows changes, staged files, untracked files
git status

4. ADD & COMMIT
- Stage all files
git add .

- Save your changes
git commit -m "message"

5. PUSH & PULL (SEND/GET CODE)
git push origin branch-name
git pull

6. BRANCHES
- What is a branch?
  A separate area to work without affecting main code.
____________________
✅ CHECKOUT vs SWITCH — Simple Explanation
1. git checkout (Old command, does many things)

checkout is an older Git command that can:

✔️ Switch branches
✔️ Create new branches
✔️ Restore files
✔️ Detach HEAD (dangerous for beginners)

Because it does too many things, it's confusing.

Examples:
git checkout main          # switch to branch
git checkout -b feature    # create + switch
git checkout file.txt      # restore file

✅ 2. git switch (Modern, safer command)

Git created git switch to make things simple for beginners.

✔️ ONLY used for switching branches
✔️ Can also create + switch to a branch
❌ Cannot restore files
❌ Cannot checkout older commits

Examples:
git switch main            # switch branches
git switch -c feature      # create + switch
___________________________________________


- Create a branch:
git branch newbranch

- SWITCH branch (IMPORTANT)
  "checkout" moves you to another branch.
git checkout newbranch

- Create AND switch:
git checkout -b newbranch

7. RENAME BRANCH
git branch -m newname
git push origin -u newname

8. DELETE BRANCH
- Local:
git branch -d branchname

- GitHub (remote):
git push origin --delete branchname

9. REMOTES
- View remotes:
git remote -v

- Change remote:
git remote set-url origin git@github.com:USERNAME/REPO.git

10. UNDO
- Undo last commit but keep files:
git reset --soft HEAD~1

- Undo and delete changes:
git reset --hard HEAD~1

11. VIEW HISTORY
git log --oneline

12. CREATE NEW REPO LOCALLY
git init
git add .
git commit -m "first commit"
git branch -M main
git remote add origin git@github.com:USERNAME/REPO.git
git push -u origin main

===============================================================================
