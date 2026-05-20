# Day 91 - Deploy Apache Web Server and Manage Web Content with Ansible lineinfile

## Problem Statement

The Nautilus DevOps team want to install and set up a simple httpd web server on all app servers in Stratos DC. They also want to deploy a sample web page using Ansible. Therefore, write the required playbook to complete this task as per details mentioned below.

We already have an inventory file under `/home/thor/ansible` directory on jump host. Write a playbook `playbook.yml` under `/home/thor/ansible` directory on jump host itself. Using the playbook perform below given tasks:

Install httpd web server on all app servers, and make sure its service is up and running.

Create a file `/var/www/html/index.html` with content:

```
This is a Nautilus sample file, created using Ansible!
```

Using lineinfile Ansible module add some more content in `/var/www/html/index.html` file. Below is the content:

```
Welcome to xFusionCorp Industries!
Also make sure this new line is added at the top of the file.
```

The `/var/www/html/index.html` file's user and group owner should be apache on all app servers.

The `/var/www/html/index.html` file's permissions should be 0644 on all app servers.

Note: Validation will try to run the playbook using command `ansible-playbook -i inventory playbook.yml` so please make sure the playbook works this way without passing any extra arguments.

## Task Summary:

* Install and start `httpd`
* Create `/var/www/html/index.html`
* Add a new line at the top using `lineinfile`
* Set correct ownership and permissions

## Solution Walkthrough

### 1. Navigate to the Ansible Directory

```bash
cd /home/thor/ansible
```

### 2. Create the Playbook

```yaml
---
- name: Configure Apache web server
  hosts: app_servers
  become: yes

  tasks:

    - name: Install httpd package
      yum:
        name: httpd
        state: present

    - name: Ensure httpd service is running
      service:
        name: httpd
        state: started
        enabled: yes

    - name: Create index.html file
      copy:
        dest: /var/www/html/index.html
        content: |
          This is a Nautilus sample file, created using Ansible!
        owner: apache
        group: apache
        mode: '0644'

    - name: Add welcome line at the top of index.html
      lineinfile:
        path: /var/www/html/index.html
        line: Welcome to xFusionCorp Industries!
        insertbefore: BOF

    - name: Set correct ownership and permissions
      file:
        path: /var/www/html/index.html
        owner: apache
        group: apache
        mode: '0644'
```

### 3. Run the Playbook

Execute the playbook using the provided inventory file:

```bash
ansible-playbook -i inventory playbook.yml
```

---

## Expected Result

After execution:

* Apache web server is installed and running on all app servers.
* `/var/www/html/index.html` is created successfully.
* The welcome message is inserted at the beginning of the file using `lineinfile`.
* File ownership is set to `apache:apache`.
* File permissions are configured as `0644`.

![Kodekloud terminal](./images/kodekloud%20terminal.png)