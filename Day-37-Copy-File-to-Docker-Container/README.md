# Day 37 - Copy File to Docker Container

### Task
The Nautilus DevOps team has an encrypted file on **App Server 3** located at:

```
/tmp/nautilus.txt.gpg
```

A Docker container named **ubuntu_latest** is running on the same host. The goal is to **copy this file into the container at `/tmp/` without modifying it**.

---

## Steps to Complete the Task

### 1. SSH into App Server 3
```bash
ssh banner@stapp03
```

---

### 2. Verify the File Exists on the Host

```bash
ls -l /tmp/nautilus.txt.gpg
```

---

### 3. Confirm the Container is Running

```bash
docker ps
```

Ensure the container **ubuntu_latest** appears in the list.

---

### 4. Copy the File to the Container

Use the `docker cp` command:

```bash
docker cp /tmp/nautilus.txt.gpg ubuntu_latest:/tmp/
```

**Syntax Explanation**

```
docker cp <source_path_on_host> <container_name>:<destination_path_in_container>
```

This command copies the file directly into the container **without altering its contents**.

---

### 5. Verify the File Inside the Container

```bash
docker exec ubuntu_latest ls -l /tmp/
```

You should see:

```
nautilus.txt.gpg
```

---

### Result

The encrypted file **/tmp/nautilus.txt.gpg** is successfully copied from the Docker host into the **ubuntu_latest** container at `/tmp/`, preserving the file exactly as required.

![docker-copy](./images/docker%20cp.png)
---

### Key Learnings
- docker cp is used to copy files between the host and a running container
- Containers do not need to be stopped to copy files into them
- docker exec allows command execution inside a running container
- Docker supports secure file transfer without altering file contents
- docker cp preserves file content but does not preserve file ownership from the host
- Files copied using docker cp become owned by the container user (usually root)
- docker cp works in both directions (host → container and container → host)
- File paths inside the container must already exist for the copy to succeed