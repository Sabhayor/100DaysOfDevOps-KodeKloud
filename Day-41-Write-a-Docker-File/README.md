# Day 41 - Write a Dockerfile

For this task, the goal is to create a custom Docker image for the Nautilus application using a **Dockerfile** on **App Server 3** in the Stratos Datacenter. The image must use **Ubuntu 24.04** as its base and run **Apache on port 3002** without modifying other Apache configurations.

## Step 1: Log into App Server 3
```bash
ssh banner@stapp03
```

## Step 2: Create the Dockerfile

Navigate to the required directory and create the Dockerfile (note the capital **D**):

```bash
sudo vi /opt/docker/Dockerfile
```

## Step 3: Add the Required Configuration

Paste the following into the Dockerfile:

```Dockerfile
FROM ubuntu:24.04

RUN apt-get update && apt-get install -y apache2

RUN sed -i 's/80/3002/g' /etc/apache2/ports.conf

EXPOSE 3002

CMD ["apachectl", "-D", "FOREGROUND"]
```

## Explanation

* **FROM ubuntu:24.04** - Sets the base image.
* **apt-get install apache2** - Installs Apache web server.
* **sed command** - Changes Apache listening port from **80** to **3002** in `ports.conf` without modifying other settings.
* **EXPOSE 3002** - Documents the container port.
* **CMD** - Runs Apache in the foreground so the container stays alive.

## Step 4: Build the Image

Run the build command from the Dockerfile directory:

```bash
cd /opt/docker
docker build -t nautilus-apache:1.0 .
```

## Step 5: Verify the Image

```bash
docker images
```

You should see the newly built **nautilus-apache:1.0** image.

---

## Key Learnings

- Dockerfiles define the instructions for building custom images
- Base images provide the foundation for custom containers
- Apache listening ports can be changed without altering other configurations
- Docker images must run services in the foreground
- `docker build` creates reusable images from Dockerfiles
