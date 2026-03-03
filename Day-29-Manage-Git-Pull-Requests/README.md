
# Day 29 - Manage Git Pull Requests

## Objective
Implement a proper Pull Request (PR) workflow to prevent direct pushes to the `master` branch and ensure code is reviewed before merge — a critical production best practice for change control and quality assurance.

---

## Step 1: SSH into Storage Server

```bash
ssh max@ststor01
````

Navigate to Max’s home directory and locate the already cloned Git repository.

```bash
cd ~
ls
```

---

## Step 2: Validate Repository Content & History

Confirm that:

* Max’s branch `story/fox-and-grapes` exists remotely.
* Sarah’s story is present.
* Commit history and author details are correct.

```bash
git branch -a
git log --oneline --decorate --graph
git log --pretty=fuller
```

Review:

* **Author**
* **Commit message**
* **Branch references**

This ensures traceability and validates proper Git authorship metadata - essential in real-world CI/CD pipelines.

---

## Step 3: Confirm Max’s Branch is Not in `master`

Switch to master and verify:

```bash
git checkout master
git log --oneline
```

You should observe that `story/fox-and-grapes` commits are not yet merged.

This confirms we need a Pull Request instead of direct push (branch protection best practice).

---

## Step 4: Create Pull Request in Gitea

Access the Git web interface (Gitea UI) from the top bar.

Log in as: **max**

Create a new Pull Request with:

* **Title:** `Added fox-and-grapes story`
* **Source branch:** `story/fox-and-grapes`
* **Destination branch:** `master`

Submit the PR.

---

## Step 5: Assign Reviewer (Tom)

Inside the created PR:

1. Click **Reviewers** on the right panel.
2. Add **tom** as reviewer.
3. Save changes.

This simulates production-grade peer review enforcement before merging into protected branches.

---

## Step 6: Review and Merge as Tom

Logout from the portal.

Login as: **tom**

Open PR:
`Added fox-and-grapes story`

Review the changes → Approve → Merge.

---

## Step 7: Verify Merge

Return to terminal and validate:

```bash
git checkout master
git pull
git log --oneline
```

You should now see the `fox-and-grapes` commits merged into `master`.

![git merge](./images/git%20merge.png)

---

## What This Simulates in Production

* Branch protection strategy
* Peer code review process
* Controlled merge workflow
* Audit trail of approvals
* Secure collaboration via Git-based platforms
