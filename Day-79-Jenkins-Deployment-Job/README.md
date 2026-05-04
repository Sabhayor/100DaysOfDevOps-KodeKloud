# Day 79 - Jenkins Deployment Job

## Problem Statement

The Nautilus development team had a meeting with the DevOps team where they discussed automating the deployment of one of their apps using Jenkins (the one in Stratos Datacenter). They want to auto deploy the new changes in case any developer pushes to the repository. As per the requirements mentioned below configure the required Jenkins job.

Click on the Jenkins button on the top bar to access the Jenkins UI. Login using username admin and Adm!n321 password.

Similarly, you can access the Gitea UI using Gitea button. Username and password for Git are sarah and Sarah_pass123. Under user sarah you will find a repository named web that is already cloned on App Server 1 under sarah's home (/home/sarah/web). sarah is a developer who is working on this repository.

1. httpd is already installed and configured on the app server (listening on port 8080). Ensure the httpd service is running on App Server 1 (e.g. start it manually if needed). You can make starting/restarting httpd part of your Jenkins job if you prefer.

2. Create a Jenkins job named `devops-app-deployment` and configure it so that if anyone pushes any new change to the origin repository in master branch, the job should auto build and deploy the latest code on App Server 1 under /var/www/html directory.
Before deployment, ensure that the ownership of the /var/www/html directory is set to user sarah, so that Jenkins can successfully deploy files to that directory.

3. SSH into App Server 1 using sarah user credentials mentioned above. Under sarah user's home (/home/sarah/web) you will find a cloned Git repository named web. Under this repository there is an index.html file, update its content to Welcome to the xFusionCorp Industries, then push the changes to the origin into master branch. This push must trigger your Jenkins job and the latest changes must be deployed on the server, also make sure it deploys the entire repository content not only index.html file.

