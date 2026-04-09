# Day 62 - Manage Secrets in Kubernetes

## Task/Requirement

The Nautilus DevOps team is working to deploy some tools in Kubernetes cluster. Some of the tools are licence based so that licence information needs to be stored securely within Kubernetes cluster. Therefore, the team wants to utilize Kubernetes secrets to store those secrets. Below you can find more details about the requirements:

- We already have a secret key file official.txt under the /opt/ directory. Create a generic secret named official, it should contain the password/license-number present in official.txt file.

- Also create a pod named secret-datacenter.

- Configure pod's spec as container name should be secret-container-datacenter, image should be fedora with latest tag (remember to mention the tag with image). Use sleep command for container so that it remains in running state. Consume the created secret and mount it under /opt/games within the container.

- To verify you can exec into the container secret-container-datacenter, to check the secret key under the mounted path /opt/games. Before hitting the Check button please make sure pod/pods are in running state, also validation can take some time to complete so keep patience.


### Task Summary

This exercise focuses on securely handling sensitive data (like license keys) using **Kubernetes Secrets**. Instead of hardcoding credentials into manifests, you create a secret from an existing file and mount it into a running Pod as a volume. This mirrors real-world production practices where secrets must be abstracted and protected.

---

## Implementation Steps

#### 1. Create the Secret

You’re given a file `/opt/official.txt` containing the sensitive value. Use it to create a **generic secret**:

```bash
kubectl create secret generic official \
  --from-file=/opt/official.txt
```

Validate:

```bash
kubectl get secrets
```

---

#### 2. Create the Pod Definition

Define a Pod that:

* Uses **fedora:latest**
* Runs a long-lived process (`sleep`)
* Mounts the secret at `/opt/games`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secret-datacenter
spec:
  containers:
    - name: secret-container-datacenter
      image: fedora:latest
      command: ["/bin/sh", "-c", "sleep 10000"]
      volumeMounts:
        - name: secret-volume
          mountPath: /opt/games
          readOnly: true
  volumes:
    - name: secret-volume
      secret:
        secretName: official
```

Apply:

```bash
kubectl apply -f pod.yaml
```

---

#### 3. Verify Pod Status

Ensure the Pod is running before validation:

```bash
kubectl get pods
```

---

#### 4. Validate Secret Mount

Exec into the container:

```bash
kubectl exec -it secret-datacenter -- /bin/bash
```

Check mounted secret:

```bash
ls /opt/games
cat /opt/games/official.txt
```

You should see the contents of the original file.

---

### Key Takeaways

* **Kubernetes Secrets** are used to securely store sensitive data.
* Secrets can be **mounted as volumes** or exposed as environment variables.
* Mounting as a volume keeps data decoupled from container images—critical for production-grade security.
* Always verify mounts inside the container to confirm correct configuration.

