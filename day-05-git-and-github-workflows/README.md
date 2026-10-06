# Day 5: Version Control with Git, GitHub Workflows & Advanced Git Operations

**Date:** Oct 06  
**Topic:** Git Architecture, First-Time Setup & SSH Authentication, Daily Workflow, Branching & Merging, Merge Conflicts, Rebase vs Merge, Stashing, Cherry-Pick, Reset vs Revert, Reflog, Tagging, and DevOps Git Hooks.

---

## 1. What is Git & Why is it Critical for DevOps?

**Git** is a Distributed Version Control System (DVCS) designed to track code changes, enable multi-developer collaboration, and support reproducible software releases.

### Why DevOps Teams Rely on Git:
* **Infrastructure as Code (IaC):** Terraform scripts, Ansible playbooks, and Kubernetes manifests are stored and versioned in Git.
* **GitOps & CI/CD:** Pull requests and merged commits automatically trigger build, test, and deployment pipelines (e.g., GitHub Actions, ArgoCD, Jenkins).
* **Traceability & Auditability:** Every commit records the author, timestamp, commit hash, and the exact lines changed.

```
+-----------------------------------------------------------------------------------+
|                                  Git Architecture                                 |
+-----------------------------------------------------------------------------------+
|                                                                                   |
|  [ Working Directory ]  -- (git add) -->  [ Staging Area / Index ]               |
|         |                                        |                                |
|         |                                 (git commit)                            |
|         v                                        v                                |
|  [ Untracked / Modified ]                  [ Local Repository (.git) ]            |
|                                                  |                                |
|                                             (git push / pull)                     |
|                                                  v                                |
|                                       [ Remote Repository (GitHub) ]              |
|                                                                                   |
+-----------------------------------------------------------------------------------+
```

---

## 2. First-Time Git Configuration & SSH Setup

### 2.1 Setting Global Identity
```bash
# Set global username and email (used in commit logs)
git config --global user.name "Shree"
git config --global user.email "shreeade766@gmail.com"

# Set default initial branch name to 'main'
git config --global init.defaultBranch main

# Set default editor (VS Code / Vim)
git config --global core.editor "code --wait"

# Enable colored CLI output
git config --global color.ui auto

# Inspect current configuration
git config --list --show-origin
```

### 2.2 Configuring SSH Key for Secure GitHub Authentication
```bash
# 1. Generate an Ed25519 SSH key pair
ssh-keygen -t ed25519 -C "shreeade766@gmail.com"

# 2. View and copy the public key
cat ~/.ssh/id_ed25519.pub

# 3. Add the public key to GitHub (Settings -> SSH and GPG Keys -> New SSH Key)

# 4. Test SSH connectivity
ssh -T git@github.com
```

---

## 3. Core Daily Git Commands

| Command | Description | Example |
| :--- | :--- | :--- |
| `git init` | Initialize a new empty Git repository in the current folder. | `git init -b main` |
| `git clone <url>` | Clone a remote repository to local machine. | `git clone git@github.com:user/repo.git` |
| `git status` | Show state of working directory and staging area. | `git status` |
| `git add <file>` | Stage specific file or all files (`git add .`). | `git add app.py .env.example` |
| `git commit -m` | Record staged snapshot with a descriptive message. | `git commit -m "feat: add user auth"` |
| `git log` | View chronological commit history. | `git log --oneline --graph --all` |
| `git diff` | View unstaged changes (Working Directory vs Staging). | `git diff` |
| `git diff --staged` | View staged changes waiting to be committed. | `git diff --staged` |

---

## 4. Branching, Merging & Remote Collaboration

### 4.1 Branch Management
```bash
# List local branches
git branch

# Create a new feature branch
git branch feat/api-endpoints

# Switch to the branch (or using git checkout)
git switch feat/api-endpoints

# Create and switch in a single command
git switch -c feat/database-migration

# Delete a merged branch
git branch -d feat/database-migration

# Force delete an unmerged branch
git branch -D feat/obsolete-work
```

### 4.2 Merging Branches
```bash
# 1. Switch to destination branch
git switch main

# 2. Merge changes from feature branch
git merge feat/api-endpoints
```

### 4.3 Remote Commands
```bash
# Link local repo with remote GitHub repo
git remote add origin git@github.com:username/devops-repo.git

# Push changes and set upstream tracking branch
git push -u origin main

# Pull latest commits from remote and merge into local
git pull origin main

# Fetch remote metadata without modifying working directory
git fetch origin
```

---

## 5. Resolving Merge Conflicts

A merge conflict happens when two branches modify the exact same lines of code in a file differently.

```
<<<<<<< HEAD (Current Branch / main)
PORT = 8080
=======
PORT = 9000
>>>>>>> feat/custom-port (Incoming Branch)
```

