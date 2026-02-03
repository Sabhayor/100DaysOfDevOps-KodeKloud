# Day 3: Secure Root SSH Access

## Project Overview

As part of the **100 Days of DevOps** challenge, this project demonstrates how to **secure Linux servers by disabling direct SSH access for the root user**. This task reflects a real-world security hardening requirement commonly enforced after infrastructure security audits.

At **xFusionCorp Industries**, new security protocols require that **root users must not be allowed to log in directly via SSH** on any application server within the **Stratos Datacenter**.

---

## Objective

Disable **direct root SSH login** on **all application servers** in the Stratos Datacenter.

---

## Why This Matters (Security Context)

Allowing direct SSH access to the root account:

* Increases the risk of brute-force attacks
* Makes auditing and accountability difficult
* Violates least-privilege security principles

Disabling root SSH login:

* Forces administrators to log in as normal users
* Ensures actions are traceable via `sudo`
* Aligns with industry security best practices

---

## High-Level Steps

1. SSH into each application server
2. Update the SSH daemon configuration
3. Disable root login
4. Restart the SSH service
5. Verify configuration

---

## Step-by-Step Implementation

### Step 1: SSH into the App Server

From the jump/bastion server, connect to an application server:

```bash
ssh user@appserver01
```

Repeat this process for all app servers in the Stratos Datacenter.

---

### Step 2: Edit the SSH Configuration File

Open the SSH daemon configuration file:

```bash
sudo vi /etc/ssh/sshd_config
```

Locate the following directive:

```text
#PermitRootLogin yes
```

Update it to:

```text
PermitRootLogin no
```

> If the directive exists with a different value, replace it with `no`.

---

### Step 3: Restart the SSH Service

Apply the configuration changes by restarting the SSH daemon:

```bash
sudo systemctl restart sshd
```

---

### Step 4: Verify the Configuration

Confirm that root login is disabled:

```bash
grep PermitRootLogin /etc/ssh/sshd_config
```

Expected output:

```text
PermitRootLogin no
```

---

## Commands Used (Quick Reference)

```bash
ssh user@appserver01
sudo vi /etc/ssh/sshd_config
sudo systemctl restart sshd
grep PermitRootLogin /etc/ssh/sshd_config
```



---

## Best Practices & Notes

* Always ensure at least one **sudo-enabled user** exists before disabling root login
* Consider using **SSH key-based authentication** instead of passwords
* In production, enforce this using **Ansible or configuration management tools**

---

## Skills Demonstrated

* Linux server hardening
* SSH security configuration
* Access control best practices
* Real-world DevOps security workflows


---


