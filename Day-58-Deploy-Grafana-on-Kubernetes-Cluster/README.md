# Day 58 - Deploy Grafana on Kubernetes Cluster

##  Task Summary
The objective is to deploy a Grafana application on a Kubernetes cluster to enable monitoring and analytics visualization. This involves creating a Deployment for Grafana and exposing it externally using a NodePort Service, ensuring access to the Grafana login page.

### Environment details:

- Deployment name: `grafana-deployment-devops`
- Image: Any Grafana image
- Service type: `NodePort`
- NodePort: `32000`
- Kubernetes access: kubectl configured on jump host

## Solution Steps

### Step 1: Create Grafana Deployment
Deploy Grafana using any official image (e.g., `grafana/grafana`).

```bash
kubectl create deployment grafana-deployment-devops \
  --image=grafana/grafana
```

Verify:

```bash
kubectl get deploy
kubectl get pods
```

---

### Step 2: Expose Deployment via NodePort Service

Expose the Grafana app externally using a NodePort service on port `32000`.

```bash
kubectl expose deployment grafana-deployment-devops \
  --type=NodePort \
  --port=3000 \
  --target-port=3000 \
  --name=grafana-service-devops
```

Patch the service to use the required NodePort:

```bash
kubectl patch svc grafana-service-devops \
  -p '{"spec": {"ports": [{"port":3000,"targetPort":3000,"nodePort":32000}]}}'
```

---

### Step 3: Validate Access

Check service details:

```bash
kubectl get svc
```

Access Grafana in browser:

```
http://<NODE-IP>:32000
```

You should see the Grafana login page.

![Grafana Login](./images/grafana-login.png)
---

## Outcome

Successfully deployed Grafana on Kubernetes and exposed it externally using a NodePort service, enabling access to the Grafana UI for monitoring and analytics use cases.

## Key Takeaway

* Default Grafana runs on port `3000`
* NodePort range must allow `32000` (typically 30000–32767)
* Kubernetes Deployments are used to manage application lifecycle
* Services provide stable access to Pods
* NodePort exposes applications externally on a fixed port
* Monitoring tools like Grafana can be deployed easily on Kubernetes



