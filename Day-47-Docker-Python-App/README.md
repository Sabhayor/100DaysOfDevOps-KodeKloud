# Day 47 - Dockerize & Deploy Python App

## Task/Requirement

The development team requires a Python application to be containerized and deployed on an application server. The application dependencies are already provided via a requirements.txt file, and the app must be accessible through a mapped host port.

The requirement is to create a Dockerfile, build a Docker image, deploy a container, and verify application access.


## Requirement details:

- Server: Application Server 1 (stapp01)
- Application path: /python_app
- Base image: Any Python image
- App port (container): 3003
- Host port: 8095
- Image name: nautilus/python-app
- Container name: pythonapp_nautilus


---

## Step 1: Create Dockerfile

Create a `Dockerfile` inside `/python_app`:

```Dockerfile
FROM python:3.9-slim

WORKDIR /app

COPY src/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY src/ .

EXPOSE 3003

CMD ["python", "server.py"]
```

---

## Step 2: Build Docker Image

Build the image with the required name:

```bash
docker build -t nautilus/python-app /python_app
```

---

## Step 3: Run Container

Deploy the container with proper port mapping:

```bash
docker run -d \
  --name pythonapp_nautilus \
  -p 8092:3003 \
  nautilus/python-app
```

---

## Step 4: Verify Deployment
View deployment
```
docker ps
```
![python app](./images/Day%2047.png)

Test the application from the host:

```bash
curl http://localhost:8092/
```
View container logs
```
docker logs pythonapp_nautilus
```

A successful response confirms the containerized app is running correctly.

---

## Key Learnings

- Dockerfiles can be used to package Python applications
- `WORKDIR` sets the working directory inside the container
- `COPY` is used to bring application files and dependencies into the image
- `pip install -r` requirements.txt installs Python dependencies during build
- `EXPOSE` documents the application port used by the container
- `CMD` defines the default command to run the application
- Port mapping exposes containerized apps to the host
- docker logs helps debug and verify running applications