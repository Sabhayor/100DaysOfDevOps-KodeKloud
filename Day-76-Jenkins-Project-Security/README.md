# Day 76 - Jenkins Project Security (Resolving Job-Level Access Control)

## Problem Statement

The xFusionCorp Industries has recruited some new developers. There are already some existing jobs on Jenkins and two of these new developers need permissions to access those jobs. The development team has already shared those requirements with the DevOps team, so as per details mentioned below grant required permissions to the developers.



Click on the Jenkins button on the top bar to access the Jenkins UI. Login using username admin and password Adm!n321.


There is an existing Jenkins job named Packages, there are also two existing Jenkins users named sam with password sam@pass12345 and rohan with password rohan@pass12345.


Grant permissions to these users to access Packages job as per details mentioned below:


a.) Make sure to select Inherit permissions from parent ACL under inheritance strategy for granting permissions to these users.


b.) Grant mentioned permissions to sam user : build, configure and read.


c.) Grant mentioned permissions to rohan user : build, cancel, configure, read, update and tag.


Note:


Please do not modify/alter any other existing job configuration.


You might need to install some plugins and restart Jenkins service. So, we recommend clicking on Restart Jenkins when installation is complete and no jobs are running on plugin installation/update page i.e update centre. Also Jenkins UI sometimes gets stuck when Jenkins service restarts in the back end. In this case, please make sure to refresh the UI page.

---


## Task Summary
This task focuses on implementing **job-level access control in Jenkins** by granting specific permissions to developers on an existing job (`Packages`). This mirrors real-world production scenarios where access must be tightly scoped to avoid unintended changes across shared CI/CD pipelines.

---

## Objective
Assign permissions as follows:

- **sam** → build, configure, read  
- **rohan** → build, cancel, configure, read, update, tag  

Ensure:
- Permissions **inherit from parent ACL**
- No other job configurations are modified

---

## Issue Encountered
After installing both:
- Matrix Authorization Strategy  
- Role-Based Authorization Strategy  

…and restarting Jenkins, the option:

> **“Enable project-based security”**

was **missing** from:
- `Dashboard → Packages → Configure`



---

## Root Cause
The issue occurred because **Role-Based Authorization Strategy was enabled** under global security.

In Jenkins:
- When **Role-Based Strategy** is active → **job-level security configuration is hidden**
- The **“Enable project-based security”** option is only available when using:
  - **Project-based Matrix Authorization Strategy**

---

## Resolution

### 1. Switch Authorization Strategy
- Navigate to:
  - **Manage Jenkins → Configure Global Security**
- Under **Authorization**, change from:
  -  Role-Based Authorization Strategy  
  - OR  Matrix-based security  
- To:
  -  **Project-based Matrix Authorization Strategy**

- Save configuration

---

### 2. Access Job Configuration
- Go to:
  - **Dashboard → Packages → Configure**

Now the option becomes visible:
-  **Enable project-based security**

---

### 3. Configure Job-Level Security
- Tick:
  - **Enable project-based security**
- Set:
  - **Inheritance Strategy → Inherit permissions from parent ACL**

---

### 4. Assign Permissions

#### User: `sam`
Grant:
- Read  
- Build  
- Configure  

#### User: `rohan`
Grant:
-  Read  
-  Build  
-  Cancel  
-  Configure  
-  Update  
-  Tag  

![Project based security](./images/Project-based%20security.png)
---

### 5. Save Configuration
- Click **Save**
- Ensure no other job settings are altered

---

## Validation

- Login as `sam`:
  - Can view, configure, and trigger builds
- Login as `rohan`:
  - Can fully manage builds including canceling and tagging

![Kodekloud terminal](./images/kodekloud%20terminal.png)
---

## Key Takeaways
- **Authorization strategy directly impacts UI capabilities** in Jenkins  
- **Project-based Matrix Authorization** is required for job-level permission control  
- Installing multiple plugins can introduce **configuration conflicts if not properly selected**  
- Always verify the active security model before troubleshooting UI issues  

---

## Outcome
Successfully implemented **granular, job-level access control** by resolving a strategy misconfiguration and applying the correct authorization model. This reflects real-world DevOps practices where secure, role-based access is critical to maintaining CI/CD pipeline integrity.
