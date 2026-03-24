# Day 49 - Deploy Applications with Kubernetes Deployments

## Task / Requirement
The Nautilus DevOps team is delving into Kubernetes for app management. One team member needs to create a deployment following these details: 

Create a deployment named nginx to deploy the application nginx using the image nginx:latest (ensure to specify the tag)

### Requirement details:

- Deployment name: nginx
- Image: nginx:latest
- Kubernetes access: kubectl is pre-configured on jump host

### Objective

The objective is to create a Kubernetes Deployment named `nginx` using the `nginx:latest` image.


---

## Step 1: Create the Deployment

Use the `kubectl create deployment` command:

```bash
kubectl create deployment nginx --image=nginx:latest
```

---

## Step 2: Verify Deployment

Check that the deployment was created successfully:

```bash
kubectl get deployments
```

---

## Step 3: Verify pods created by deployment
```
kubectl get pods
```
---

## Step 4: Inspect Deployment Details

For deeper validation:

```bash
kubectl describe deployment nginx
```
![Create Deployment](./images/create%20deployment.png)

---

## Key Learnings

- The `--image=nginx:latest` flag explicitly specifies the required image tag.
- A Deployment manages Pods declaratively in Kubernetes
- Deployments ensure desired state and handle Pod recreation automatically
- Kubernetes supports two ways of creating resources: imperative and declarative
- Imperative method uses direct commands (e.g., kubectl create deployment) for quick actions
- Declarative method uses YAML manifests applied via kubectl apply
- Declarative approach is preferred for production as it is version-controlled and repeatable
- Deployments use ReplicaSets internally to manage Pods
- Pods created by Deployments should not be managed directly
- Kubernetes Deployments are preferred over standalone Pods for long-running applications