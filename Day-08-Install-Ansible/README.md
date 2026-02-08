# Day 08 — Install Ansible (v4.10.0) Using pip3

## Task Overview
During a Nautilus DevOps team planning session, Ansible was selected as the preferred automation and configuration management tool due to its simplicity and minimal prerequisites.  

The **Jump Host** is designated as the **Ansible controller** for testing automation tasks across other servers.

---

## Objective
- Install **Ansible version 4.10.0** on the **Jump Host**
- Use **pip3 only** for installation
- Ensure the **Ansible binary is globally accessible** so all users can execute Ansible commands

---


```bash
python3 --version
pip3 --version
````

If pip3 is missing:

```bash
# RHEL/CentOS
sudo yum install python3-pip -y

# Ubuntu/Debian
sudo apt install python3-pip -y
```

---

## Installation Steps

### 1. Install Ansible v4.10.0

Install globally using pip3:

```bash
sudo pip3 install ansible==4.10.0
```

> Using `sudo` ensures system-wide installation so all users can run Ansible.

---

### 2. Verify Installation

Check installed version:

```bash
ansible --version
```

Expected output should show:

```
ansible [core ...]
ansible 4.10.0
```

---

### 3. Ensure Global Binary Access

Confirm ansible binary location:

```bash
which ansible
```

Typical location:

```
/usr/local/bin/ansible
```

Verify PATH contains `/usr/local/bin`:

```bash
echo $PATH
```

If missing:

```bash
echo 'export PATH=$PATH:/usr/local/bin' | sudo tee /etc/profile.d/ansible.sh
source /etc/profile
```

---

### 4️. Validate Multi-User Access

Switch to another user:

```bash
su - username
ansible --version
```

If the command executes successfully → global access confirmed.

---

## Validation Checklist

* [ ] Python3 and pip3 installed
* [ ] Ansible 4.10.0 installed via pip3
* [ ] ansible command works system-wide
* [ ] Multiple users can run ansible

---

## Key Concepts

* **Ansible Controller**: Central system that runs playbooks and automation tasks
* **pip3 Installation**: Ensures version control independent of OS package manager
* **Global PATH**: Allows executables to be accessible by all users

---

## Outcome

The Jump Host is successfully configured as an Ansible controller with:

* Ansible version **4.10.0**
* System-wide binary access
* Ready for automation testing across infrastructure
