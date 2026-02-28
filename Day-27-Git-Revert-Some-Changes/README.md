# Day 25 – Git Revert Some Changes

## Task Summary
The Nautilus development team reported issues with the most recent commit in the Git repository located at:

```
/usr/src/kodekloudrepos/cluster
```

Objective is to:
- Revert the latest commit (**HEAD**)  
- Restore the repository to the previous commit (the one with the *initial commit message*)  
- Use the exact commit message:  

```
revert cluster
````
(all lowercase)

---

## Step 1: Navigate to the Repository

```bash
cd /usr/src/kodekloudrepos/cluster
````

Confirm you are inside a Git repository:

```bash
git status
```
---

## Step 2: Verify Commit History

Check the commit log to confirm the latest commit and identify the previous commit:

```bash
git log --oneline
```

You should see:

* The latest commit (HEAD)
* The previous commit (with the initial commit message)

---

## Step 3: Revert the Latest Commit

Use `git revert` to create a new commit that undoes the changes introduced by HEAD:

```bash
git revert HEAD -m "revert cluster"
```
If your Git version does not accept `-m` for message directly, use:

```bash
git revert HEAD
```
Then when the editor opens:

* Replace the default message
* Enter exactly:

```
revert cluster
```

Save and exit.

---

## Step 4: Verify the Revert

Confirm that:

* A new commit exists
* The message is `revert cluster`
* The repository state matches the previous commit

```bash
git log --oneline
```

You should now see:

1. `revert cluster`
2. The previous commit (initial commit message)

---

## Important Notes

* `git revert` **does not delete history**.
* It creates a new commit that safely undoes changes.
* This is the correct approach for shared or production repositories.
* Do **NOT** use `git reset --hard` in collaborative environments.

