# Day 51: Execute Rolling Updates in Kubernetes

## Objective
Perform a rolling update on an existing Kubernetes Deployment (`nginx-deployment`) to use the updated image `nginx:1.17`, ensuring zero downtime and verifying that all pods are running successfully after the update.

### Requirement details:

- Deployment name: nginx-deployment
- New image: nginx:1.17
- Kubernetes access: kubectl configured on jump host
- Constraint: Ensure all Pods are running after the update

---

## Step 1: Inspect Current State
Start by checking the running pods and deployment:

```bash
kubectl get pods
kubectl get deploy
```

---

## Step 2: Review Deployment Configuration

Understand the current setup, including the image in use:

```bash
kubectl describe deploy nginx-deployment
```

Optionally inspect one of the running pods:

```bash
kubectl describe pod nginx-deployment-<pod-id>
```

---

## Step 3: Execute Rolling Update

Update the image directly in the deployment:

```bash
kubectl edit deploy nginx-deployment
```

* Locate the `image` field
* Change it to:

```yaml
image: nginx:1.17
```

Save and exit - Kubernetes will automatically trigger a rolling update.

---

## Step 4: Monitor the Update Process

Watch pods terminate and new ones come up gradually:

```bash
kubectl get pods --watch
```

This confirms the rolling update strategy is working (old pods replaced incrementally).

---

## Step 5: Validate New Pods

Inspect one of the newly created pods:

```bash
kubectl describe pod nginx-deployment-<new-pod-id>
```

Ensure:

* Image is `nginx:1.17`
* Pod status is `Running`
* No errors or restarts

---

## Step 6: Confirm Rollout Status

Verify the deployment completed successfully:

```bash
kubectl rollout status deployment nginx-deployment
```

---

## Step 7: Check Rollout History

View deployment revisions:

```bash
kubectl rollout history deployment nginx-deployment
```

Inspect a specific revision for audit/debugging:

```bash
kubectl rollout history deployment nginx-deployment --revision=2
```
![k8s rollout](./images/k8s%20rollout.png)

## Outcome

The application is successfully updated using Kubernetes rolling update strategy. Pods were replaced incrementally with the new `nginx:1.17` image, ensuring zero downtime and stable application performance.

---
## Key Learnings

- Rolling updates allow application updates without downtime
- Kubernetes Deployments replace Pods gradually during updates
- `kubectl edit deploy` can be used to update container images
- `kubectl rollout status` helps track update progress
- Rollout history allows visibility into previous versions
- Kubernetes maintains revision history for rollback if needed
