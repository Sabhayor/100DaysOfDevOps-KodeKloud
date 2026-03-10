# Day 36 - Deploy Nginx Container on Application Server

## Objective
Deploy an **Nginx container** on **Application Server** for deployment testing. The container must be named **nginx_2**, use the **nginx:alpine** image, and remain in a **running state**.

---

### Step 1: Connect to Application Server
Log in to the second application server from the jump host.

```bash
ssh steve@stapp02
```

---

### Step 2: Verify Docker is Installed

Confirm Docker is available before deploying the container.

```bash
docker --version
```

---

### Step 3: Pull the Required Image

Pull the lightweight Alpine-based Nginx image.

```bash
docker pull nginx:alpine
```

---

### Step 4: Create and Start the Container

Run the container with the required name and image.

```bash
docker run -d -p 80:80 --name nginx_2 nginx:alpine
```

Explanation:

* `-d` → Runs the container in detached mode.
* `-p 80:80` → Exposed container port 80 to host port 80
* `--name nginx_2` → Assigns the required container name.
* `nginx:alpine` → Uses the specified lightweight Nginx image.

---

### Step 5: Verify the Container Status

Ensure the container is running.

```bash
docker ps
```

Expected output should show:

```
CONTAINER ID   IMAGE           NAME
xxxxx          nginx:alpine    nginx_2
```

---

### Result

The **nginx_2 container** is successfully deployed on **Application Server 2** using the **nginx:alpine image** and is running as required.

---

### Key Learnings
- Containers can be started directly using docker run
- -d runs the container in detached mode
- --name assigns a custom name to the container
- Port mapping (-p 80:80) maps host port 80 to container port 80, allowing access to the containerized service from outside
- Lightweight images like nginx:alpine are suitable for fast deployments
- docker ps is used to verify running containers

