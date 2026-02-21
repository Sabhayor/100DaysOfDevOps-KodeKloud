# Day 20 - Configure Nginx + PHP-FPM Using Unix Socket

## Task

The Nautilus application development team is planning to launch a new PHP-based application, which they want to deploy on Nautilus infra in Stratos DC. The development team had a meeting with the production support team and they have shared some requirements regarding the infrastructure. Below are the requirements they shared:  

* Install nginx on app server 2 , configure it to use port 8091 and its document root should be /var/www/html.  
* Install php-fpm version 8.3 on app server 2, it must use the unix socket /var/run/php-fpm/default.sock (create the parent directories if don't exist).  
* Configure php-fpm and nginx to work together.  
* Once configured correctly, you can test the website using curl http://stapp02:8091/index.php command from jump host.  

NOTE: We have copied two files, index.php and info.php, under /var/www/html as part of the PHP-based application setup. Please do not modify these files.

---

## Objective

On **App Server 2 (stapp02)**:

- Install Nginx and configure it to listen on **port 8091**

- Set document root to `/var/www/html`

- Install **PHP-FPM 8.3**

- Configure PHP-FPM to use Unix socket: `/var/run/php-fpm/default.sock`

- Integrate Nginx with PHP-FPM

- Validate using: ``curl http://stapp02:8091/index.php``

### Step 1: Install Nginx
```bash
sudo yum install -y nginx
```
Edit Nginx configuration:
```
sudo vi /etc/nginx/nginx.conf
```

Update server block:

```bash
server {
    listen 8091;
    server_name stapp02;

    root /var/www/html;
    index index.php index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass unix:/var/run/php-fpm/default.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
}

```
### Step 2: Install PHP-FPM 8.3
Install required repositories to enable PHP 8.3 packages  

Install EPEL repository
```
sudo yum install -y epel-release
```

Install Remi repository
```
sudo yum install -y https://rpms.remirepo.net/enterprise/remi-release-$(rpm -E %rhel).rpm
```
Reset existing PHP module streams
```
sudo yum module reset php -y
```
Enable PHP 8.3 module
```
sudo yum module enable php:remi-8.3 -y
```
Install PHP 8.3 and PHP-FPM
```
sudo yum install -y php php-fpm
```
Verify PHP version
```
php -v
```




### Step 3: Configure PHP-FPM to Use Unix Socket

Edit pool configuration:
```
sudo vi /etc/php-fpm.d/www.conf
```
Modify:
```
listen = /var/run/php-fpm/default.sock
```
Create socket directory if it does not exist:
```
sudo mkdir -p /var/run/php-fpm
```
Set proper ownership:
```
sudo chown -R nginx:nginx /var/run/php-fpm
```
Ensure these values are set:
```
listen.owner = nginx
listen.group = nginx
listen.mode = 0660
```
### Step 4: Start and Enable Services
```
sudo systemctl enable nginx php-fpm
sudo systemctl start nginx php-fpm
```

Verify:
```
sudo systemctl status nginx
sudo systemctl status php-fpm
```

### Step 5: Test from Jump Host
```
curl http://stapp02:8091/index.php
```
If configured correctly, the PHP output should render successfully.

### Key Concepts
Unix Socket vs TCP: Unix sockets provide faster local communication between Nginx and PHP-FPM compared to TCP (127.0.0.1:9000).

**Separation of Concerns:** Nginx handles static content; PHP-FPM processes dynamic PHP requests.

**Production Relevance:** This architecture improves performance, scalability, and security in real-world deployments.
