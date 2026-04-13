# Day 65 - Deploy Redis on Kubernetes

## Task/Requirement

The Nautilus application development team observed some performance issues with one of the application that is deployed in Kubernetes cluster. After looking into number of factors, the team has suggested to use some in-memory caching utility for DB service. After number of discussions, they have decided to use Redis. Initially they would like to deploy Redis on kubernetes cluster for testing and later they will move it to production. Please find below more details about the task:


Create a redis deployment with following parameters:

- Create a config map called `my-redis-config` having maxmemory 2mb in redis-config.

- Name of the deployment should be `redis-deployment`, it should use
`redis:alpine` image and container name should be `redis-container`. Also make sure it has only 1 replica.

- The container should request for 1 CPU.

- Mount 2 volumes:

    - a. An Empty directory volume called data at path `/redis-master-data`.

    - b. A configmap volume called `redis-config` at path `/redis-master`.

    - c. The container should expose the port 6379.

- Finally, redis-deployment should be up and running.

## Task Summary

The Nautilus development team identified performance bottlenecks in an application and decided to introduce **in-memory caching** using Redis. As a first step toward production readiness, Redis is deployed on a Kubernetes cluster for testing.

This task focuses on creating a **Redis Deployment** with proper configuration management, resource allocation, and volume setup—key practices aligned with real-world production environments.

---

##  Requirements

* Create a **ConfigMap**: `my-redis-config` with `maxmemory 2mb`
* Deploy Redis using:

  * Image: `redis:alpine`
  * Deployment name: `redis-deployment`
  * Container name: `redis-container`
  * Replicas: `1`
* Resource request:

  * CPU: `1`
* Volumes:

  * `emptyDir` → `/redis-master-data`
  * ConfigMap → `/redis-master`
* Expose container port: `6379`
* Ensure deployment is **running successfully**

---

## Solution Steps

### 1. Create ConfigMap

Define Redis configuration (max memory limit):

```bash
kubectl create configmap my-redis-config \
  --from-literal=redis-config="maxmemory 2mb"
```

---

### 2. Create Deployment YAML

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
      - name: redis-container
        image: redis:alpine
        ports:
        - containerPort: 6379
        resources:
          requests:
            cpu: "1"
        volumeMounts:
        - name: data
          mountPath: /redis-master-data
        - name: redis-config
          mountPath: /redis-master
      volumes:
      - name: data
        emptyDir: {}
      - name: redis-config
        configMap:
          name: my-redis-config
```

---

### 3. Apply Deployment

```bash
kubectl apply -f redis-deployment.yaml
```

---

### 4. Verify Deployment Status

```bash
kubectl get pods
kubectl describe pod <pod-name>
```

Ensure the pod is in **Running** state and no volume or resource errors exist.

---

## Key Takeaways

* **ConfigMaps** decouple configuration from container images (production best practice)
* **emptyDir** is suitable for ephemeral storage (non-persistent test environments)
* **Resource requests** help with proper scheduling and cluster stability
* Redis stores all data in memory, which allows it to serve data extremely fast compared to disk-based databases
* Data in Redis is stored as key–value pairs and is commonly used for caching frequently accessed information
* Since Redis runs entirely in RAM, controlling memory usage is critical in containerized environments
* The maxmemory setting limits the maximum amount of memory Redis can use for storing data
* When Redis reaches the maxmemory limit, it either evicts old data or rejects new writes depending on its eviction policy
* Setting maxmemory helps prevent Redis pods from consuming excessive memory and getting terminated in Kubernetes
* `emptyDir` volumes are suitable for Redis because cache data is temporary and does not require persistence