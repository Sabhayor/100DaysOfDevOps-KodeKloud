# Day 86 - Ansible Ping Module Usage

## Problem Statement

The Nautilus DevOps team is planning to test several Ansible playbooks on different app servers in Stratos DC. Before that, some pre-requisites must be met. Essentially, the team needs to set up a password-less SSH connection between Ansible controller and Ansible managed nodes. One of the tickets is assigned to you; please complete the task as per details mentioned below:

a. Jump host is our Ansible controller, and we are going to run Ansible playbooks through thor user from jump host.

b. There is an inventory file `/home/thor/ansible/inventory` on jump host. Using that inventory file test Ansible ping from jump host to App Server 2, make sure ping works.

---

## Task Summary

The goal of this task is to verify connectivity between the Ansible controller (Jump Host) and App Server 2 using the Ansible `ping` module.

Before running playbooks in production, Ansible requires password-less SSH access from the controller node to managed nodes. In this task, the `thor` user on the jump host acts as the Ansible controller, and the provided inventory file is used to test communication with App Server 2.

The objective is to ensure that Ansible can successfully connect and return a `pong` response from App Server 2.

---

## Solution Walkthrough

### Step 1: Verify the Inventory File

Check the existing inventory file

```bash
cat /home/thor/ansible/inventory
```

This file contains the managed node details including App Server 2.


### Step 2: Generate SSH Key

To enable password-less SSH authentication, generate an SSH key:

```bash
ssh-keygen
```

Press Enter through the prompts to use default settings.


### Step 3: Copy SSH Key to App Server 2

Transfer the public key to App Server 2:

```bash
ssh-copy-id steve@stapp02
```

Enter the remote user password when prompted.

This allows future SSH access without a password.

### Step 4: Test Direct SSH Access

Confirm password-less login works:

```bash
ssh steve@stapp02
```

If login succeeds without a password prompt, SSH setup is complete.

Exit the server:

```bash
exit
```

### Step 5: Run Ansible Ping Module

Use the inventory file to test connectivity with App Server 2:

```bash
ansible stapp02 -i /home/thor/ansible/inventory -m ping
```

#### Expected Output

Successful output should look like this:

```bash
stapp02 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

This confirms Ansible can successfully communicate with App Server 2.

---

## Error Encountered

While testing the Ansible `ping` module, the command returned:

```bash
stapp02 | UNREACHABLE! => {
    "changed": false,
    "msg": "Invalid/incorrect password: Permission denied, please try again.",
    "unreachable": true
}
```

### Root Cause

The issue was caused because `ansible_user` was missing from the inventory file.

Without `ansible_user`, Ansible attempted to connect using the wrong default SSH user, which resulted in authentication failure.

### Resolution

I updated the inventory file by explicitly defining the correct remote user for App Server 2:

```ini
stapp02 ansible_host=10.244.49.89 ansible_user=steve
```

After adding `ansible_user`, Ansible was able to authenticate correctly using the right SSH user.

Running the ping test again:

```bash
ansible stapp02 -i /home/thor/ansible/inventory -m ping
```

returned:

```bash
stapp02 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```
![Kodekloud terminal](./images/Kodekloud%20terminal.png)

This confirmed successful password-less SSH access and proper Ansible connectivity.


## Key Takeaway

The Ansible `ping` module is used to validate SSH connectivity and Python availability on managed nodes before running automation tasks. This is a critical first step in production environments to ensure playbooks execute without connection issues.
