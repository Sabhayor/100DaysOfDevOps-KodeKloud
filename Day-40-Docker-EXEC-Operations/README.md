# Day 40: Docker EXEC Operations

## Task
A **kkloud container** is already running on **App Server 3** in the Stratos Datacenter. The objective is to install and configure **Apache2** inside the running container using `docker exec`, change its listening port to **6000**, and ensure the service is running while the container remains active.

---

## Step 1: SSH into App Server 3
First, log in to the target server where the container is running.

```bash
ssh banner@stapp03
```

---

## Step 2: Verify the Running Container

Confirm that the **kkloud** container is running.

```bash
docker ps
```

You should see a container named **kkloud** in the list.

---

## Step 3: Install Apache2 Inside the Container

Use `docker exec` to run commands inside the container.

```bash
docker exec -it kkloud apt update
docker exec -it kkloud apt install -y apache2
```

This installs Apache inside the running container without stopping or rebuilding it.

---

## Step 4: Change Apache Port to 6000

Modify Apache’s port configuration.

```bash
docker exec -it kkloud sed -i 's/80/6000/g' /etc/apache2/ports.conf
docker exec -it kkloud sed -i 's/*:80/*:6000/g' /etc/apache2/sites-available/000-default.conf
```

This ensures Apache listens on **port 6000** instead of **port 80**.

---

## Step 5: Start Apache Service

Start the Apache service inside the container.

```bash
docker exec -it kkloud service apache2 start
```

---

## Step 6: Verify Apache is Running

Confirm Apache is running and listening on port **6000**.

```bash
docker exec -it kkloud service apache2 status
docker exec -it kkloud ss -tulnp | grep 6000
```

---

## Validation

* Apache2 installed successfully.
* Apache configured to listen on **port 6000**.
* Service running inside the container.
* Container **kkloud** remains in a running state.

---

## Key Concept

`docker exec` allows you to execute commands inside a **running container**, which is useful for **live troubleshooting, patching, or quick configuration updates** without rebuilding the image.

```bash
docker exec -it <container-name> <command>
```

Example:

```bash
docker exec -it kkloud bash
```

---

## Outcome

Apache is successfully installed and configured to run on **port 6000** inside the **kkloud container**, with the container remaining operational.