# Day 09 - MariaDB Troubleshooting - Fixing MariaDB Service Failure

## Task Overview
A critical production issue occurred where the **Nautilus application** could not connect to its database.  
Investigation revealed that the **MariaDB service was down** on the database server (`stdb01`) in the Stratos Datacenter.

The objective was to:

- Diagnose why MariaDB failed to start
- Restore the database service
- Ensure the application could reconnect successfully

---

## Error Encountered

When attempting to start MariaDB:

```bash
sudo systemctl start mariadb
````

The following error occurred:

```
Job for mariadb.service failed because the control process exited with error code.
```

Checking service status revealed the root cause:

```bash
sudo systemctl status mariadb.service -l --no-pager
```

Error snippet:

```
mariadb-prepare-db-dir: Make sure the /var/lib/mysql is empty
ExecStartPre ... status=1/FAILURE
```

Later checks showed:

```bash
ls -la /var/lib/mysql
```

Result:

```
No such file or directory
```

The MariaDB **data directory was missing**, preventing the service from initializing.

---

## Root Cause Analysis

MariaDB relies on `/var/lib/mysql` as its **datadir**.
Since the directory did not exist:

* systemd pre-start scripts failed
* database initialization could not proceed
* the service exited before startup

---

## Resolution Steps

### 1. Recreate MariaDB Data Directory

```bash
sudo mkdir -p /var/lib/mysql
```

---

### 2. Apply Correct Ownership

```bash
sudo chown -R mysql:mysql /var/lib/mysql
```

---

### 3. Set Proper Permissions

```bash
sudo chmod 755 /var/lib/mysql
```

Verify:

```bash
ls -ld /var/lib/mysql
```

Expected output:

```
drwxr-xr-x mysql mysql
```

---

### 4. Initialize Database System Tables

```bash
sudo mariadb-install-db --user=mysql --datadir=/var/lib/mysql
```

Alternative command if unavailable:

```bash
sudo mysql_install_db --user=mysql --ldata=/var/lib/mysql
```

---

### 5. Reload Systemd

```bash
sudo systemctl daemon-reexec
```

---

### 6. Start MariaDB Service

```bash
sudo systemctl start mariadb
```

---

### 7. Verify Service Status

```bash
sudo systemctl status mariadb
```

Expected:

```
active (running)
```

---

### 8. Confirm Database Port Listening

```bash
sudo ss -tulnp | grep 3306
```

---

## Result

* MariaDB service successfully restored
* Database port (3306) active
* Nautilus application regained database connectivity

---

## Key Lessons Learned

* Always check **systemd logs** for root cause, not just service errors
* Missing or corrupted **datadir** prevents MariaDB initialization
* Proper directory ownership is critical (`mysql:mysql`)
* Initialization of system tables is mandatory for new datadirs

---

## Production Insight

In real production environments:

* Never delete database directories without verified backups
* Investigate InnoDB files before reinitialization
* Use monitoring tools (Prometheus, Alertmanager) for early detection
* Implement automated health checks and service recovery


