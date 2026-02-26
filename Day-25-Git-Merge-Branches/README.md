# Day 25 – Git Merge Branches

## Task
The Nautilus application development team has been working on a project repository /opt/games.git. This repo is cloned at /usr/src/kodekloudrepos on storage server in Stratos DC. They recently shared the following requirements with datacenter team:

Create a new branch datacenter in /usr/src/kodekloudrepos/ecommerce repo from master and copy the /tmp/index.html file (present on storage server itself) into the repo. Further, add/commit this file in the new branch and merge back that branch into master branch. Finally, push the changes to the origin for both of the branches.

---

### Objective

In the cloned repository located at:

```
/usr/src/kodekloudrepos/ecommerce
```

You must:

1. Create a new branch `datacenter` from `master`
2. Copy `/tmp/index.html` into the repository
3. Add and commit the file in `datacenter`
4. Merge `datacenter` into `master`
5. Push both branches to `origin`

---

## Step-by-Step Implementation

### 1. Navigate to the Repository

Log into the storage server and change to the root user to operate on the repo.

```
ssh natasha@ststor01
```
Switch to root
```
sudo -i
```

```bash
cd /usr/src/kodekloudrepos/ecommerce
```

Verify current branch:

```bash
git branch
```

Ensure you're on `master`. If not:

```bash
git checkout master
```

---

### 2. Create and Switch to `datacenter` Branch

```bash
git checkout -b datacenter
```

This creates `datacenter` from `master` and switches to it.

Confirm:

```bash
git branch
```

---

### 3. Copy `index.html` into the Repository

```bash
cp /tmp/index.html .
```

Verify file presence:

```bash
ls -l
```

---

### 4. Stage and Commit the File

```bash
git add index.html
git commit -m "Add index.html from tmp directory"
```

Validate commit:

```bash
git log --oneline
```

---

### 5. Merge `datacenter` into `master`

Switch back to master:

```bash
git checkout master
```

Merge:

```bash
git merge datacenter
```

If no conflicts exist, this will complete as a fast-forward merge.

---

### 6. Push Both Branches to Origin

Push `master`:

```bash
git push origin master
```

Push `datacenter`:

```bash
git push origin datacenter
```

Verify remote branches:

```bash
git branch -r
```

---

## Validation Checklist

* `datacenter` branch created from `master`
* `index.html` added and committed in `datacenter`
* `datacenter` successfully merged into `master`
* Both branches pushed to `origin`

