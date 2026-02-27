# Day 26 – Git Manage Remotes

## Objective
Update Git remotes for the existing repository and push recent changes to the correct remote.

Repository paths:
- Bare repo: `/opt/ecommerce.git`
- Working repo: `/usr/src/kodekloudrepos/ecommerce`
- New remote target: `/opt/xfusioncorp_ecommerce.git`

---

## Step 1: Navigate to the Repository

```bash
cd /usr/src/kodekloudrepos/ecommerce
````

Verify you are inside a Git repository:

```bash
git status
```
Verify existing Git remotes
```
git remote -v
```
---

## Step 2: Add the New Remote

Add a new remote named `dev_ecommerce` pointing to `/opt/xfusioncorp_ecommerce.git`.

```bash
git remote add dev_ecommerce /opt/xfusioncorp_ecommerce.git
```

Verify the remote was added correctly:

```bash
git remote -v
```

You should see `dev_ecommerce` listed.

---

## Step 3: Copy the File into the Repository

Copy the required file into the repo:

```bash
cp /tmp/index.html .
```

Confirm the file exists:

```bash
ls
```

---

## Step 4: Add and Commit to Master Branch

Ensure you are on the `master` branch:

```bash
git branch
```

If not:

```bash
git checkout master
```

Stage and commit the file:

```bash
git add index.html
git commit -m "Added index.html from /tmp as per DevOps update"
```

---

## Step 5: Push Master to the Correct Remote

Push master branch to new remote
```
git push dev_ecommerce master
```

---

## Verification

* Confirm commit exists:

  ```bash
  git log --oneline
  ```

* Confirm remotes:

  ```bash
  git remote -v
  ```

---

## Key Git Concepts Practiced

* Managing remotes (`git remote add`)
* Validating remote configuration
* Working with branches
* Staging and committing changes
* Pushing to remote repositories

---

## Key Learnings
* Git remotes define where repository changes are pushed or pulled from
* Multiple remotes can exist for a single Git repository
* git remote add is used to configure new remotes
* Changes must be committed before they can be pushed
* Branches can be pushed to any configured remote
