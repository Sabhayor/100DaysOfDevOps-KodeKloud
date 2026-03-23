# Day 48 - Deploy Pods in Kubernetes Cluster

## Task/Requirement

The Nautilus DevOps team is diving into Kubernetes for application management. One team member has a task to create a pod according to the details below:


Create a pod named pod-nginx using the nginx image with the latest tag. Ensure to specify the tag as nginx:latest.

Set the app label to nginx_app, and name the container as nginx-container.

Note: The kubectl utility on the jump-host has been configured to work with the Kubernetes cluster.

### Requirement Details

- Pod name: pod-nginx
- Container name: nginx-container
- Image: nginx:latest
- Label: app=nginx_app
- Kubernetes access: kubectl is pre-configured on jump host

In this task, we deploy a simple NGINX pod in a Kubernetes cluster using `kubectl`, following production-aligned best practices like explicit image tagging, labeling, and container naming.

## Step 1: Create the Pod Manifest

Define the pod configuration in a YAML file (e.g., `pod-nginx.yaml`):

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-nginx
  labels:
    app: nginx_app
spec:
  containers:
    - name: nginx-container
      image: nginx:latest
```

## Step 2: Apply the Configuration

Use `kubectl` to create the pod in the cluster:

```bash
kubectl apply -f pod-nginx.yaml
```

## Step 3: Verify Deployment

Confirm the pod is running:

```bash
kubectl get pods
```

For more detailed inspection:

```bash
kubectl describe pod pod-nginx
```

## Key Notes

* **Explicit Tagging (`nginx:latest`)** ensures clarity and avoids ambiguity in image versions.
* **Labels (`app: nginx_app`)** are critical for future scalability (e.g., Services, Deployments).
* **Container Naming** improves observability and debugging in multi-container setups.

## Key Learnings

- A Pod is the smallest deployable unit in Kubernetes
- Pods encapsulate one or more containers that share networking and storage
- Labels are used to organize and identify Kubernetes resources
- Kubernetes follows a declarative model using YAML manifests
- `kubectl apply` creates or updates resources in the cluster
- `kubectl get pods` provides a quick status overview
- `kubectl` describe helps troubleshoot and understand Pod behavior

![Pod creation](./images/Day%2048.png)


