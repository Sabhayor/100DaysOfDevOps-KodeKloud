# Day 75 - Jenkins Slave Nodes (SSH Agents)

## Problem Statement
The Nautilus DevOps team has installed and configured new Jenkins server in Stratos DC which they will use for CI/CD and for some automation tasks. There is a requirement to add all app servers as slave nodes in Jenkins so that they can perform tasks on these servers using Jenkins. Find below more details and accomplish the task accordingly.

Click on the Jenkins button on the top bar to access the Jenkins UI. Login using username admin and password Adm!n321.

1. Add all app servers as SSH build agent/slave nodes in Jenkins. Slave node name for app server 1, app server 2 and app server 3 must be App_server_1, App_server_2, App_server_3 respectively.

2. Add labels as below:


        App_server_1 : stapp01

        App_server_2 : stapp02

        App_server_3 : stapp03


3. Remote root directory for App_server_1 must be `/home/tony/jenkins`, for App_server_2 must be `/home/steve/jenkins` and for App_server_3 must be `/home/banner/jenkins`.


4. Make sure slave nodes are online and working properly.


Note:

1. You might need to install some plugins and restart Jenkins service. So, we recommend clicking on Restart Jenkins when installation is complete and no jobs are running on plugin installation/update page i.e update centre. Also, Jenkins UI sometimes gets stuck when Jenkins service restarts in the back end. In this case, please make sure to refresh the UI page.

---

## Overview
This task focuses on configuring Jenkins in a distributed architecture by adding multiple app servers as SSH-based agent (slave) nodes. In production environments, this setup enables workload distribution, improves scalability, and isolates execution from the controller.

---

## Objective
- Configure 3 app servers as Jenkins SSH agents
- Assign labels for targeted job execution
- Set correct remote root directories
- Ensure all nodes are online and operational

---

## Environment Details
- Jenkins Login: `admin / Adm!n321`
- App Servers:
  - `stapp01` → App_server_1
  - `stapp02` → App_server_2
  - `stapp03` → App_server_3

---

## Implementation Steps

### 1. Install Required Plugin
Navigate to:
**Manage Jenkins → Manage Plugins**

Install:
- SSH Build Agents Plugin

Restart Jenkins after installation.

---

### 2. Add Agent Nodes

Go to:
**Manage Jenkins → Manage Nodes → New Node**

---

### App_server_1 Configuration
- Name: `App_server_1`
- Type: Permanent Agent

**Settings:**
- Remote root directory: `/home/tony/jenkins`
- Labels: `stapp01`
- Launch method: Launch agent via SSH
  - Host: `stapp01`
  - Credentials: Configured SSH credentials
  - Host Key Verification: Non-verifying (lab setup)

---

### App_server_2 Configuration
- Name: `App_server_2`
- Remote root: `/home/steve/jenkins`
- Label: `stapp02`
- Host: `stapp02`

---

### App_server_3 Configuration
- Name: `App_server_3`
- Remote root: `/home/banner/jenkins`
- Label: `stapp03`
- Host: `stapp03`

---

## Issues Encountered & Resolutions

### Critical Failure: Agent Launch Error (Java Mismatch)

**Error from logs:**
```
java.lang.UnsupportedClassVersionError:
hudson/remoting/Launcher has been compiled by a more recent version
(class file version 61.0), this runtime only recognizes up to 55.0
```


**Root Cause:**
- Jenkins controller uses **Java 17 (class version 61)**
- Agent node (`stapp01`) was running **Java 11 (class version 55)**
- Jenkins remoting requires Java 17 → incompatibility caused agent failure

---

### Resolution

#### Step 1: Verify Java Version
```bash
java -version
```

#### Step 2: Install Java 17
```
sudo yum install java-17-openjdk -y
```

#### Step 3: Set Java 17 as Default
```
sudo alternatives --config java
```

#### Step 4: Reconnect Agent
- Return to Jenkins
- Relaunch node

**To avoid repeated failures, Java 17 was also installed on `stapp02`
and `stapp03`**


## Outcome
- All nodes show “Online” in Jenkins
- No remoting or JVM errors
- Test pipeline successfully executes on labeled nodes


![Agent running](./images/Agent%20running.png)
![Kodekloud terminal](./images/Kodekloud%20terminal.png)

## Key Takeaways
- Distributed Jenkins architecture is essential for production-grade CI/CD
- SSH agents depend heavily on runtime compatibility (Java versions)
- `UnsupportedClassVersionError` is a clear indicator of JVM mismatch
- Proactively standardizing runtime environments prevents cascading failures
- Labels provide precise workload targeting across infrastructure