# Day 07 – Linux SSH Authentication (Password-less Access)

## Task Overview
The xFusionCorp Industries sysadmin team runs automated scripts from the **jump host** that must access all **app servers** in the Stratos Datacenter.  
To support secure automation, configure **password-less SSH authentication** from user `thor` on the jump host to all app servers via their respective **sudo users** (e.g., `tony` on App Server 1).

---

## Objective
- Enable SSH key-based authentication from:
  - `thor@jump-host`
- To:
  - `<sudo-user>@app-server`
- Without requiring password prompts.

---

## Solution Approach
SSH key-based authentication uses a **public/private keypair**:
- Private key remains on the jump host.
- Public key is copied to each remote server’s `authorized_keys` file.
- SSH connections are then authenticated automatically.

---

## Implementation Steps

### 1. Switch to Thor User on Jump Host
```bash
su - thor
````

---

### 2. Generate SSH Keypair

```bash
ssh-keygen -t rsa -b 2048
```

* Press `Enter` to accept defaults.
* Leave passphrase empty for automation compatibility.

Generated files:

```
~/.ssh/id_rsa
~/.ssh/id_rsa.pub
```

---

### 3. Copy Public Key to Each App Server

#### Example: App Server 1 (sudo user `tony`)

```bash
ssh-copy-id tony@app-server-1
```

Repeat for remaining servers:

```bash
ssh-copy-id <sudo-user>@app-server-2
ssh-copy-id <sudo-user>@app-server-3
```

**Alternative Method**

```bash
cat ~/.ssh/id_rsa.pub | ssh tony@app-server-1 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

---

### 4. Verify Password-less SSH Access

```bash
ssh tony@app-server-1
```

Expected:

* Login without password prompt.

Repeat verification for all app servers.

---

##  Validation Checklist

* SSH keypair exists for `thor`.
* Public key added to each sudo user’s `authorized_keys`.
* Password-less SSH works successfully.
* Automation scripts run without interactive login.

---

## Production Relevance

* Enables secure infrastructure automation.
* Eliminates password-based authentication risks.
* Supports CI/CD, cron jobs, and remote orchestration.
* Aligns with DevOps security best practices.

---

## Outcome

Password-less SSH authentication successfully configured from jump host to all app servers, ensuring seamless automated operations across the infrastructure.
