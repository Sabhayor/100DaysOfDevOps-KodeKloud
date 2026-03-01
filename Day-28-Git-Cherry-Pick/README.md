# Day 28: Git Cherry-Pick

## Task Overview
In this **KodeKloud 100 Days of DevOps** challenge, the repository `/opt/media.git` is cloned at: ``/usr/src/kodekloudrepos/media``

There are two branches:

- `master`
- `feature`

A developer made multiple commits on the `feature` branch, but only **one specific commit** with the message: ``
Update info.txt`` needs to be merged into `master` -- without merging the entire `feature` branch.

This is achieved using **git cherry-pick**.

---

## Step-by-Step Solution

### 1️. Navigate to the Repository

```bash
cd /usr/src/kodekloudrepos/media
```

Confirm you're inside a Git repo:

```bash
git status
```

---

### 2️. Fetch Latest Changes (Best Practice)

```bash
git fetch --all
```

---

### 3️. Identify the Commit on `feature` Branch

Switch to `feature`:

```bash
git checkout feature
```

View commit history:

```bash
git log --oneline
```

Locate the commit with message:

```
Update info.txt
```

Copy its **commit hash** (e.g., `a1b2c3d`).

---

### 4️. Switch to `master` Branch

```bash
git checkout master
```

Ensure it's up to date:

```bash
git pull origin master
```

---

### 5️. Cherry-Pick the Required Commit

```bash
git cherry-pick <commit-hash>
```

Example:

```bash
git cherry-pick a1b2c3d
```

If no conflicts occur, Git will automatically create a new commit on `master` with the same changes.

---

### 6️. Resolve Conflicts (If Any)

If conflicts appear:

```bash
# Fix the conflicting file(s)
vi info.txt   # or use any editor

git add info.txt
git cherry-pick --continue
```

---

### 7️⃣ Push Changes to Remote Repository

```bash
git push origin master
```

---

## Verification

Confirm commit exists on `master`:

```bash
git log --oneline
```

You should see the `Update info.txt` commit in the `master` branch history.

![Git cherry-pick](./images/git%20cherry-pick.png)
---

## Key Concept

* `git merge` → merges entire branch
* `git cherry-pick` → applies a specific commit to another branch

This approach is common in production when:

* A hotfix is needed from a feature branch
* A specific bug fix must be promoted without incomplete feature work
* Selective commit promotion is required in release management workflows

---

## Outcome

- Only the `Update info.txt` commit from `feature` is applied to `master`
- Feature branch remains unchanged
- Changes successfully pushed to remote
