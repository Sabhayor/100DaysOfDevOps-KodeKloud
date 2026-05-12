# Day 84 - Copy Data to App Servers using Ansible

## Problem Statement

The Nautilus DevOps team needs to copy data from the jump host to all application servers in Stratos DC using Ansible. Execute the task with the following details:

a. Create an inventory file /home/thor/ansible/inventory on jump_host and add all application servers as managed nodes.

b. Create a playbook /home/thor/ansible/playbook.yml on the jump host to copy the /usr/src/data/index.html file to all application servers, placing it at /opt/data.

Note: Validation will run the playbook using the command ansible-playbook -i inventory playbook.yml. Ensure the playbook functions properly without any extra arguments.

--- 

## Task Summary

The Nautilus DevOps team needed to copy data from the jump host to all application servers in Stratos DC using Ansible.

The objective was to:

- Create an inventory file at `/home/thor/ansible/inventory`
- Add all application servers as managed nodes
- Create a playbook at `/home/thor/ansible/playbook.yml`
- Copy `/usr/src/data/index.html` from the jump host
- Place the file in `/opt/data/index.html` on all application servers

Validation runs using:

```bash
ansible-playbook -i inventory playbook.yml
```

This means the playbook must work without extra arguments like `-k` or `--ask-pass`, so SSH access needed to be configured properly beforehand.

---

## Solution Walkthrough

### Step 1: Navigate to the Working Directory

```bash
cd /home/thor/ansible
```

### Step 2: Generate SSH Key on Jump Host

Generate an SSH key pair:

```bash
ssh-keygen
```
Press `Enter` through the prompts to use the default location:

```text
/home/thor/.ssh/id_rsa
```

This creates:

* Private key → `~/.ssh/id_rsa`
* Public key → `~/.ssh/id_rsa.pub`

### Step 3: Copy SSH Key to Application Servers

Copy the public key to each app server using the correct remote users:

```bash
ssh-copy-id tony@stapp01
ssh-copy-id steve@stapp02
ssh-copy-id banner@stapp03
```

Enter the password once for each server.

After this, passwordless SSH access is enabled.

You can verify using:

```bash
ssh tony@stapp01
ssh steve@stapp02
ssh banner@stapp03
```

If login works without asking for a password, the setup is correct.

### Step 4: Create the Inventory File

Create the inventory file:

```bash
sudo vi inventory
```

Add:

```ini

stapp01 ansible_user=tony ansible_host=10.244.234.213
stapp02 ansible_user=steve ansible_host=10.244.164.41
stapp03 ansible_user=banner ansible_host=10.244.240.158
```

Since SSH keys are already configured, there is no need to store passwords in the inventory.


### Step 5: Create the Playbook

Create the playbook:

```bash
sudo vi playbook.yml
```

Add:

```yaml
---
- name: Copy data to application servers
  hosts: app_servers
  become: yes

  tasks:
    - name: Copy index.html to all app servers
      copy:
        src: /usr/src/data/index.html
        dest: /opt/data/index.html
        owner: root
        group: root
        mode: '0644'
```

#### Why `become: yes` Was Required

The destination path `/opt/data` requires elevated privileges.

Since validation uses:

```bash
ansible-playbook -i inventory playbook.yml
```

without `--become`, privilege escalation must be handled inside the playbook using:

```yaml
become: yes
```

This ensures Ansible can write to protected directories successfully.

### Step 6: Run the Playbook

Execute:

```bash
ansible-playbook -i inventory playbook.yml
```

## Error Encountered

When the playbook was first executed, Ansible failed with:

```bash
fatal: [stapp01]: UNREACHABLE!
Permission denied (publickey,gssapi-keyex,gssapi-with-mic,password)
```

This happened because Ansible was trying to connect from the jump host without valid SSH authentication to the application servers.

Although the correct remote users (`tony`, `steve`, and `banner`) were identified, password authentication would require exposing credentials inside the inventory file, which is not ideal.

![Permission error](./images/permission%20error.png)
---

### Resolution

Instead of storing passwords in the inventory, SSH key-based authentication was configured using `ssh-keygen` and `ssh-copy-id`.

This allowed passwordless and secure access from the jump host to all application servers, which also ensured the validation command worked without requiring additional arguments.

![Kodekloud terminal](./images/kodekloud%20terminal.png)

---

## Final Outcome

Successfully configured Ansible to securely copy files from the jump host to all application servers using SSH key-based authentication instead of plain-text passwords.

This reflects real production practices where secure automation and passwordless access are preferred for infrastructure management.
