# Day 55 – Kubernetes Sidecar Containers

## Task Summary
This task demonstrates the **Sidecar pattern in Kubernetes**, where multiple containers in the same Pod collaborate to achieve a common goal.

We have:
- A primary **Nginx container** serving web traffic.
- A secondary **sidecar container** responsible for reading and shipping logs.

Instead of using persistent storage, logs are shared between containers using an **emptyDir volume**, allowing both containers to access the same filesystem path during the Pod lifecycle.

---

## Objective
- Create a Pod named `webserver`
- Use an `emptyDir` volume (`shared-logs`)
- Deploy:
  - `nginx-container` → runs `nginx:latest`
  - `sidecar-container` → runs `ubuntu:latest`
- Share logs via `/var/log/nginx`
- Sidecar continuously reads logs every 30 seconds

---

## Implementation Steps

### 1. Create the Pod Definition
Create a YAML file:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: webserver
spec:
  volumes:
    - name: shared-logs
      emptyDir: {}

  containers:
    - name: nginx-container
      image: nginx:latest
      volumeMounts:
        - name: shared-logs
          mountPath: /var/log/nginx

    - name: sidecar-container
      image: ubuntu:latest
      command: ["sh", "-c", "while true; do cat /var/log/nginx/access.log /var/log/nginx/error.log; sleep 30; done"]
      volumeMounts:
        - name: shared-logs
          mountPath: /var/log/nginx
```

---

### 2. Apply the Configuration

```bash
kubectl apply -f webserver.yaml
```

---

### 3. Verify Pod Status

```bash
kubectl get pods
```

Ensure the Pod is in `Running` state.

---

### 4. Validate Both Containers

```bash
kubectl describe pod webserver
```

Confirm:

* Both containers are running
* Volume is mounted correctly

---

### 5. Check Sidecar Logs

```bash
kubectl logs webserver -c sidecar-container
```

You should see output from:

* `/var/log/nginx/access.log`
* `/var/log/nginx/error.log`

---

## Key Concepts

### Sidecar Pattern

* Extends functionality without modifying the main container
* Promotes **separation of concerns**

### emptyDir Volume

* Temporary storage shared between containers in the same Pod
* Lives as long as the Pod is running

---

## Production Relevance

This pattern is widely used in real-world systems for:

* Log shipping (e.g., Fluentd, Filebeat)
* Monitoring agents
* Security proxies

It keeps your application container lightweight while delegating operational responsibilities to specialized containers.

---

## Outcome

* Implemented a multi-container Pod
* Shared data between containers using volumes
* Applied the sidecar pattern for log processing
