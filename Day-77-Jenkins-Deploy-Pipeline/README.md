# Day 77 - Jenkins Deploy Pipeline (Static Web App Deployment)

## Problem Statement

The development team of xFusionCorp Industries is working on to develop a new static website and they are planning to deploy the same on Nautilus App Server using Jenkins pipeline. They have shared their requirements with the DevOps team and accordingly we need to create a Jenkins pipeline job. Please find below more details about the task:

Click on the Jenkins button on the top bar to access the Jenkins UI. Login using username admin and password Adm!n321.

Similarly, click on the Gitea button on the top bar to access the Gitea UI. Login using username sarah and password Sarah_pass123. There under user sarah you will find a repository named web_app that is already cloned on App Server 1 under /var/www/html. sarah is a developer who is working on this repository.

Add a slave node named App Server 1. It should be labeled as stapp01 and its remote root directory should be /home/sarah/jenkins_agent (the repository is cloned under /var/www/html; the agent uses a separate directory so it does not pollute the repo).

We have already cloned repository on App Server 1 under /var/www/html.

Apache is already installed on the app server and is running on port 8080.

Create a Jenkins pipeline job named devops-webapp-job (it must not be a Multibranch pipeline) and configure it to:

Deploy the code from web_app repository under /var/www/html on App Server 1, as this is the document root of the app server. The pipeline should have a single stage named Deploy ( which is case sensitive ) to accomplish the deployment.

LB server is already configured. You should be able to see the latest changes you made by clicking on the App button. Please make sure the required content is loading on the main URL https://<LBR-URL> i.e there should not be a sub-directory like https://<LBR-URL>/web_app etc.

Note:

You might need to install some plugins and restart Jenkins service. So, we recommend clicking on Restart Jenkins when installation is complete and no jobs are running on plugin installation/update page i.e update centre. Also, Jenkins UI sometimes gets stuck when Jenkins service restarts in the back end. In this case, please make sure to refresh the UI page.

---

## Task Summary

This task focuses on creating a **Jenkins Declarative Pipeline** to deploy a static website on **Nautilus App Server 1** using a Jenkins agent node.

The goal is to automate deployment from the existing Git repository (`web_app`) to the Apache document root so that the latest code changes are reflected immediately on the Load Balancer URL.

This simulates a real-world CI/CD deployment workflow where Jenkins manages deployments to remote application servers using SSH-based agents.

---

## Environment Overview

* **Jenkins Controller** → manages the pipeline
* **Jenkins Agent (Slave Node)** → App Server 1
* **Agent Label** → `stapp01`
* **Remote Root Directory** → `/home/sarah/jenkins_agent`
* **Source Control** → Gitea repository under user `sarah`
* **Deployment Path** → `/var/www/html`
* **Web Server** → Apache running on port `8080`
* **Access Endpoint** → Load Balancer URL

---

## Implementation Steps

### Step 1: Access Jenkins and Gitea

Log into Jenkins and Gitea using the credential provided

---

### Step 2: Install Required Plugins

Navigate to:

```
Manage Jenkins → Plugins → Available Plugins
```

Install:

* Pipeline
* Git
* SSH Build Agents

> Note: Installing only the regular SSH plugin will not provide the “Launch agent via SSH” option.

After installation:

* Restart Jenkins
* Refresh the browser if the UI becomes unresponsive

---

### Step 3: Configure Jenkins Agent Node

Navigate to:

```
Manage Jenkins → Manage Nodes → New Node
```

Configure:

| Setting               | Value                     |
| --------------------- | ------------------------- |
| Name                  | App Server 1              |
| Type                  | Permanent Agent           |
| Labels                | stapp01                   |
| Remote Root Directory | /home/sarah/jenkins_agent |
| Launch Method         | Launch agents via SSH     |
| Host                  | stapp01                   |
| Credentials           | sarah SSH credentials     |

#### Host Key Verification Strategy

Use:

```
Non verifying Verification Strategy
```

This avoids known_hosts verification issues inside the lab environment.

---

### Step 4: Resolve Java Version Requirement

The Jenkins agent initially failed because the remote server was using Java 11 while Jenkins required Java 17.

Install Java 17:

```text
sudo yum install java-17-openjdk -y
```

This allows the Jenkins remoting agent to start successfully.

