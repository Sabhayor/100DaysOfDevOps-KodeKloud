# Day 38: Pull Docker Image and Re-Tag

In this task, the goal is to pull a specific Docker image and create a new tag for it on **App Server 3**. This reflects a common production scenario where DevOps teams pull base images from a registry and tag them internally for environment-specific usage or version control.

## Step 1: Connect to App Server 3
Log in to the required server.

```bash
ssh banner@stapp03
```

## Step 2: Pull the Required Docker Image

Pull the **busybox:musl** image from Docker Hub.

```bash
docker pull busybox:musl
```

## Step 3: Re-Tag the Image

Create a new tag **busybox:media** from the existing **busybox:musl** image.

```bash
docker tag busybox:musl busybox:media
```

## Step 4: Verify the New Tag

Confirm the image has been successfully re-tagged.

```bash
docker images
```

You should see both tags referencing the same image ID:

```
busybox   musl
busybox   media
```

---

## Key Learnings

- `docker pull` downloads images from a container registry
- Docker images can have multiple tags pointing to the same image ID
- `docker tag` creates a new reference without duplicating the image
- Re-tagging images is useful for local testing and version management
- Image verification helps confirm successful tagging