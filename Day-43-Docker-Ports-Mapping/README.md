# Day 43: Docker Ports Mapping

## Objective
Deploy an Nginx container with proper port mapping to expose the service externally.

---

## Step 1: Pull the Nginx Image
Start by pulling the required alpine-perl Nginx image from Docker Hub:

```bash
docker pull nginx:alpine-perl
```

---

## Step 2: Create and Run the Container

Run a container named `news` from the pulled image and map ports:

```bash
docker run -d --name news -p 5004:80 nginx:alpine-perl
```

### Breakdown:

* `-d` → Run container in detached mode (background)
* `--name news` → Assigns the container name
* `-p 5004:80` → Maps:

  * Host port `5004`
  * → Container port `80` (default Nginx web server port)

---

## Step 3: Verify the Container

Ensure the container is running:

```bash
docker ps
```

You should see the `news` container with port mapping `0.0.0.0:5004->80/tcp`.

---

## Outcome

* Nginx container successfully deployed
* Port `5004` on host mapped to port `80` in container
* Service is accessible externally

