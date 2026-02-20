# Day 19 – Install and Configure Web Application  

## Task
xFusionCorp Industries is planning to host two static websites on their infra in Stratos Datacenter. The development of these websites is still in-progress, but we want to get the servers ready. Please perform the following steps to accomplish the task:

* Install httpd package and dependencies on app server 1.  

* Apache should serve on port 3003.

* There are two website's backups /home/thor/blog and /home/thor/demo on jump_host. Set them up on Apache in a way that blog should work on the link http://localhost:3003/blog/ and demo should work on link http://localhost:3003/demo/ on the mentioned app server.  

* Once configured you should be able to access the website using curl command on the respective app server, i.e curl http://localhost:3003/blog/ and curl http://localhost:3003/demo/

## Objective  
Prepare **App Server 1** to host two static websites using Apache (`httpd`) on a custom port (**3003**) and configure them to be accessible at:

- http://localhost:3003/blog/
- http://localhost:3003/demo/

Validation must be done using `curl` on the app server.

---

## Step 1: Install Apache (httpd)

SSH into **App Server 1** and install Apache:

```bash
sudo yum install httpd -y
```

Enable and start the service:

```bash
sudo systemctl enable httpd
sudo systemctl start httpd
```

Verify:

```bash
sudo systemctl status httpd
```

---

## Step 2: Configure Apache to Listen on Port 3003

Edit Apache configuration:

```bash
sudo vi /etc/httpd/conf/httpd.conf
```

Change:

```apache
Listen 80
```

To:

```apache
Listen 3003
```

Allow Apache to serve content on the new port.

---

## Step 3: Copy Website Backups from Jump Host

On **Jump Host**, copy both directories to App Server 1:

```bash
scp -r /home/thor/blog tony@stapp01:/tmp/
scp -r /home/thor/demo user@stapp02:/tmp/
```

On **App Server 1**, move them to Apache document root:

```bash
sudo mv /tmp/blog /var/www/html/
sudo mv /tmp/demo /var/www/html/
```

Set correct ownership and permissions:

```bash
sudo chown -R apache:apache /var/www/html/blog
sudo chown -R apache:apache /var/www/html/demo
sudo chmod -R 755 /var/www/html/
```

---

## Step 4: Restart Apache

```bash
sudo systemctl restart httpd
```

Confirm Apache is listening on port 3003:

```bash
sudo ss -tulnp | grep 3003
```

---

## Step 5: Validate Using curl

On **App Server 1**, test both URLs:

```bash
curl http://localhost:3003/blog/
curl http://localhost:3003/demo/
```

If configured correctly, HTML output for both sites should be displayed.

---

## Final Architecture Outcome

* Apache installed and enabled
* Custom port configured (3003)
* Two static websites deployed under `/var/www/html`
* Successfully validated via `curl`
* Production-style separation of application paths (`/blog` and `/demo`)

---

## Key DevOps Concepts Practiced

* Web server installation & configuration
* Custom port binding
* File transfer between hosts (scp)
* Linux permissions & ownership management
* Service validation and troubleshooting