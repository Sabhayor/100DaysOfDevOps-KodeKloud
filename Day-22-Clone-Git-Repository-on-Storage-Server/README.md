
# Day 22 - Clone Git Repository on Storage Server  

### Objective  
Clone the existing Git repository located at `/opt/beta.git` to `/usr/src/kodekloudrepos` on the Storage Server in Stratos DC using the `natasha` user, without modifying permissions or altering the source repository.

---

## Step 1: Switch to the Correct User

Ensure the operation is performed as `natasha`.

```bash
ssh natasha@ststor01
````

Verify:

```bash
whoami
```

Output should be:

```bash
natasha
```

---

## Step 2: Verify the Source Repository

Confirm the repository exists at the specified location:

```bash
ls -ld /opt/beta.git
```

This is a bare repository (typically ends with `.git`). Do not modify its permissions or contents.

---

## Step 3: Navigate to Target Directory

Ensure the destination directory exists:

```bash
ls -ld /usr/src/kodekloudrepos
```

If it already exists (as expected in the lab), do not change its ownership or permissions.

Move into the directory:

```bash
cd /usr/src/kodekloudrepos
```

---

## Step 4: Clone the Repository

Execute the clone operation:

```bash
git clone /opt/beta.git
```

This will create:

```
/usr/src/kodekloudrepos/beta
```

---

## Step 5: Verify the Clone

```bash
ls -l /usr/src/kodekloudrepos
```

Check Git status inside the cloned repo:

```bash
cd beta
git status
```

You should see:

```
On branch master
nothing to commit, working tree clean
```

---

## Key Validation Points

* Repository cloned successfully
* Operation executed as `natasha`
* No permission changes performed
* Source repository `/opt/beta.git` remains untouched
* Target path: `/usr/src/kodekloudrepos/beta`

---

## Key Learnings
git clone creates a complete local copy of an existing Git repository
Cloning copies all branches, commit history, and repository metadata
Git repositories can be cloned from local filesystem paths, not just remote URLs
Cloning a repository does not modify the source repository
Bare repositories are commonly used as clone sources on servers
Verifying source and destination paths helps avoid accidental overwrites

---

## DevOps Relevance

Cloning repositories onto storage nodes is common in production environments for artifact staging, backup strategies, CI/CD runners, and deployment automation workflows. This task reinforces secure user-context operations and proper Git handling on Linux servers.

