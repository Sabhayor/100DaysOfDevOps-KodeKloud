# Day 1 – Linux User Setup with Non-Interactive Shell

## Task

The system administration team required the creation of a user account for a backup agent tool with a non-interactive shell on App Server 01.
Create a user named ``mark`` with a non-interactive shell on App Server 01.

---

## Task Requirements

The system administration team required the following:

* Create a user named **`mark`**
* Assign a **non-interactive shell**
* Deploy on **AppServer01**
* Ensure the user **cannot log in interactively**

---

## Why This Matters (DevOps Perspective)

In production environments:

* Service accounts **must not allow interactive logins**
* Reduces attack surface and credential abuse
* Enforces the **Principle of Least Privilege**
* Common for:

  * Backup agents
  * Monitoring tools
  * CI/CD runners
  * System daemons

This task reflects **industry-standard Linux security practices** used in enterprise environments.

---

## Technical Overview: Non-Interactive Shells

Non-interactive shells block terminal access while still allowing processes to run under the user context.

Common options:

* `/sbin/nologin` *(recommended)*
* `/usr/sbin/nologin`
* `/bin/false`

For this task, **`/sbin/nologin`** is used as the standard and secure choice.

---

## Implementation Steps

### Step 1: Connect to the Application Server

```bash
ssh user@AppServer01
```

> Replace `user` with your SSH username.

---

### Step 2: Create the Service User

```bash
sudo useradd -s /sbin/nologin mark
```

**Command Breakdown:**

* `useradd` → Creates a new Linux user
* `-s /sbin/nologin` → Disables interactive login
* `mark` → Service account name

---

### Step 3: Verify User Configuration

```bash
getent passwd mark
```

**Expected Output:**

```text
mark:x:1002:1002::/home/mark:/sbin/nologin
```

Confirms the assigned non-interactive shell

---

### Step 4: Validate Login Restriction

```bash
su - mark
```

**Expected Result:**

```text
This account is currently not available.
```

Confirms successful restriction of interactive access

---

## Outcome

* Secure service account created
* Interactive access disabled
* Configuration validated
* Meets enterprise Linux security standards

---

## Skills Demonstrated

* Linux User & Access Management
* Security Hardening
* Service Account Best Practices
* SSH & Privilege Control
* DevOps Operational Fundamentals



