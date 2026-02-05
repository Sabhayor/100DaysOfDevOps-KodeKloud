# Day 5: SELinux Installation and Configuration

## Task Overview

Following a security audit, the xFusionCorp Industries security team has decided to begin SELinux testing on infrastructure servers.

### Objectives

On **App Server 2**, perform the following:

1. Install required SELinux packages.
2. Permanently disable SELinux (final state after reboot must be **disabled**).
3. Do **not reboot** the server manually (scheduled maintenance reboot already exists).
4. Ignore the current runtime status; only the post-reboot configuration matters.

---

## Environment Assumptions

- OS: RHEL/CentOS/AlmaLinux/Rocky-based distribution (typical Stratos Datacenter environment)
- Access: SSH with sudo or root privileges
- Package Manager:
  - `yum` (CentOS/RHEL 7)
  - `dnf` (CentOS/RHEL 8+)

---

## Step-by-Step Implementation

### Step 1: Connect to App Server 2

```bash
ssh username@server-ip
````

Switch to root if required:

```bash
sudo -i
```

---

### Step 2: Install Required SELinux Packages

Install core SELinux utilities and policies.

#### For RHEL/CentOS 7

```bash
yum install -y selinux-policy selinux-policy-targeted policycoreutils policycoreutils-python libselinux-utils
```

#### For RHEL/CentOS 8+

```bash
dnf install -y selinux-policy selinux-policy-targeted policycoreutils policycoreutils-python-utils libselinux-utils
```

---

### Step 3: Permanently Disable SELinux

Edit SELinux configuration file:

```bash
vi /etc/selinux/config
```

Locate:

```bash
SELINUX=
```

Modify to:

```bash
SELINUX=disabled
```

Save and exit the file.

---

### Step 4: Confirm Configuration Change

Verify configuration:

```bash
cat /etc/selinux/config
```

Expected output:

```bash
SELINUX=disabled
```



---



## Key Learning Outcomes

* Understanding SELinux architecture and policy packages
* Managing SELinux persistent configuration
* Differentiating runtime vs boot-time SELinux states
* Applying secure infrastructure configuration workflows

