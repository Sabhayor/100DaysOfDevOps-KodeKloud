# Day 67 - Deploy Guestbook App on Kubernetes

## Task/Requirement

The Nautilus Application development team has finished development of one of the applications and it is ready for deployment. It is a guestbook application that will be used to manage entries for guests/visitors. As per discussion with the DevOps team, they have finalized the infrastructure that will be deployed on Kubernetes cluster. Below you can find more details about it.


### BACKEND TIER

- Create a deployment named redis-master for Redis master.

  - a.) Replicas count should be 1.

  - b.) Container name should be master-redis-nautilus and it should use image redis.

  - c.) Request resources as CPU should be 100m and Memory should be 100Mi.

  - d.) Container port should be redis default port i.e 6379.

- Create a service named redis-master for Redis master. Port and targetPort should be Redis default port i.e 6379.

- Create another deployment named redis-slave for Redis slave.

    - a.) Replicas count should be 2.

    - b.) Container name should be slave-redis-nautilus and it should use gcr.io/google_samples/gb-redisslave:v3 image.

    - c.) Requests resources as CPU should be 100m and Memory should be 100Mi.

    - d.) Define an environment variable named GET_HOSTS_FROM and its value should be dns.

    - e.) Container port should be Redis default port i.e 6379.

- Create another service named redis-slave. It should use Redis default port i.e 6379.

### FRONTEND TIER

- Create a deployment named frontend.

    - a.) Replicas count should be 3.

    - b.) Container name should be php-redis-nautilus and it should use gcr.io/google-samples/gb-frontend@sha256:a908df8486ff66f2c4daa0d3d8a2fa09846a1fc8efd65649c0109695c7c5cbff image.

    - c.) Request resources as CPU should be 100m and Memory should be 100Mi.

    - d.) Define an environment variable named as GET_HOSTS_FROM and its value should be dns.

    - e.) Container port should be 80.

- Create a service named frontend. Its type should be NodePort, port should be 80 and its nodePort should be 30009.

Finally, you can check the guestbook app by clicking on App button.


You can use any labels as per your choice.

---

## Overview

This task focuses on deploying a **multi-tier Guestbook application** on Kubernetes, following a typical production-style architecture:

* **Backend Tier** → Redis Master & Redis Slave
* **Frontend Tier** → PHP-based web application
* **Networking** → Internal services + external exposure via NodePort

This setup demonstrates **microservices communication, service discovery (DNS), and resource management** in a Kubernetes environment.

---

## Architecture

```
Frontend (PHP App - 3 replicas)
        |
        v
Redis Slave (2 replicas) ---> Redis Master (1 replica)
```

* Frontend interacts with Redis via **DNS-based service discovery**
* Redis master handles writes; slaves handle reads
* NodePort exposes the frontend externally

---

## Implementation Steps

### 1. Redis Master Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-master
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis-master
  template:
    metadata:
      labels:
        app: redis-master
    spec:
      containers:
      - name: master-redis-nautilus
        image: redis
        ports:
        - containerPort: 6379
        resources:
          requests:
            cpu: "100m"
            memory: "100Mi"
```

### Redis Master Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: redis-master
spec:
  selector:
    app: redis-master
  ports:
  - port: 6379
    targetPort: 6379
```

---

### 2. Redis Slave Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-slave
spec:
  replicas: 2
  selector:
    matchLabels:
      app: redis-slave
  template:
    metadata:
      labels:
        app: redis-slave
    spec:
      containers:
      - name: slave-redis-nautilus
        image: gcr.io/google_samples/gb-redisslave:v3
        ports:
        - containerPort: 6379
        env:
        - name: GET_HOSTS_FROM
          value: "dns"
        resources:
          requests:
            cpu: "100m"
            memory: "100Mi"
```

### Redis Slave Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: redis-slave
spec:
  selector:
    app: redis-slave
  ports:
  - port: 6379
    targetPort: 6379
```

---

### 3. Frontend Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
spec:
  replicas: 3
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: php-redis-nautilus
        image: gcr.io/google-samples/gb-frontend@sha256:a908df8486ff66f2c4daa0d3d8a2fa09846a1fc8efd65649c0109695c7c5cbff
        ports:
        - containerPort: 80
        env:
        - name: GET_HOSTS_FROM
          value: "dns"
        resources:
          requests:
            cpu: "100m"
            memory: "100Mi"
```

---

### Frontend Service (NodePort)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: frontend
spec:
  type: NodePort
  selector:
    app: frontend
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30009
```

---

## Deployment Commands

Apply all resources:

```bash
kubectl apply -f .
```

Or individually:

```bash
kubectl apply -f redis-master.yaml
kubectl apply -f redis-slave.yaml
kubectl apply -f frontend.yaml
```

---

## Verification

Check pods:

```bash
kubectl get pods
```

Check services:

```bash
kubectl get svc
```

Ensure:

* All pods are **Running**
* Services are correctly exposed
* Frontend has **NodePort 30009**

---

## Access Application

```bash
http://<NODE-IP>:30009
```

This should load the **Guestbook UI**, confirming:

* Frontend ↔ Redis communication is working
* DNS-based service discovery is functional

---

## Key Takeaways

* Implemented **multi-tier architecture on Kubernetes**
* Used **services for internal communication**
* Leveraged **environment variables for service discovery**
* Exposed application externally using **NodePort**
* Applied **resource requests for better scheduling**
