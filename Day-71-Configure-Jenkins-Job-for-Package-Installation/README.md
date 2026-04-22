# Day 71 - Configure Jenkins Job for Package Installation

## Task/Problem Statement

Some new requirements have come up to install and configure some packages on the Nautilus infrastructure under Stratos Datacenter. The Nautilus DevOps team installed and configured a new Jenkins server so they wanted to create a Jenkins job to automate this task. Find below more details and complete the task accordingly:


1. Access the Jenkins UI by clicking on the Jenkins button in the top bar. Log in using the credentials: username admin and password Adm!n321.


2. Create a new Jenkins job named `install-packages` and configure it with the following specifications:


    Add a string parameter named `PACKAGE`.

    Configure the job to install a package specified in the `$PACKAGE` parameter on the storage server (Stratos Datacenter).


    Build the job at least once (e.g. with parameter `PACKAGE=vim-enhanced`) so the package is installed on the Storage server and can be verified.


Note:

Ensure to install any required plugins and restart the Jenkins service if necessary. Opt for Restart Jenkins when installation is complete and no jobs are running on the plugin installation/update page. Refresh the UI page if needed after restarting the service.

---

##  Task Summary

In this task, we automated package installation on the **Nautilus Storage Server** using a parameterized Jenkins job. The goal was to dynamically install any package by passing its name at runtime, ensuring repeatability and operational efficiency in a production-like environment.


## Solution Overview

### 1. Access Jenkins

* Open Jenkins UI from the top bar
* Login with:

  * **Username:** `admin`
  * **Password:** `Adm!n321`



### 2. Create Jenkins Job

* Click **New Item** → Enter name: `install-packages`
* Select **Freestyle Project**


### 3. Configure Parameters

* Enable **This project is parameterized**
* Add **String Parameter**:

  * **Name:** `PACKAGE`
  * **Description:** Package to install



### 4. Configure Build Step

* Add **Execute shell** build step
* Use the following script:

```bash
ssh natasha@ststor01 << EOF
sudo yum install -y $PACKAGE
EOF
```

> Ensure SSH access is pre-configured between Jenkins and the storage server.



### 5. Install Required Plugins

* Install plugins like:

  * SSH Agent Plugin
* Restart Jenkins if prompted


### 6. Build & Verify

* Click **Build with Parameters**
* Example:

  ```
  PACKAGE=vim-enhanced
  ```
* Verify installation on storage server:

```bash
rpm -qa | grep vim-enhanced
```

### 7. Ensure Reliability

* Re-run the job multiple times
* Confirm:

  * No failures
  * Idempotent behavior (safe re-installation)

---

## Error Encountered

Running the build failed because SSH access was not pre-configured between Jenkins and the storage server.


To configure **SSH access between Jenkins and the storage server**, you need passwordless authentication (SSH key-based login). This is critical for non-interactive Jenkins jobs.

Here’s the exact process:

### Step-by-Step: Configure SSH Access

#### 1. Switch to Jenkins User

On the Jenkins server:

```bash
sudo su - jenkins
```

#### 2. Generate SSH Key Pair

```bash
ssh-keygen -t rsa -b 2048
```

* Press **Enter** for default path
* Leave passphrase empty (important for automation)

This creates:

* Private key → `~/.ssh/id_rsa`
* Public key → `~/.ssh/id_rsa.pub`

---

#### 3. Copy Public Key to Storage Server

```bash
ssh-copy-id natasha@ststor01
```
i.e
```
ssh-copy-id -i /var/lib/jenkins/.ssh/id_rsa.pub natasha@ststor01
```

* Enter password once (e.g., `natasha` password)
* This appends the key to:

  ```
  /home/natasha/.ssh/authorized_keys
  ```

#### 4. Test Passwordless SSH

```bash
ssh natasha@ststor01
```
 Expected: Logs in **without asking for password**

---

##  Key Takeaways

* Learned how to create **parameterized Jenkins jobs**
* Automated remote package installation via **SSH**
* Improved operational efficiency using **CI/CD principles**
* Ensured **repeatability and reliability** in automation workflows