Click on the App button on the top bar to access the app. Please make sure the required content is loading on the main URL (e.g. http://stlb01:8091) i.e there should not be any sub-directory like http://stlb01:8091/web etc.

Note:
1. You might need to install some plugins and restart Jenkins service. So, we recommend clicking on Restart Jenkins when installation is complete and no jobs are running on plugin installation/update page i.e update centre. Also some times Jenkins UI gets stuck when Jenkins service restarts in the back end so in such case please make sure to refresh the UI page.

2. Make sure Jenkins job passes even on repetitive runs as validation may try to build the job multiple times.

3. Deployment related tasks should be done by sudo user on the destination server to avoid any permission issues so make sure to configure your Jenkins job accordingly.

---

## Task Summary

The objective of this task is to automate application deployment using Jenkins in a production-like CI/CD workflow.

A Jenkins Freestyle job named `devops-app-deployment` must be configured to automatically detect changes pushed to the `master` branch of the `web` repository in Gitea and deploy the latest code to App Server 1 under `/var/www/html`.

The deployment must ensure:

- `httpd` is running on App Server 1
- Full repository content is deployed (not just `index.html`)
- Ownership of `/var/www/html` is set to user `sarah`
- Jenkins triggers automatically after every Git push
- Deployment happens directly on the root URL (`http://stlb01:8091`)
- The job passes successfully on repeated validation runs

---

## Solution Walkthrough

---

### Step 1: Access Jenkins

Open Jenkins from the top bar and log in using:

---

### Step 2: Verify HTTPD on App Server 1

SSH into App Server 1:

```bash
ssh sarah@stapp01
```

Check and start Apache:

```bash
sudo systemctl status httpd
sudo systemctl start httpd
sudo systemctl enable httpd
```

This ensures Apache is active and serving on port `8080`.

---

### Step 3: Configure Passwordless Sudo for Jenkins Deployment

Since Jenkins runs non-interactively, `sudo` commands must work without password prompts.

SSH into App Server 1 and edit sudoers safely:

```bash
sudo visudo
```

Add this line at the bottom:

```text
sarah ALL=(ALL) NOPASSWD: /bin/systemctl, /bin/chown, /bin/rm
```

This allows Jenkins to:

* start/restart `httpd`
* change ownership
* clean deployment directory

without build failures caused by password prompts.

---

### Step 4: Fix Deployment Directory Ownership

Run:

```bash
sudo chown -R sarah:sarah /var/www/html
```

This prevents Jenkins deployment permission issues.

---

### Step 5: Install Required Jenkins Plugins

Go to:

```text
Manage Jenkins → Plugins
```

Install:

* Git Plugin
* Publish Over SSH Plugin
* SSH Build Plugin

After installation:

```text
Restart Jenkins
```

Refresh the browser if Jenkins UI hangs after restart.

---

### Step 6: Configure SSH Access from Jenkins to App Server

On Jenkins server, generate SSH keys if needed:

```bash
ssh-keygen
```

Copy the public key to App Server 1:

```bash
ssh-copy-id sarah@stapp01
```

Test SSH access:

```bash
ssh sarah@stapp01
```

No password prompt should appear.

---

### Step 7: Create Jenkins Job

Create a new Freestyle project:

```text
Job Name: devops-app-deployment
```

Select:

```text
Freestyle Project
```

---

### Step 8: Configure Source Code Management

Under **Source Code Management**:

Select:

```text
Git
```

Repository URL:

```text
https://<gitea-url>/sarah/web.git
```

Branch:

```text
*/master
```

Add Git credentials:

```text
Username: sarah
Password: Sarah_pass123
```

---

### Step 9: Configure Auto Trigger

Under **Build Triggers**, enable:

```text
Poll SCM
```

Use:

```text
* * * * *
```

This checks for repository changes every minute and ensures automatic deployment after each push.

---

## Step 10: Configure Deployment Build Step

Under:

```text
Build → Execute Shell
```

Use this exact script:

```bash
ssh sarah@stapp01 "sudo systemctl start httpd"

ssh sarah@stapp01 "sudo chown -R sarah:sarah /var/www/html"

ssh sarah@stapp01 "sudo rm -rf /var/www/html/*"

scp -r /var/lib/jenkins/workspace/devops-app-deployment/* \
sarah@stapp01:/var/www/html/
```

### Why This Works

This solves multiple validation issues:

* ensures Apache is running
* prevents permission failures
* removes old files before deployment
* copies the full repository content
* keeps repeated validation runs clean and consistent

`scp` was used instead of `rsync` because `rsync` was not installed on the Jenkins server.

---

## Step 11: Update Application Code

SSH into App Server 1:

```bash
ssh sarah@stapp01
cd /home/sarah/web
```

Edit the application file:

```bash
vi index.html
```

Replace the content with:

```html
Welcome to the xFusionCorp Industries
```

Save and push:

```bash
git add .
git commit -m "index.html updated"
git push origin master
```

This push must automatically trigger Jenkins.

---

## Step 12: Verify Auto Deployment

Go to:

```text
Build History → Latest Build → Console Output
```

Confirm:

* build triggered automatically
* build finishes successfully
* deployment copied files to `/var/www/html`

---

## Step 13: Validate Application

Open:

Click on the App icon at the top right cornner of the terminal.

You should see:

```text
Welcome to the xFusionCorp Industries
```

---

## Errors Encountered and Resolutions

---

### Error 1: sudo Password Prompt Failure

### Error

```text
sudo: a terminal is required to read the password
sudo: a password is required
```

### Cause

Jenkins could not provide interactive input for `sudo`.

### Fix

Configured passwordless sudo using:

```text
sarah ALL=(ALL) NOPASSWD: /bin/systemctl, /bin/chown, /bin/rm

```

for required deployment commands.

---

### Error 2: rsync Not Found

### Error

```text
rsync: not found
```
![Pipeline failure - rsync](./images/pipeline%20failure%20-%20rsync.png)

### Cause

`rsync` was not installed on the Jenkins server.

### Fix

Replaced `rsync --delete` with:

```bash
sudo rm -rf /var/www/html/*
scp -r
```

This preserved clean deployments across repeated builds.

![Pipeline success](./images/pipeline%20success.png)

---

## Error 3: Validation File Not on LB

### Cause

Deployment was either:

* copied to wrong directory
* deployed inside a subfolder
* job was not auto-triggered after Git push

![Kodekloud terminal error](./images/kodekloud%20terminal%20error%20-%20validation%20not%20on%20LB.png)

### Fix

Ensured:

* deployment path was exactly `/var/www/html`
* Poll SCM was enabled
* full repository was copied
* no `/web` subdirectory existed

![kodekloud success](./images/kodekloud%20terminal.png)

---

## Final Outcome

Jenkins now performs continuous deployment successfully:

* detects every Git push to `master`
* pulls latest source code automatically
* deploys the full application to App Server 1
* serves content directly from the load balancer root URL
* passes repeated validation checks reliably

![Before the update](./images/kodekloud%20webpage.png)

![Webpage updated](./images/xfusioncorp%20induries.png)

---

## Takeaways

- **Automation must be production-safe** - deployments should work consistently across repeated runs, not just once.
- **Passwordless sudo is critical for Jenkins deployments** since Jenkins runs non-interactively and cannot respond to password prompts.
- **Correct file permissions matter** - ownership of deployment directories must be properly configured to avoid failed builds.
- **Full repository deployment is required** - copying only a single file like `index.html` is not enough for proper application deployment.
- **Clean deployments prevent validation failures** - removing old files before copying new ones avoids stale content issues.
- **Job triggers are as important as deployment itself** - without SCM polling or webhooks, automation breaks.
- **Deployment path must be exact** - deploying to `/var/www/html` instead of a subdirectory ensures the app loads correctly from the root URL.
- **Troubleshooting Jenkins requires reading console logs carefully** - most failures were resolved by analyzing build output and fixing root causes systematically.

Overall, this task provided strong hands-on experience with Jenkins-based Continuous Deployment (CD), remote server automation, SSH-based deployments, and production-style troubleshooting.
