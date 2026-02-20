# Day 18 – Configure LAMP Server

## Task
xFusionCorp Industries plans to host a WordPress-based application on Nautilus infrastructure. The storage layer is already configured, with a shared directory mounted on all application servers. The task is to complete the application and database setup required for a LAMP stack and verify database connectivity through the load balancer.

## Objective
Provision a production-ready LAMP stack across Nautilus infrastructure and validate database connectivity through the Load Balancer (LBR).

Architecture Components:
- App Servers: Apache + PHP
- DB Server: MariaDB
- Shared Storage: Pre-configured and mounted
- Access Layer: Load Balancer (LBR)

Requirement details:

* App Servers: Install Apache, PHP, and required PHP extensions
* Apache port: 8087
* Database Server: MariaDB
* Database name: kodekloud_db7
* Database user: kodekloud_gem
* User password: B4zNgHA7Ya
* Access validation: Application reachable via LBR and confirms DB connectivity

---

## Step 1: Install LAMP Packages on All App Servers

SSH into each app server:  
Log into App Server 1 and install appache, php and its dependencies.
```
ssh tony@stapp01
```

```bash
sudo yum install -y httpd php php-mysqlnd php-cli php-common
````

Verify PHP module:

```bash
php -m | grep mysqli
```

Enable and start Apache:

```bash
sudo systemctl enable httpd
sudo systemctl start httpd
```

---

## Step 2: Configure Apache to Listen on Port 8087

Edit:

```bash
sudo vi /etc/httpd/conf/httpd.conf
```

Modify:

```
Listen 8087
```

Restart Apache:

```bash
sudo systemctl restart httpd
```

Verify:

```bash
sudo systemctl status httpd
sudo ss -tulnp | grep httpd
ss -tulnp | grep 8087
```
Exit App Server 1

```
exit
```
Repeat the same steps (Apache + PHP installation and port configuration) on App Server 2 and App Server 3

---

## Step 3: Configure MariaDB on DB Server

SSH into DB server and install MariaDB:

```bash
ssh peter@stdb01
```

```bash
sudo yum install -y mariadb-server
sudo systemctl enable mariadb
sudo systemctl start mariadb
```

Login to MariaDB:

```bash
sudo mysql
```
OR
```bash
mysql -u root -p
```

Create application database
```bash
CREATE DATABASE kodekloud_db7;
```

Create database user with password
```bash
CREATE USER 'kodekloud_gem'@'%' IDENTIFIED BY 'B4zNgHA7Ya';
```

Grant full privileges on database to user
```bash
GRANT ALL PRIVILEGES ON kodekloud_db7.* TO 'kodekloud_gem'@'%';
```

Apply privilege changes
```bash
FLUSH PRIVILEGES;
```

Verify user grants
```bash
SHOW GRANTS FOR 'kodekloud_gem'@'%';
```
Exit MariaDB
```bash
EXIT;
```

## Production Relevance

This setup reflects a standard horizontally scaled LAMP architecture:

* Shared storage for consistency
* Dedicated DB tier
* Load-balanced application layer

You now have a fully functional multi-tier LAMP deployment validated end-to-end.