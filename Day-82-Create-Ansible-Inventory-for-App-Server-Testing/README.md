# Day 82 - Create Ansible Inventory for App Server Testing

## Problem Statement

The Nautilus DevOps team is testing Ansible playbooks on various servers within their stack. They've placed some playbooks under `/home/thor/playbook/` directory on the jump host and now intend to test them on app server 1 in Stratos DC. However, an inventory file needs creation for Ansible to connect to the respective app. Here are the requirements:

a. Create an ini type Ansible inventory file /home/thor/playbook/inventory on jump host.

b. Include App server 1 in this inventory along with necessary variables for proper functionality.


c. Ensure the inventory hostname corresponds to the server name as per the wiki, for example stapp01 for app server 1 in Stratos DC.


Note: Validation will execute the playbook using the command ansible-playbook -i inventory playbook.yml. Ensure the playbook functions properly without any extra arguments.

---

## Task Summary

The Nautilus DevOps team needed to test existing Ansible playbooks stored on the jump host under `/home/thor/playbook/` against **App server 1** in Stratos DC.

To make this possible, an **INI-type Ansible inventory file** had to be created so Ansible could properly connect to the target server during playbook execution.

The validation would run using:

```bash
ansible-playbook -i inventory playbook.yml
```

This means the inventory file needed to contain the correct server hostname and connection variables without requiring extra command-line arguments.

---

## Objective

Create the inventory file:

```bash
/home/thor/playbook/inventory
```

and ensure it includes:

* App server 1 (`stapp01`)
* Required SSH connection variables
* Proper inventory hostname matching the wiki naming standard

---

## Solution Walkthrough

### Step 1: Navigate to the Playbook Directory

Move to the directory containing the Ansible playbooks on the jumbhost server.

```bash
cd /home/thor/playbook
```

---

### Step 2: Create the Inventory File

Create the required inventory file.

```bash
vi inventory
```

Add the following content:

```ini
stapp01 ansible_host=10.244.29.238 ansible_user=tony ansible_ssh_pass=Ir0nM@n ansible_connection=ssh
```

#### Explanation of Variables

* `stapp01` → Required inventory hostname for App server 1
* `ansible_host` → Actual private IP address of the server
* `ansible_user` → SSH username used for login
* `ansible_ssh_pass` → SSH password
* `ansible_connection=ssh` → Specifies SSH as the connection method

This ensures Ansible can run the playbook successfully without needing additional flags.

Save the file and exit the editor.

---


### Step 3: Verify the Inventory

Test connectivity using:

```bash
ansible -i inventory stapp01 -m ping
```

Expected output:

```bash
SUCCESS
```
---

## Final Validation

The platform validates using:

```bash
ansible-playbook -i inventory playbook.yml
```

Since the correct inventory file exists and contains all required connection details, the playbook executes successfully against App server 1.

---

## Outcome

Successfully created an Ansible inventory file for App server 1, enabling seamless playbook testing from the jump host.

This reflects a real production scenario where infrastructure teams manage multiple servers using centralized inventories for automation, consistency, and scalability.

![Playbook](./images/Kodekloud%20terminal.png)

---

## Key Learnings

- To check the IP address of a server, use `cat /etc/hosts`
- To check linux distribution, use `cat /etc/os-release`
- Check connectivity, `ping -c 2 hostname` or `ping -c ipadrs`

