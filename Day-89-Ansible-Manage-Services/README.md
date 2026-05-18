# Day 89 - Ansible Manage Services (Install and Manage VSFTPD)

## Problem Statement

Developers are looking for dependencies to be installed and run on Nautilus app servers in Stratos DC. They have shared some requirements with the DevOps team. Because we are now managing packages installation and services management using Ansible, some playbooks need to be created and tested. As per details mentioned below please complete the task:

a. On jump host create an Ansible playbook `/home/thor/ansible/playbook.yml` and configure it to install vsftpd on all app servers.

b. After installation make sure to start and enable `vsftpd` service on all app servers.

c. The inventory `/home/thor/ansible/inventory` is already there on jump host.

d. Make sure user thor should be able to run the playbook on jump host.

Note: Validation will try to run playbook using command `ansible-playbook -i inventory playbook.yml` so please make sure playbook works this way, without passing any extra arguments.

---

## Task Summary

This task focuses on using Ansible for package installation and service management across multiple application servers in the Nautilus environment.

The goal is to create an Ansible playbook that installs **vsftpd** (Very Secure FTP Daemon) on all app servers, then ensures the service is started and enabled so it persists after reboot.

The inventory file is already available at:

`/home/thor/ansible/inventory`

The playbook must be created as:

`/home/thor/ansible/playbook.yml`

Validation will run using:

```bash
ansible-playbook -i inventory playbook.yml
```
---

## Solution Walkthrough

### Step 1: Move to the Ansible working directory and create the Playbook

```bash
cd /home/thor/ansible
sudo vi playbook.yml
```

Add the following content:

```yaml
- name: Install and manage vsftpd service
  hosts: all
  become: yes

  tasks:
    - name: Install vsftpd package
      yum:
        name: vsftpd
        state: present

    - name: Start and enable vsftpd service
      service:
        name: vsftpd
        state: started
        enabled: yes
```
Save and exit.

### Step 2: Verify Inventory File

Confirm the inventory file exists:

```bash
cat inventory
```

Since the task states it is already provided, no modification is required unless verification is needed.


### Step 3: Run the Playbook

Execute the playbook exactly as validation expects:

```bash
ansible-playbook -i inventory playbook.yml
```

This will:

* Install `vsftpd` on all app servers
* Start the service immediately
* Enable it to start automatically after reboot


### Step 4: Verify Service using Ansible:

```bash
ansible all -i inventory -a "systemctl is-active vsftpd"
```
![Kodekloud terminal](./images/kodekloud%20terminal.png)



