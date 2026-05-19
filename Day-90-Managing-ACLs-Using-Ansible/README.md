# Day 90 - Managing ACLs Using Ansible

## Problem Statement

There are some files that need to be created on all app servers in Stratos DC. The Nautilus DevOps team want these files to be owned by user root only however, they also want that the app specific user to have a set of permissions on these files. All tasks must be done using Ansible only, so they need to create a playbook. Below you can find more information about the task.

Create a playbook named `playbook.yml` under `/home/thor/ansible` directory on jump host, an inventory file is already present under `/home/thor/ansible` directory on Jump Server itself.

Create an empty file `blog.txt` under `/opt/itadmin/` directory on app server 1. Set some acl properties for this file. Using acl provide read '(r)' permissions to group tony (i.e entity is tony and etype is group).

Create an empty file `story.txt` under `/opt/itadmin/` directory on app server 2. Set some acl properties for this file. Using acl provide read + write '(rw)' permissions to user steve (i.e entity is steve and etype is user).

Create an empty file `media.txt` under `/opt/itadmin/` on app server 3. Set some acl properties for this file. Using acl provide read + write '(rw)' permissions to group banner (i.e entity is banner and etype is group).

Note: Validation will try to run the playbook using command `ansible-playbook -i inventory playbook.yml` so please make sure the playbook works this way, without passing any extra arguments.

---

## Task Summary

The goal is to automate file creation and ACL permission management across multiple app servers using Ansible.

The task required:

* Creating specific files on different app servers.
* Keeping ownership under `root`.
* Granting additional access to specific users/groups using ACLs.
* Automating everything through a single Ansible playbook.

---

## Solution Walkthrough

### Step 1: Navigate to the Ansible Directory

```bash
cd /home/thor/ansible
```

### Step 2: Create the Playbook

Create a file named `playbook.yml`.

```yaml
---
- name: Configure ACLs on App Server 1
  hosts: stapp01
  become: yes

  tasks:
    - name: Create blog.txt file
      file:
        path: /opt/itadmin/blog.txt
        state: touch
        owner: root
        group: root
        mode: '0644'

    - name: Set ACL for group tony
      acl:
        path: /opt/itadmin/blog.txt
        entity: tony
        etype: group
        permissions: r
        state: present


- name: Configure ACLs on App Server 2
  hosts: stapp02
  become: yes

  tasks:
    - name: Create story.txt file
      file:
        path: /opt/itadmin/story.txt
        state: touch
        owner: root
        group: root
        mode: '0644'

    - name: Set ACL for user steve
      acl:
        path: /opt/itadmin/story.txt
        entity: steve
        etype: user
        permissions: rw
        state: present


- name: Configure ACLs on App Server 3
  hosts: stapp03
  become: yes

  tasks:
    - name: Create media.txt file
      file:
        path: /opt/itadmin/media.txt
        state: touch
        owner: root
        group: root
        mode: '0644'

    - name: Set ACL for group banner
      acl:
        path: /opt/itadmin/media.txt
        entity: banner
        etype: group
        permissions: rw
        state: present
```

### Step 3: Run the Playbook

Execute the playbook using the inventory file:

```bash
ansible-playbook -i inventory playbook.yml
```
![kodekloud terminal](./images/Kodekloud%20terminal.png)

### Step 4: Verify ACLs

You can verify the ACL permissions on each server using:

```bash
getfacl /opt/itadmin/blog.txt
getfacl /opt/itadmin/story.txt
getfacl /opt/itadmin/media.txt
```
![ACL Permissions](./images/ACL%20permissions.png)
---

## Key Takeaways

* Use the Ansible `file` module to create files.
* Use the Ansible `acl` module to manage ACL permissions.
* Maintain secure root ownership while granting controlled access to app users/groups.
* ACLs (Access Control Lists) are useful in production environments because they allow fine-grained permissions without changing the primary ownership of files.