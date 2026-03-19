# Day 44 – Write a Docker Compose File

## Objective
Deploy a containerized **httpd web server** using Docker Compose to serve static content provided by the Nautilus dev team.

---

## Step 1: Create the Compose File
On **App Server 3**, create the required file:

```bash
sudo mkdir -p /opt/docker
sudo vi /opt/docker/docker-compose.yml
````

---

## Step 2: Define the Docker Compose Configuration

Add the following:

```yaml
version: '3.8'

services:
  web:
    image: httpd:latest
    container_name: httpd
    ports:
      - "3000:80"
    volumes:
      - /opt/data:/usr/local/apache2/htdocs
```

---

## Step 3: Understand the Configuration

* `image: httpd:latest` - Uses the latest Apache HTTP server image
* `container_name: httpd` - Ensures the container name matches requirement
* `ports: 3000:80` - Maps host port `3000` → container port `80`
* `volumes` - Mounts host directory `/opt/data` to serve static content

---

## Step 4: Deploy the Container

Run the following:

```bash
cd /opt/docker
sudo docker compose up -d
```

---

## Step 5: Verify Deployment

Check container status:

```bash
docker ps
```

Test in browser or via curl:

```bash
curl http://localhost:3000
```

---

## Result

The static website is now served via the **httpd container**, with content sourced from `/opt/data` and accessible on port `3000`.

---

## Outcome

This setup mirrors a **production-like deployment pattern**, where infrastructure is defined declaratively using Docker Compose, enabling consistency, portability, and rapid environment provisioning.

## Key Learnings

- Docker Compose is a tool used to define and run multi-container Docker applications using a YAML file
- Docker Compose simplifies container configuration compared to long docker run commands
- Services, networks, and volumes can be managed together in one file
- `docker compose up -d` creates and starts containers defined in the compose file
- `docker compose down` stops and removes containers created by the compose file
- Volumes in Docker Compose are defined under the volumes section of a service
- Volume mounting in Docker Compose works the same as -v in docker run
- Bind mounts allow containers to directly use host directories
- Explicit container naming avoids auto-generated container names
- Docker Compose improves consistency and repeatability across environments
