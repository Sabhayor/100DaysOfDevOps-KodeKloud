
# Day 4 - KodeKloud 100 Days of DevOps  
## Script Execution Permissions


## Task Overview
As part of backup automation at **xFusionCorp Industries**, the sysadmin team deployed a Bash script named:

```
/tmp/xfusioncorp.sh
````

However, the script lacked proper execution permissions on **App Server 1** in the Stratos Datacenter, preventing automation tasks from running.

The goal is to ensure the script is executable by all users using proper Linux permission practices.

---

## Requirements
- Script Location: `/tmp/xfusioncorp.sh`
- Server: App Server 1 (`stapp01`)
- Permission Requirement: Executable by **all users**
- Validation: Script must have standard executable permissions

---

## Step-by-Step Walkthrough

### Step 1: SSH into App Server 1
From the jump server or provided terminal:

```bash
ssh tony@stapp01
````

Verify correct server:

```bash
hostname
```

Expected:

```
stapp01
```

---

### Step 2: Verify Script Presence

Confirm the script exists and inspect permissions:

```bash
ls -l /tmp/xfusioncorp.sh
```

Example output:

```bash
-rw-r--r-- 1 root root 200 Feb 4 10:00 /tmp/xfusioncorp.sh
```

Observation: No executable (`x`) permission.

---

### Step 3: Grant Execution Permission

Initial attempt to allow execution:

```bash
chmod a+x /tmp/xfusioncorp.sh
```

This adds execution permission for:

* Owner
* Group
* Others

---

### Step 4: Verify Permissions

```bash
ls -l /tmp/xfusioncorp.sh
```

Output observed:

```bash
---x--x--x
```

Although executable, validation still failed.

---

## Error Encountered & Resolution

### Error Message

```
script is not executable on App Server 1
```

### Investigation

Permission check revealed:

```bash
---x--x--x
```

Issues identified:

* Script lacked read permissions
* Non-standard execution-only permission model
* Validator expected standard executable script configuration

### Resolution Applied

Updated permissions to:

```bash
chmod 755 /tmp/xfusioncorp.sh
```
```bash
ls -l /tmp/xfusioncorp.sh
```

Final permission state:

```bash
-rwxr-xr-x
```

Validation passed successfully.

---


## Key Takeaway

* Use `chmod 755` for shared automation scripts
* Always verify permissions with `ls -l`
* Confirm correct server using `hostname`
* Avoid execute-only scripts in production environments
* Standard permission structures improve automation reliability

