# Day 6: Create a Cron Job

## Task Overview
The Nautilus system admins team wants to test automated task scheduling on all app servers in the Stratos Datacenter before deploying production scripts.  

This task focuses on:
- Installing the **cronie** package
- Starting the **crond** service
- Creating a scheduled cron job for the root user

---

## Objectives
1. Install `cronie` on all Nautilus app servers.
2. Start and enable the `crond` service.
3. Configure the following cron job for the root user:

```

*/5 * * * * echo hello > /tmp/cron_text

````

---

## Target Servers
Typical Stratos app servers:
- `stapp01`
- `stapp02`
- `stapp03`

---

## Step 1 – Connect to App Servers
From the jump host, connect to the servers and switch to root

```bash
sudo -i
```

---

## Step 2 – Install Cronie Package

For RHEL/CentOS/Rocky-based systems:

```bash
yum install -y cronie
```

OR

```bash
dnf install -y cronie
```

Verify installation:

```bash
rpm -qa | grep cronie
```

---

## Step 3 – Start and Enable Cron Service

```bash
systemctl start crond
systemctl enable crond
```

Check service status:

```bash
systemctl status crond
```

---

## Step 4 – Add Cron Job for Root User

Edit root crontab:

```bash
crontab -e
```

Add the following line:

```bash
*/5 * * * * echo hello > /tmp/cron_text
```

Save and exit.

---

## Step 5 – Verify Cron Job

Check cron entries:

```bash
crontab -l
```

---

## Step 6 – Validate Execution

Wait about 5 minutes, then verify:

```bash
cat /tmp/cron_text
```

Expected output:

```
hello
```

Check cron logs if needed:

```bash
grep CRON /var/log/cron
```
Repeat for the other two servers: stapps02 and stapp03.

---

## Final Validation Checklist

* [ ] cronie installed on all app servers
* [ ] crond service running
* [ ] crond service enabled
* [ ] cron job added to root crontab
* [ ] `/tmp/cron_text` created successfully

---

## Key Commands

```bash
ssh root@stapp01
yum install -y cronie
dnf install -y cronie
systemctl start crond
systemctl enable crond
systemctl status crond
crontab -e
crontab -l
cat /tmp/cron_text
grep CRON /var/log/cron
```

