# Day 21 - Set Up Git Repository on Storage Server  

## Task / Requirement
The Nautilus development team requested the setup of a centralized Git repository on the Storage Server to support a new application development project.

The requirement is to install Git and create a bare Git repository with an exact name and path.

### Requirement details:

- Server: Storage Server (ststor01)
- Package: Git
- Repository type: Bare repository
- Repository path: /opt/news.git


In this task, the objective is to provision a centralized Git repository on the Storage Server within the Stratos DC environment. This simulates a real-world production scenario where a dedicated server hosts shared source code repositories for development teams.

---

## Step 1: Install Git on the Storage Server

SSH into the Storage Server and install Git using `yum`:

```bash
sudo yum install -y git
```

Verify installation:

```bash
git --version
```

This ensures the system has the required VCS tooling for repository management in an enterprise Linux environment.

---

## Step 2: Create the Bare Repository

Navigate to the `/opt` directory and create the required bare repository:

```bash
sudo git init --bare /opt/news.git
```

### Why `--bare`?

A **bare repository**:

* Does not contain a working directory
* Is designed for remote collaboration
* Acts as a central repository for push/pull operations

This mirrors how centralized repositories are configured in production environments for CI/CD pipelines and distributed development workflows.

---

## Step 3: Validate Repository Creation

Confirm the directory exists:

```bash
ls -ld /opt/news.git
```

Ensure the structure contains standard Git bare repo directories like:

* `HEAD`
* `objects/`
* `refs/`

---

## Outcome

* Git installed via package manager
* Centralized bare repository created at `/opt/news.git`
* Ready for developers to clone and push code

## Key Learnings

- Non-bare Git repositories include a working directory and a hidden .git/ folder containing metadata
- Bare Git repositories contain only Git metadata (HEAD, objects, refs, hooks) and no working tree
- git init creates a non-bare repository by default
- git init --bare creates a bare repository
- Bare repositories are used as centralized or shared remote repositories
-Pushing to a non-bare repository on a shared server can cause branch and working tree conflicts
- Repository type can be verified using git config --get core.bare
- Bare repositories do not allow file edits or branch checkouts


