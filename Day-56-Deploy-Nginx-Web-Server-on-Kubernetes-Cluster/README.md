# Day 56 – Deploy Nginx Web Server on Kubernetes Cluster

## Task/Requirement

Some of the Nautilus team developers are developing a static website and they want to deploy it on Kubernetes cluster. They want it to be highly available and scalable. Therefore, based on the requirements, the DevOps team has decided to create a deployment for it with multiple replicas. Below you can find more details about it:


Create a deployment using nginx image with latest tag only and remember to mention the tag i.e nginx:latest. Name it as nginx-deployment. The container should be named as nginx-container, also make sure replica counts are 3.

Create a NodePort type service named nginx-service. The nodePort should be 30011.

Note: The kubectl utility on the jump-host has been configured to work with the Kubernetes cluster.

## Task Summary

The objective is to deploy a highly available and scalable static web application using **Nginx** on a Kubernetes cluster. This involves creating a **Deployment** with multiple replicas and exposing it externally via a **NodePort Service**.

### Environment Details:

- Deployment name: `nginx-deployment`
- Image: `nginx:latest`
- Container name: `nginx-container`
- Replicas: 3
- Service name: `nginx-service`
- Service type: `NodePort`
- NodePort: 30011
---

## Solution Steps

### 1. Create the Deployment

Define a deployment named `nginx-deployment` using the `nginx:latest` image with **3 replicas** for high availability.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx-container
        image: nginx:latest
        ports:
        - containerPort: 80
```

Apply it:

```bash
kubectl apply -f deployment.yaml
```

---

### 2. Create the NodePort Service

Expose the deployment externally using a NodePort service named `nginx-service` on port **30011**.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30011
```

Apply it:

```bash
kubectl apply -f service.yaml
```

---

### 3. Verification

Check if pods are running:

```bash
kubectl get pods
```

Check deployment status:

```bash
kubectl get deploy
```

Verify service:

```bash
kubectl get svc
```

Access the application:

```bash
http://<NODE-IP>:30011
```
![Nginx web server](./images/Day%2056.png)
---

## Outcomes

- Deployment `nginx-deployment` is created successfully
- Three Nginx Pods are running simultaneously
- Pods are managed automatically by the Deployment
- `NodePort` Service `nginx-service` is created
- Application is accessible externally via `NodePort 30011`
- Traffic is distributed across Pods

## Key Learnings
- Deployments provide scalability and high availability using replicas
- Kubernetes automatically manages Pod creation and replacement
- Services provide stable access to Pods
- `NodePort` exposes an application on a static port on each node
- Traffic sent to a `NodePort` is load-balanced across all healthy Pods
- Deployments and Services together form the core of Kubernetes application exposure