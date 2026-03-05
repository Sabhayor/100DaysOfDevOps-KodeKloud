# Day 31 – Git Stash

## Task Overview  
The Nautilus development team had unfinished changes stashed in the Git repository located at:

`/usr/src/kodekloudrepos/demo`

The objective was to:
1. Identify available stashes.
2. Restore `stash@{1}`.
3. Commit the restored changes.
4. Push them to the `origin` remote repository.

This mirrors real production scenarios where developers temporarily shelve work (e.g., urgent hotfixes) and later need to safely reapply it.

---

## Step-by-Step Implementation

### 1️. Navigate to the Repository
```bash
cd /usr/src/kodekloudrepos/demo
```

### 2️. Verify Available Stashes

```bash
git stash list
```

This confirms that `stash@{1}` exists.

---

### 3️. Restore the Required Stash

```bash
git stash apply stash@{1}
```

> `apply` restores the changes but keeps the stash entry intact.
> If required to remove it automatically, `git stash pop stash@{1}` could be used instead.

---

### 4️. Verified the restored changes using Git status

```
git status
```
--- 

### 5. Stage the Restored Changes

```bash
git add .
```

---

### 6. Commit the Changes

```bash
git commit -m "Restored stashed changes from stash@{1}"
```

---

### 7. Push to Origin

```bash
git push origin <current-branch>
```

Confirm your working branch before pushing:

```bash
git branch
```

![Git stash](./images/git%20stash.png)
---

### Key Learnings
git stash temporarily saves uncommitted changes without creating a commit
git stash list displays all available stashes
git stash apply restores stashed changes but keeps them in the stash list
git stash pop restores stashed changes and removes them from the stash list
Restored changes must be committed before pushing to a remote repository
Git stash is useful for switching context without losing work

---

## Production Relevance

`git stash` is frequently used in real-world DevOps workflows when:

* Switching branches during urgent production fixes.
* Pulling upstream changes without committing incomplete work.
* Temporarily shelving experimental changes.

Knowing how to precisely restore a specific stash reference (like `stash@{1}`) prevents accidental overwrites and ensures controlled version history management.