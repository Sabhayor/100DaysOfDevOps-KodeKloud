# Day 16 - Install and Configure Nginx as LBR

## Task
Day by day traffic is increasing on one of the websites managed by the Nautilus production support team. Therefore, the team has observed a degradation in website performance. Following discussions about this issue, the team has decided to deploy this application on a high availability stack i.e on Nautilus infra in Stratos DC. They started the migration last month and it is almost done, as only the LBR server configuration is pending. Configure LBR server as per the information given below: 

a. Install nginx on LBR (load balancer) server.  
b. Configure load-balancing with the an http context making use of all App Servers. Ensure that you update only the main Nginx configuration file located at /etc/nginx/nginx.conf.  
c. Make sure you do not update the apache port that is already defined in the apache configuration on all app servers, also make sure apache service is up and running on all app servers.  
d. Once done, you can access the website using StaticApp button on the top bar.

## Objective
Deploy **Nginx** as a Load Balancer on the LBR server to distribute traffic across all App Servers without modifying existing Apache configurations.

This ensures **high availability, scalability, and improved performance** in a production environment.

---

## Step 1: Install Nginx on LBR

SSH into the **LBR server** and install nginx:

```
sudo yum install nginx -y
````


Start and enable the service:

```
sudo systemctl enable nginx
sudo systemctl start nginx
```
Verify:

```
sudo systemctl status nginx
```

---

## Step 2: Ensure Apache is Running on App Servers

SSH into **stapp01, stapp02, and stapp03** and verify:

```
sudo systemctl status httpd
```

If not running:

```bash
sudo systemctl start httpd
sudo systemctl enable httpd
```

 Do NOT change the Apache port (keep default port 5003).

---

## Step 3: Modify `/etc/nginx/nginx.conf`

On the LBR server:

```
sudo vi /etc/nginx/nginx.conf
```



```nginx
# For more information on configuration, see:
#   * Official English Documentation: http://nginx.org/en/docs/

user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

# Load dynamic modules
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 4096;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    # Load Balancer Configuration
    upstream appservers {
        server stapp01:5003;
        server stapp02:5003;
        server stapp03:5003;
    }

    server {
        listen 80;

        location / {
            proxy_pass http://appservers;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }
}
```

---

## Step 4: Test and Restart Nginx

Test configuration:

```bash
sudo nginx -t
```

If successful:

```bash
sudo systemctl restart nginx
```

---

## Step 5: Validate

* Click **StaticApp** button (top bar)
* Refresh multiple times
* From the LBR server, run:
```
curl http://stapp01:5003
curl http://stapp02:5003
curl http://stapp03:5003
```
* Traffic should be distributed across:

  * stapp01
  * stapp02
  * stapp03

---

## Final Result

Nginx is now successfully configured as a **Load Balancer**, distributing traffic across all three Apache backend servers without modifying their existing port configuration.


