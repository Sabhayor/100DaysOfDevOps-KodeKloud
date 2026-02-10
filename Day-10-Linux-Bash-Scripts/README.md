
# Day 10 – Linux Bash Script (Website Backup Automation)

## Task Objective

The production support team of xFusionCorp Industries is working on developing some bash scripts to automate different day to day tasks. One is to create a bash script for taking websites backup. They have a static website running on App Server 2 in Stratos Datacenter, and they need to create a bash script named news_backup.sh which should accomplish the following tasks. (Also remember to place the script under /scripts directory on App Server 2).



a. Create a zip archive named xfusioncorp_news.zip of /var/www/html/news directory.


b. Save the archive in /backup/ on App Server 2. This is a temporary storage, as backups from this location will be clean on weekly basis. Therefore, we also need to save this backup archive on Nautilus Backup Server.


c. Copy the created archive to Nautilus Backup Server server in /backup/ location.


d. Please make sure script won't ask for password while copying the archive file. Additionally, the respective server user (for example, tony in case of App Server 1) must be able to run it.


e. Do not use sudo inside the script.

Note:
The zip package must be installed on given App Server before executing the script. This package is essential for creating the zip archive of the website files. Install it manually outside the script.


## Step 1 - Login to App Server 2
```bash
ssh steve@stapp02
````

(*Use correct lab username if different*)

Verify:

```bash
hostname
```

---

## Step 2 - Install zip Package (Manual Requirement)

```bash
sudo yum install zip -y
```

Verify:

```bash
zip -v
```

---

## Step 3 - Prepare Required Directories

```bash
sudo mkdir -p /scripts
sudo mkdir -p /backup
sudo chown -R steve:steve /scripts /backup
```

---

## Step 4 - Configure Password-less SSH (Requirement d)

Generate SSH key:

```bash
ssh-keygen -t rsa
```

Press Enter for defaults.

Copy key to Nautilus Backup Server:

```bash
ssh-copy-id steve@stbkp01
```

Test:

```bash
ssh steve@stbkp01
```

Should login without password.

---

## Step 5 - Create Script (Requirements a–c & e)

```bash
vi /scripts/news_backup.sh
```

### Script Content

```bash
#!/bin/bash

SOURCE_DIR="/var/www/html/news"
BACKUP_DIR="/backup"
ARCHIVE_NAME="xfusioncorp_news.zip"
REMOTE_USER="clint"
REMOTE_SERVER="stbkp01"
REMOTE_DIR="/backup"

# a. Create zip archive
zip -r ${BACKUP_DIR}/${ARCHIVE_NAME} ${SOURCE_DIR}

# c. Copy archive to backup server
scp ${BACKUP_DIR}/${ARCHIVE_NAME} ${REMOTE_USER}@${REMOTE_SERVER}:${REMOTE_DIR}
```

 No sudo used inside script.

---

## Step 6 - Make Script Executable

```bash
chmod +x /scripts/news_backup.sh
```

Verify:

```bash
ls -l /scripts
```

Expected:

```
-rwxr-xr-x news_backup.sh
```

---

## Step 7 - Execute Script

```bash
/scripts/news_backup.sh
```

---

## Step 8 - Verification

### Local Backup Check

```bash
ls -l /backup
```

Expected:

```
xfusioncorp_news.zip
```

---

### Remote Backup Check

```bash
ssh steve@nautilus_backup_server
ls -l /backup
```

Expected:

```
xfusioncorp_news.zip
```

---

## Outcome

Implemented an automated website backup workflow using Linux bash scripting, SSH authentication, and secure file transfer - reflecting real-world DevOps backup and disaster recovery practices.

