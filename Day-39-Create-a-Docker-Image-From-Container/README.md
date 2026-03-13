# Day 39: Create a Docker Image From Container

In this task, the goal is to create a new Docker image from an already running container. This mirrors a real-world scenario where a developer tests changes directly inside a container and wants those changes preserved as a reusable image.

## Step 1: Connect to Application Server 3
First, log in to **Application Server 3** where the container is running.

```bash
ssh banner@stapp03
```

## Step 2: Verify the Container

Confirm that the container **ubuntu_latest** is running.

```bash
docker ps
```

Look for the container named `ubuntu_latest` in the output.

## Step 3: Create the Image from the Container

Use the `docker commit` command to create a new image named **apps:nautilus** from the running container.

```bash
docker commit ubuntu_latest apps:nautilus
```

This command snapshots the current state of the container and saves it as a new Docker image.

## Step 4: Verify the Image

Ensure the image was successfully created.

```bash
docker images
```

You should see:

```
REPOSITORY   TAG        IMAGE ID
apps         nautilus   <image-id>
```

## Summary

The `docker commit` command allows you to capture the state of a running container and turn it into a reusable image. This is particularly useful for preserving experimental changes, debugging environments, or creating quick backups during development.
