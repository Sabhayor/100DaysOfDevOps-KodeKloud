# Day 15 – Setup SSL for Nginx  

## Task
The system admins team of xFusionCorp Industries needs to deploy a new application on App Server 2 in Stratos Datacenter. They have some pre-requites to get ready that server for application deployment. Prepare the server as per requirements shared below: 

1. Install and configure nginx on App Server 2. 
2. On App Server 2 there is a self signed SSL certificate and key present at location /tmp/nautilus.crt and /tmp/nautilus.key. Move them to some appropriate location and deploy the same in Nginx. 
3. Create an index.html file with content Welcome! under Nginx document root. 
4. For final testing try to access the App Server 2 link (either hostname or IP) from jump host using curl command. For example curl -Ik https://<app-server-ip>/.

## Objective
Prepare **App Server 2** for application deployment by:
- Installing and configuring Nginx
- Deploying a self-signed SSL certificate
- Creating a test web page
- Verifying HTTPS connectivity from the jump host

---

## Step 1: Install and Start Nginx

SSH into **App Server 2** and install Nginx.

### On CentOS/RHEL:
```bash
sudo yum install -y nginx
````

Start and enable the service:

```bash
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl status nginx
```

---

## Step 2: Move SSL Certificate and Key

The certificate and key are located at:

```
/tmp/nautilus.crt
/tmp/nautilus.key
```

Move them to a secure and standard directory:

```bash
sudo mkdir -p /etc/nginx/ssl
sudo mv /tmp/nautilus.crt /etc/nginx/ssl/
sudo mv /tmp/nautilus.key /etc/nginx/ssl/
sudo chmod 600 /etc/nginx/ssl/nautilus.key
```

---

## Step 3: Configure Nginx for SSL

Edit the Nginx configuration file:

Modify the default server block file (recommended):

```bash
sudo vi /etc/nginx/conf.d/default.conf
```

Add or modify the server block to enable HTTPS:

```nginx
server {
    listen 443 ssl;
    server_name _;

    ssl_certificate     /etc/nginx/ssl/nautilus.crt;
    ssl_certificate_key /etc/nginx/ssl/nautilus.key;

    root /usr/share/nginx/html;
    index index.html;
}
```

Test configuration:

```bash
sudo nginx -t
```

Reload Nginx:

```bash
sudo systemctl reload nginx
```

---

## Step 4: Create Test Web Page

Create the `index.html` file:

```bash
echo "Welcome!" | sudo tee /usr/share/nginx/html/index.html
```

Ensure correct permissions:

```bash
sudo chmod 644 /usr/share/nginx/html/index.html
```

---

## Step 5: Final Testing from Jump Host

From the **jump host**, verify HTTPS access:

```bash
curl -Ik https://<app-server-ip>/
```

Expected output:

* `HTTP/1.1 200 OK`
* `Server: nginx`
* SSL handshake success

Since it is a self-signed certificate, you may use:

```bash
curl -Ik --insecure https://<app-server-ip>/
```

---

## Validation Checklist

* [ ] Nginx installed and running
* [ ] SSL certificate moved to `/etc/nginx/ssl`
* [ ] HTTPS server block configured
* [ ] `index.html` created with content **Welcome!**
* [ ] HTTPS response confirmed via curl

---

## Production Relevance

This task reinforces core production skills:

* Secure web server configuration
* SSL/TLS deployment
* Service validation and troubleshooting
* Infrastructure hardening best practices

Setting up HTTPS correctly is foundational for secure application delivery in real-world environments.
