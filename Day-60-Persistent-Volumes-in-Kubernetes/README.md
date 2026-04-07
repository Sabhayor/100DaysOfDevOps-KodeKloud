# Day 60 - Persistent Volumes in Kubernetes

## Task/Requirement

The Nautilus DevOps team is working on a Kubernetes template to deploy a web application on the cluster. There are some requirements to create/use persistent volumes to store the application code, and the template needs to be designed accordingly. Please find more details below:


- Create a `PersistentVolume` named as `pv-nautilus`. Configure the spec as storage class should be manual, set capacity to 5Gi, set access mode to `ReadWriteOnce`, volume type should be `hostPath` and set path to `/mnt/security` (this directory is already created, you might not be able to access it directly, so you need not to worry about it).

- Create a `PersistentVolumeClaim` named as `pvc-nautilus`. Configure the spec as storage class should be manual, request 3Gi of the storage, set access mode to `ReadWriteOnce`.

- Create a pod named as `pod-nautilus`, mount the persistent volume you created with claim name `pvc-nautilus` at document root of the web server, the container within the pod should be named as `container-nautilus` using image nginx with latest tag only (remember to mention the tag i.e `nginx:latest`).

- Create a node port type service named `web-nautilus` using node port 30008 to expose the web server running within the pod.

Note: The kubectl utility on the jump-host has been configured to work with the Kubernetes cluster.


## Overview

In this task, we implemented **persistent storage** for a Kubernetes-based web application using **Persistent Volumes (PV)** and **Persistent Volume Claims (PVC)**. This setup simulates a real-world production scenario where application data must survive pod restarts and rescheduling.

The goal was to provision storage manually, bind it to a workload, and expose the application externally using a NodePort service.

---

## Architecture Breakdown

* **PersistentVolume (PV):** Provides 5Gi storage using `hostPath`
* **PersistentVolumeClaim (PVC):** Requests 3Gi from the PV
* **Pod:** Runs Nginx and mounts the PVC at the web root
* **Service:** Exposes the application on NodePort `30008`

---

## Solution Steps

### 1. Create PersistentVolume

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-nautilus
spec:
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteOnce
  storageClassName: manual
  hostPath:
    path: /mnt/security
```

Apply:

```bash
kubectl apply -f pv.yaml
```

---

### 2. Create PersistentVolumeClaim

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-nautilus
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: manual
  resources:
    requests:
      storage: 3Gi
```

Apply:

```bash
kubectl apply -f pvc.yaml
```

---

### 3. Create Pod with Volume Mount

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-nautilus
  labels:
    app: nginx
spec:
  containers:
    - name: container-nautilus
      image: nginx:latest
      ports:
        - containerPort: 80
      volumeMounts:
        - mountPath: /usr/share/nginx/html
          name: web-storage
  volumes:
    - name: web-storage
      persistentVolumeClaim:
        claimName: pvc-nautilus
```

Apply:

```bash
kubectl apply -f pod.yaml
```

---

### 4. Expose Pod via NodePort Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-nautilus
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30008
```

---

## Verification

Check resources:

```bash
kubectl get pv
kubectl get pvc
kubectl get pods
kubectl get svc
```

### Check container logs
```
kubectl logs pod-nautilus -c container-nautilus
```

### Exec into container
```
kubectl exec -it pod-nautilus -c container-nautilus -- /bin/sh
```

### Create an Index file
```
echo "<h1>Hello from PV</h1>" > /usr/share/nginx/html/index.html
```

### Verify PVC mount
```
kubectl exec -it pod-nautilus -- ls -l /usr/share/nginx/html
```


Test access:

```bash
curl http://<node-ip>:30008
```

---

## Key Learnings

- Kubernetes volumes are used to store data outside the container filesystem
- Data inside a container is lost when the Pod restarts unless a volume is used
- A `PersistentVolume` (PV) represents actual storage in the cluster
- A `PersistentVolumeClaim` (PVC) is a request for storage made by a Pod
- Pods do not use PVs directly; they always use PVCs
- `hostPath` volumes store data on the Kubernetes node
- Data in a `hostPath` volume remains even if the Pod is deleted
- `ReadWriteOnce` means the volume can be mounted by only one node at a time
- Persistent volumes allow applications to keep data across Pod restarts

###  Difference between emptyDir, hostPath, and Persistent Volumes

- `emptyDir` is a Pod-level temporary volume
    - Created when the Pod starts
    - Deleted when the Pod is removed
    - Used for temporary data shared between containers in the same Pod
- hostPath is a Node-level volume
    - Maps a directory from the Kubernetes node into a Pod
    - Data persists even if the Pod is deleted
    - Data is lost if the Pod moves to another node
    - Suitable mainly for testing or single-node setups
- PersistentVolume (PV) is cluster-managed storage
    - Exists independently of Pods
    - Not deleted when Pods are deleted
    - Can be reused by different Pods via PVCs

### PersistentVolumeClaim (PVC)

- PVC is a request for storage by a Pod
- Pods never use PVs directly; they always use PVCs
- PVC binds to a matching PV based on size, access mode, and storage class

### What can be used as Persistent Volumes

- `hostPath` (for testing or labs)
- NFS (network shared storage)
- Cloud disks (EBS, Azure Disk, GCE Persistent Disk)
- CSI-based storage providers
- iSCSI and other block storage systems

### Key takeaways

- Use `emptyDir` for temporary Pod-level data
- Use `hostPath` for node-specific storage
- Use PV + PVC for reliable, long-term storage
- Persistent storage allows applications to survive Pod restarts
