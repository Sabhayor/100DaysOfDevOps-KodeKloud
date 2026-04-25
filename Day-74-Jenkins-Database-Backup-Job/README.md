# Day 74: Jenkins Database Backup Job

## Problem Statement

There is a requirement to create a Jenkins job to automate the database backup. Below you can find more details to accomplish this task:

Click on the Jenkins button on the top bar to access the Jenkins UI. Login using username admin and password Adm!n321.

Create a Jenkins job named `database-backup`.

Configure it to take a database dump of the `kodekloud_db01` database present on the App server (stapp01) in Stratos Datacenter, the database user is `kodekloud_roy` and password is `asdfgdsd`.

The dump should be named in `db_$(date +%F).sql` format, where date `+%F` is the current date.

Copy the `db_$(date +%F).sql` dump to the Storage server (ststor01) under location `/home/natasha/db_backups`.

Further, schedule this job to run periodically at `*/10 * * * *` (please use this exact schedule format).

---

## Task Summary

This task focuses on automating database backups using Jenkins by dumping a MySQL database from the application server (`stapp01`) and securely transferring it to a storage server (`ststor01`) on a scheduled basis.

---

## Implementation Steps

### 1. Access Jenkins

* Open Jenkins UI from the top bar
* Login:

  * **Username:** `admin`
  * **Password:** `Adm!n321`

---

### 2. Create Jenkins Job

* Click **New Item**
* Name: `database-backup`
* Select **Freestyle Project**
* Click **OK**

---

### 3. Configure SSH Access (Required for Automation)

#### Step 3.1: Switch to Jenkins User

```bash
sudo su - jenkins
```

#### Step 3.2: Generate SSH Key

```bash
ssh-keygen -t rsa -b 2048
```

* Press Enter for defaults
* Leave passphrase empty

---

#### Step 3.3: Copy Key to Target Servers

```bash
ssh-copy-id tony@stapp01
ssh-copy-id natasha@ststor01
```

---

#### Step 3.4: Verify Access

```bash
ssh tony@stapp01
ssh natasha@ststor01
```

* Both should connect without password prompt

---

### 4. Configure Build Step

Add **Execute Shell**:

```bash
# Variables
DATE=$(date +%F)
DB_NAME="kodekloud_db01"
DB_USER="kodekloud_roy"
DB_PASS="asdfgdsd"
DUMP_FILE="db_${DATE}.sql"

# Run dump on app server
ssh tony@stapp01 "mysqldump -u ${DB_USER} -p${DB_PASS} ${DB_NAME}" > /tmp/${DUMP_FILE}

# Copy to storage server
scp /tmp/${DUMP_FILE} natasha@ststor01:/home/natasha/db_backups/
```

---

### 5. Schedule the Job

* Go to **Build Triggers**
* Enable **Build periodically**
* Add:

```bash
*/10 * * * *
```

---

## Error Encountered

During the initial build, the job failed with:

```
mysqldump: not found
```

![Console error](./images/Console%20failure.png)

---

## Root Cause Analysis

* Jenkins executed the `mysqldump` command **locally on the Jenkins server**
* The Jenkins host **does not have MySQL client tools installed**
* More importantly, the database resides on **`stapp01`**, not on Jenkins

This is a classic **execution context issue** - the command ran in the wrong environment.

---

## Fix Applied

* Updated the build step to execute `mysqldump` **remotely on `stapp01` via SSH**
* Redirected output back to Jenkins and then transferred it to the storage server

Corrected approach:

```bash
# Run dump on app server
ssh tony@stapp01 "mysqldump -u ${DB_USER} -p${DB_PASS} ${DB_NAME}" > /tmp/${DUMP_FILE}

# Copy to storage server
scp /tmp/${DUMP_FILE} natasha@ststor01:/home/natasha/db_backups/
```

---

## Validation Steps

* Triggered **Build Now**
* Confirmed:

  * `.sql` file created in `/tmp`
  * File successfully copied to:

    ```
    /home/natasha/db_backups
    ```

![Console success](./images/Console%20success.png)

---

## Additional Issues to Watch For

* **SSH Authentication Failure**

  * Fix: Ensure `ssh-copy-id` was executed correctly

* **Permission Denied on Target Directory**

  ```bash
  sudo chown -R natasha:natasha /home/natasha/db_backups
  ```

* **mysqldump Not Found on stapp01**

  * Ensure MySQL client is installed on the app server

---


## Final Outcome

* A Jenkins job named **`database-backup`** is successfully created and configured
* The job:

  * Connects to **`stapp01`** via SSH
  * Executes a **MySQL database dump** of `kodekloud_db01`
  * Generates a file in the format:

    ```
    db_YYYY-MM-DD.sql
    ```
  * Stores the dump temporarily on the Jenkins server (`/tmp`)
  * Transfers the backup securely to:

    ```
    /home/natasha/db_backups on ststor01
    ```

* Application data is backed up remotely
* Backups are centralized on a storage node
* Scheduling ensures consistency and recoverability
* Failures (like wrong execution context) are identified and resolved through log analysis

![Build history](./images/Build%20history.png)
![Kodekloud terminal](./images/Kodekloud%20terminal.png)
---


## Key Takeaways

* Always validate **where commands execute** in distributed systems
* Jenkins acts as an orchestrator, not necessarily the execution host
* SSH-based automation is critical for cross-server workflows
* Proper debugging starts with reading and interpreting build logs


