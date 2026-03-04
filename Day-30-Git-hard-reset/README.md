# Day 30 - Git Hard Reset

## Task Overview  
The Nautilus team needs to clean up a test repository located at:

```
/usr/src/kodekloudrepos/demo
````

A developer pushed multiple test commits, but the requirement is to reset the repository so that **only two commits remain** in history:

1. `initial commit`  
2. `add data.txt file`  

Both the **branch pointer and HEAD** must reference the `add data.txt file` commit, and the updated history must be pushed to the remote.

---

## Step 1: Navigate to the Repository

```bash
cd /usr/src/kodekloudrepos/demo
````

Confirm commit history:

```bash
git log --oneline
```

Identify the commit hash for:

```
add data.txt file
```

---

## Step 2: Reset the Branch and HEAD

Since we need to remove all commits after `add data.txt file` and clean the working tree, use a **hard reset**:

```bash
git reset --hard <commit-hash>
```

This command:

* Moves the branch pointer
* Moves HEAD
* Resets the index (staging area)
* Resets the working directory

Now verify:

```bash
git log --oneline
```

You should see only:

* `add data.txt file`
* `initial commit`

---

## Step 3: Push Changes to Remote

Because history was rewritten, a force push is required:

```bash
git push origin <branch-name> --force
```

If you're on `master`:

```bash
git push origin master --force
```

---

## Final Verification

Run:

```bash
git log --oneline
```

Ensure only two commits remain.
The repository history is now clean and aligned with the required state.

---

## Key Learnings
- git reset --hard moves HEAD, the branch pointer, and the working tree to a specific commit
- A hard reset permanently removes commits from the local commit history
git reset rewrites history and should be used cautiously, whereas git revert preserves history and is safer for shared branches
- A force push is required when rewritten history must replace the remote history
- git reset --hard should be avoided on shared or production branches
History rewriting is suitable only for test or tightly controlled repositories



This task reinforces how to surgically rewrite Git history - a critical skill in maintaining clean production repositories when test commits accidentally get merged.

