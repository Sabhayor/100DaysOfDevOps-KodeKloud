# Day 93 - Using Ansible Conditionals with `when` Statements

## Problem Statement

The Nautilus DevOps team had a discussion about, how they can train different team members to use Ansible for different automation tasks. There are numerous ways to perform a particular task using Ansible, but we want to utilize each aspect that Ansible offers. The team wants to utilise Ansible's conditionals to perform the following task:

An inventory file is already placed under `/home/thor/ansible` directory on jump host, with all the Stratos DC app servers included.

Create a playbook `/home/thor/ansible/playbook.yml` and make sure to use Ansible's when conditionals statements to perform the below given tasks.

Copy `blog.txt` file present under `/usr/src/data` directory on jump host to App Server 1 under `/opt/data` directory. Its user and group owner must be user tony and its permissions must be `0655` .

Copy `story.txt` file present under `/usr/src/data` directory on jump host to App Server 2 under `/opt/data` directory. Its user and group owner must be user steve and its permissions must be `0655` .

Copy `media.txt` file present under `/usr/src/data` directory on jump host to App Server 3 under `/opt/data` directory. Its user and group owner must be user banner and its permissions must be `0655`.

NOTE: You can use `ansible_nodename` variable from gathered facts with when condition. Additionally, please make sure you are running the play for all hosts i.e use - `hosts: all`.

Note: Validation will try to run the playbook using command `ansible-playbook -i inventory playbook.yml`, so please make sure the playbook works this way without passing any extra arguments.

## Task Summary

The goal is to use Ansible conditionals to deploy different files to different application servers from a single playbook. The playbook must target all hosts using `hosts: all`, while selectively executing tasks based on each server’s hostname using the `when` condition and the `ansible_nodename` fact.

### Requirements

* Copy `blog.txt` to App Server 1
* Copy `story.txt` to App Server 2
* Copy `media.txt` to App Server 3
* Set:

  * Correct owner and group
  * Permissions to `0655`
* Use:

  * `hosts: all`
  * `when` conditional statements
  * `ansible_nodename` variable

---

## Solution Walkthrough

### 1. Navigate to the Ansible Directory

```bash
cd /home/thor/ansible
```

### 2. Create the Playbook

```bash
sudo vi playbook.yml
```

Add the following configuration:

```yaml
---
- hosts: all
  become: yes
  gather_facts: yes

  tasks:

    - name: Copy blog.txt to App Server 1
      copy:
        src: /usr/src/data/blog.txt
        dest: /opt/data/blog.txt
        owner: tony
        group: tony
        mode: '0655'
      when: ansible_nodename == "stapp01"

    - name: Copy story.txt to App Server 2
      copy:
        src: /usr/src/data/story.txt
        dest: /opt/data/story.txt
        owner: steve
        group: steve
        mode: '0655'
      when: ansible_nodename == "stapp02"

    - name: Copy media.txt to App Server 3
      copy:
        src: /usr/src/data/media.txt
        dest: /opt/data/media.txt
        owner: banner
        group: banner
        mode: '0655'
      when: ansible_nodename == "stapp03"
```


### 3. Run the Playbook

Execute the playbook using the provided inventory file:

```bash
ansible-playbook -i inventory playbook.yml
```

### 4. Verify the Deployment

You can confirm the files were copied correctly by checking each server:

```bash
ansible all -i inventory -a "ls -l /opt/data"
```
![KodeKloud terminal](./images/kodekloud%20terminal.png)

---

## Key Learnings

* Using `when` conditionals in Ansible
* Leveraging gathered facts with `ansible_nodename`
* Running one playbook across multiple hosts with different execution logic
* Managing file ownership and permissions using the `copy` module
* Writing scalable automation workflows for production-style environments
