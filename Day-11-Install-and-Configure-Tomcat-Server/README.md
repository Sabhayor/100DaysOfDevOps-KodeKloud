# Day 11 - Install and Configure Tomcat Server

## Task Objective
Deploy a Java application using **Apache Tomcat** on **App Server 3** with the following requirements:

- Install Tomcat
- Configure Tomcat to run on **port 3004**
- Deploy `ROOT.war` from Jump Host `/tmp`
- Validate application using:

```
  curl http://stapp03:3004
```

## Implementation Steps

### 1️. SSH into App Server 3

```bash
ssh banner@stapp03
sudo -i
```

---

### 2️. Install Tomcat

```bash
yum install tomcat -y
```

*(Use `apt install tomcat9 -y` if Debian/Ubuntu-based)*

---

### 3️. Configure Tomcat Port

Edit Tomcat server configuration:

```bash
vi /usr/share/tomcat/conf/server.xml
```

Find default connector:

```xml
<Connector port="8080" protocol="HTTP/1.1" ... />
```

Change port to:

```xml
<Connector port="3004" protocol="HTTP/1.1" ... />
```

Save and exit.

---

### 4️. Copy ROOT.war from Jump Host

From Jump Host:

```bash
scp /tmp/ROOT.war banner@stapp03:/tmp
```

Move WAR file into Tomcat webapps directory:

```bash
mv /tmp/ROOT.war /usr/share/tomcat/webapps/
```

---

### 5️. Start and Enable Tomcat

```bash
systemctl enable tomcat
systemctl start tomcat
systemctl status tomcat
```

---

### 6️. Verify Deployment

Test from Jump Host:

```bash
curl http://stapp03:3004
```

Expected: Application webpage output.

---

## Validation Checklist

* Tomcat installed successfully
* Port updated to **3004**
* `ROOT.war` deployed to `webapps`
* Tomcat service running
* Application accessible via base URL

---

## Production Relevance

* Custom port configuration avoids service conflicts
* WAR deployment mirrors standard Java CI/CD workflows
* Service validation ensures application availability
* Aligns with real-world application server provisioning practices