---

### Step 5: Verify Actual Repository Location

Initially, it appeared the repository should be deployed from:

```text
/var/www/html/web_app
```

However, verification showed that the Git repository was already cloned directly inside:

```text
/var/www/html
```

This changed the deployment strategy completely.

Instead of copying files, deployment should simply pull the latest code:

```bash
git pull
```

---

### Step 6: Configure Passwordless sudo for Git

Since Jenkins runs non-interactively, `sudo` commands requiring passwords will fail.

SSH into App Server 1:

```bash
ssh sarah@stapp01
```

Edit sudoers safely:

```bash
sudo visudo
```

Add:

```text
sarah ALL=(ALL) NOPASSWD: /usr/bin/git
```

This allows Jenkins to execute `sudo git pull` without password prompts.

---

### Step 7: Create Jenkins Pipeline Job

Create:

```text
New Item → Pipeline
```

### Job Name

```text
devops-webapp-job
```

> Must NOT be a Multibranch Pipeline

---

### Step 8: Configure Pipeline Script

Use this Declarative Pipeline:

```groovy
pipeline {
    agent { label 'stapp01' }

    stages {
        stage('Deploy') {
            steps {
                sh '''
                cd /var/www/html
                sudo git pull origin master
                '''
            }
        }
    }
}
```

### Why this works

Because the repository is already cloned directly inside `/var/www/html`, the correct deployment process is simply updating the working tree using Git.

This is cleaner and more production-relevant than copying files manually.

---

### Step 9: Validate Deployment

Run the pipeline and verify:

```text
Finished: SUCCESS
```

Then click the **App** button and confirm:

* Website loads successfully
* Latest changes are visible
* No subdirectory exists like `/web_app`
* Main URL loads directly


---

## Issues Encountered and Resolutions

### Issue 1: “Launch agent via SSH” Option Missing

### Problem

Even after installing plugins, the SSH launch method was not available.

### Root Cause

Installed the regular **SSH plugin** instead of **SSH Build Agents plugin**

### Resolution

Installed:

```text
SSH Build Agents Plugin
```

Restarted Jenkins and the option appeared.

---

### Issue 2: Agent Offline - known_hosts Error

### Error

```text
No Known Hosts file was found at /var/lib/jenkins/.ssh/known_hosts
```

### Root Cause

Jenkins was using strict host verification without a known_hosts file.

### Resolution

Changed:

```
Known hosts verification
```

to:

```
Non verifying Verification Strategy
```

This allowed SSH connection to proceed.

---

### Issue 3: Agent Failed with Java Version Error

### Error

```
UnsupportedClassVersionError class file version 61.0 only recognizes up to 55.0
```

![Java version error](./images/java%20version%20error.png)

### Root Cause

Jenkins required Java 17, but App Server 1 was using Java 11.

### Resolution

Install Java 17:

```text
sudo yum install java-17-openjdk -y
```

Agent came online successfully.

---

### Issue 4: Deployment Path Assumption Was Wrong

### Problem

Pipeline failed while copying from:

```text
/var/www/html/web_app/*
```

### Root Cause

There was no `web_app` subdirectory. The repository was already cloned directly inside `/var/www/html`.

### Resolution

Switched deployment strategy from file copy to:

```bash
sudo git pull origin master
```

This matched the actual environment.


---

### Issue 5: sudo Failed Inside Pipeline

### Error

```text
sudo: a terminal is required to read the password
```
![Pipeline error](./images/Pipeline%20error.png)

### Root Cause

Jenkins cannot provide passwords for interactive sudo prompts.

### Resolution

Added passwordless sudo rule:

```text
sarah ALL=(ALL) NOPASSWD: /usr/bin/git
```

This allowed non-interactive deployment successfully.

![Pipeline success](./images/Pipeline%20success.png)
---

## Key Takeaways

* Always verify the real deployment path before building the pipeline
* Jenkins agent setup often fails due to plugin mismatch, Java version issues, or SSH verification
* Non-interactive environments require controlled passwordless sudo
* Using `git pull` is often cleaner than manual file copy deployments
* Label-based agents ensure jobs run on the correct infrastructure

This task mirrors real production troubleshooting where deployment failures are often caused by environment assumptions rather than pipeline syntax.