### Conflict Resolution Steps:
1. Open conflicted files in your editor.
2. Decide which code to keep, delete the conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`).
3. Save the file.
4. Stage the resolved file: `git add app.py`
5. Finalize the merge commit: `git commit -m "fix: resolve port conflict during merge"`

---

## 6. Advanced Git Topics for DevOps

### 6.1 Git Stash (Saving Work in Progress)
Used when you need to switch branches urgently without committing half-written or broken code.

```bash
# Temporarily shelve all uncommitted changes
git stash save "WIP: auth middleware"

# List all saved stashes
git stash list

# Re-apply the most recent stash and remove it from stash list
git stash pop

# Apply stash without removing from stash list
git stash apply stash@{0}

# Discard a specific stash
git stash drop stash@{0}

# Clear all stashes
git stash clear
```

---

### 6.2 Git Rebase vs Git Merge

* **`git merge`:** Preserves complete history and creates an explicit merge commit. Non-destructive and safe for shared team branches.
* **`git rebase`:** Re-applies your feature commits on top of the latest `main` branch to create a clean, linear history.

```bash
# Rebase feature branch on top of latest main
git switch feat/logging
git rebase main

# Interactive Rebase: Clean up / squash the last 3 commits before opening a PR
git rebase -i HEAD~3
```
> **Golden Rule of Rebase:** Never rebase a public/shared branch that other teammates are actively pulling from.

---

### 6.3 Undoing Changes: `restore`, `revert`, and `reset`

| Action | Command | Scope & Safety |
| :--- | :--- | :--- |
| **Discard Unstaged Changes** | `git restore file.txt`<br>*(or `git checkout -- file.txt`)* | Modifies working directory only. |
| **Unstage a Staged File** | `git restore --staged file.txt`<br>*(or `git reset HEAD file.txt`)* | Moves file from Staging back to Working dir without losing edits. |
| **Amend Last Commit** | `git commit --amend -m "new message"` | Updates last commit message or adds newly staged files. |
| **Safe Revert (Public Branches)** | `git revert <commit-id>` | Creates a **new** commit that inverses previous changes. Safe for team repos. |
| **Reset Soft** | `git reset --soft HEAD~1` | Moves HEAD back 1 commit; keeps changes staged. |
| **Reset Mixed (Default)** | `git reset --mixed HEAD~1` | Moves HEAD back 1 commit; keeps changes in working directory (unstaged). |
| **Reset Hard (Dangerous)** | `git reset --hard HEAD~1` | Discards commits and wipes all uncommitted changes permanently. |

---

### 6.4 Git Reflog (The DevOps Safety Net)
`git reflog` records every single movement of `HEAD` (including reset, checkout, rebase, and deleted commits).

```bash
# View full history of HEAD movements
git reflog

# Recover from an accidental 'git reset --hard'
git reset --hard HEAD@{2}
```

---

### 6.5 Git Cherry-Pick
Copies a specific commit from one branch and applies it onto your current branch.

```bash
# Apply a critical hotfix commit onto the main branch
git switch main
git cherry-pick <commit-hash>
```

---

### 6.6 Git Tags & Release Management
Tags mark specific points in repository history, typically used for production releases (`v1.0.0`, `v2.1.0`).

```bash
# Create an annotated release tag
git tag -a v1.0.0 -m "Release version 1.0.0 for production"

# List all tags
git tag -l

# View tag details and associated commit
git show v1.0.0

# Push a single tag to GitHub
git push origin v1.0.0

# Push all local tags to GitHub
git push origin --tags
```

---

### 6.7 Git Hooks for DevOps Automation
Git hooks are custom shell scripts located in `.git/hooks/` that run automatically before or after Git lifecycle events.

* **`pre-commit`:** Runs linters, static code analysis, and secret scanners (e.g. `gitleaks`) to block accidental API key commits.
* **`commit-msg`:** Enforces conventional commit message formatting.
* **`pre-push`:** Runs unit test suites before allowing code to be pushed to remote repositories.

---

## 7. Real-World DevOps Git Workflow Summary

```
1. Sync local main:              git switch main && git pull origin main
2. Create feature branch:        git switch -c feat/nginx-reverse-proxy
3. Develop & Stage changes:      git add nginx.conf docker-compose.yml
4. Commit atomic change:         git commit -m "feat: configure nginx reverse proxy routing"
5. Keep branch updated:          git fetch origin && git rebase origin/main
6. Push to GitHub:               git push -u origin feat/nginx-reverse-proxy
7. Pull Request & Review:        Open PR on GitHub -> automated CI testing -> peer review
8. Tag Release upon deploy:      git tag -a v1.2.0 -m "Release v1.2.0" && git push origin v1.2.0
```

---

## 8. Practice Script

* [`scripts/git_branch_practice.sh`](./scripts/git_branch_practice.sh) — Hands-on script simulating branch creation, commit history inspection, stashing, and merge operations.
