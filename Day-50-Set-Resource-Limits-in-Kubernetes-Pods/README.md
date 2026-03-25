# Day 50 - Set Resource Limits in Kubernetes Pods

## Task / Requirement
The DevOps team observed performance issues in Kubernetes-hosted applications due to uncontrolled resource usage. To prevent resource exhaustion and ensure fair scheduling, resource requests and limits need to be defined for a Pod.

The requirement is to create a Pod with explicit CPU and memory requests and limits.

### Requirement details:

- Pod name: httpd-pod
- Container name: httpd-container
- Image: httpd:latest
- Resource requests:
    - Memory: 15Mi
    - CPU: 100m
- Resource limits:
    - Memory: 20Mi
    - CPU: 100m
- Kubernetes access: kubectl is pre-configured on jump host

In this task, the goal is to control resource consumption in a Kubernetes Pod to prevent performance degradation and ensure fair resource allocation.

## Step 1: Define the Pod Manifest

Create a file named `httpd-pod.yaml` and specify the required configuration:  
```
sudo vi httpd-pod.yaml
```
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: httpd-pod
spec:
  containers:
    - name: httpd-container
      image: httpd:latest
      resources:
        requests:
          memory: "15Mi"
          cpu: "100m"
        limits:
          memory: "20Mi"
          cpu: "100m"
```

## Step 2: Apply the Configuration

Deploy the pod using:

```bash
kubectl apply -f httpd-pod.yaml
```

## Step 3: Verify the Pod

Confirm the pod is running:

```bash
kubectl get pods
```

Inspect resource allocation:

```bash
kubectl describe pod httpd-pod
```
![Resource Limit](./images/Day%2050.png)

## Key Learnings

- **Resource requests** define the minimum CPU and memory required for Pod scheduling
- **Resource limits** define the maximum CPU and memory a container can use
- CPU is measured in millicores (100m = 0.1 CPU)
- Kubernetes uses requests for scheduling and limits for enforcement
- If a container exceeds its memory limit, it is terminated with an OOMKilled error and restarted (if restart policy allows)
- If a container exceeds its CPU limit, it is throttled but not terminated
- Resource limits prevent one Pod from consuming excessive resources
- Pods without resource limits can destabilize a cluster
