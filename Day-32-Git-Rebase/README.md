# Day 32 – Git Rebase

## Task Overview
The Nautilus development team is working with a repository located at `/opt/games.git`, which is cloned on the Storage Server at:

```
/usr/src/kodekloudrepos/games
```

A developer is currently working on a **feature branch**, but new commits have already been pushed to the **master branch**. Instead of merging `master` into the feature branch (which would create a merge commit), the requirement is to **rebase the feature branch onto master** so the feature branch sits on top of the latest `master` commits while preserving all feature work.

Finally, the updated branch must be pushed to the remote repository.

---

## Step 1: Switch to Storage Server
SSH into the **storage server** where the repository is located.

```bash
ssh natasha@ststor01
```
---

## Step 2: Navigate to the Repository

```bash
cd /usr/src/kodekloudrepos/games
```

Verify the repository:

```bash
git status
```

---

## Step 3: Fetch Latest Changes

Ensure the local repository has the latest updates from the remote.

```bash
git fetch origin
```

---

## Step 4: Checkout the Feature Branch

Switch to the branch the developer is working on.

```bash
git checkout feature
```

Confirm:

```bash
git branch
```

---

## Step 5: Rebase Feature Branch with Master

Rebase the feature branch onto the latest `master` branch.

```bash
git rebase origin/master
```

This will replay all commits from the `feature` branch on top of the newest `master` commits **without creating a merge commit**.

---

## Step 6: Resolve Conflicts (If Any)

If conflicts appear:

1. Open the conflicted files and fix them.
2. Stage the resolved files.

```bash
git add <file-name>
```

3. Continue the rebase:

```bash
git rebase --continue
```

Repeat until the rebase completes.

---

## Step 7: Push the Updated Feature Branch

Because rebasing rewrites commit history, a **force push** is required.

```bash
git push origin feature --force
```

---

## Verification

Check the commit history to ensure the feature branch now sits on top of master:

```bash
git log --oneline --graph
```

You should see a **linear commit history with no merge commits**.

---

### Key Learnings
- git rebase reapplies commits from one branch on top of another branch
- Rebase keeps commit history linear by avoiding merge commits
- Rebasing does not remove feature branch changes
- Rebasing rewrites commit history
- A force push is required when rebased history already exists on the remote
- Rebase should be used carefully on shared branches
- git merge preserves history by creating a merge commit, while git rebase rewrites history for a cleaner, linear timeline

---

## Key Takeaway

`git rebase` is commonly used in production workflows to maintain a **clean, linear Git history**, especially in teams that enforce **rebase-based pull request workflows**. It helps integrate upstream changes without cluttering the commit history with unnecessary merge commits.