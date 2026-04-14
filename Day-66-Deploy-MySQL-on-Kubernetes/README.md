# Day 66: Deploy MySQL on Kubernetes

## Task/Requirement

A new MySQL server needs to be deployed on Kubernetes cluster. The Nautilus DevOps team was working on to gather the requirements. Recently they were able to finalize the requirements and shared them with the team members to start working on it. Below you can find the details:



- 1.) Create a PersistentVolume mysql-pv, its capacity should be 250Mi, set other parameters as per your preference.


- 2.) Create a PersistentVolumeClaim to request this PersistentVolume storage. Name it as mysql-pv-claim and request a 250Mi of storage. Set other parameters as per your preference.


- 3.) Create a deployment named mysql-deployment, use any mysql image as per your preference. Mount the PersistentVolume at mount path /var/lib/mysql.


- 4.) Create a NodePort type service named mysql and set nodePort to 30007.


- 5.) Create a secret named mysql-root-pass having a key pair value, where key is password and its value is YUIidhb667, create another secret named mysql-user-pass having some key pair values, where first key is username and its value is kodekloud_sam, second key is password and value is BruCStnMT5, create one more secret named mysql-db-url, key name is database and value is kodekloud_db5


- 6.) Define some environment variables within the container:


    - a.) name: MYSQL_ROOT_PASSWORD, should pick value from secretKeyRef name: mysql-root-pass and key: password


    - b.) name: MYSQL_DATABASE, should pick value from secretKeyRef name: mysql-db-url and key: database


    - c.) name: MYSQL_USER, should pick value from secretKeyRef name: mysql-user-pass key key: username


    - d.) name: MYSQL_PASSWORD, should pick value from secretKeyRef name: mysql-user-pass and key: password

##  Task Summary

Deploy a **MySQL database** on Kubernetes with:

* Persistent storage (PV + PVC)
* Secure credentials via Secrets
* Environment-based configuration
* External access using a NodePort service

---

## Solution Overview

This setup ensures:

* **Data persistence** using volumes mounted at `/var/lib/mysql`
* **Credential security** using Kubernetes Secrets
* **Service exposure** via NodePort `30007`

---

## Implementation Steps

### 1. PersistentVolume

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mysql-pv
spec:
  capacity:
    storage: 250Mi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /mnt/data/mysql
```

---

### 2. PersistentVolumeClaim

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pv-claim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 250Mi
```

---

### 3. Secrets

```bash
kubectl create secret generic mysql-root-pass \
  --from-literal=password=YUIidhb667

kubectl create secret generic mysql-user-pass \
  --from-literal=username=kodekloud_sam \
  --from-literal=password=BruCStnMT5

kubectl create secret generic mysql-db-url \
  --from-literal=database=kodekloud_db5
```

---

### 4. MySQL Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: mysql:5.7
        ports:
        - containerPort: 3306
        env:
        - name: MYSQL_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-root-pass
              key: password
        - name: MYSQL_DATABASE
          valueFrom:
            secretKeyRef:
              name: mysql-db-url
              key: database
        - name: MYSQL_USER
          valueFrom:
            secretKeyRef:
              name: mysql-user-pass
              key: username
        - name: MYSQL_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-user-pass
              key: password
        volumeMounts:
        - name: mysql-storage
          mountPath: /var/lib/mysql
      volumes:
      - name: mysql-storage
        persistentVolumeClaim:
          claimName: mysql-pv-claim
```

---

### 5. NodePort Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: mysql
spec:
  type: NodePort
  selector:
    app: mysql
  ports:
  - port: 3306
    targetPort: 3306
    nodePort: 30007
```

---

## Apply Configuration

```bash
kubectl apply -f .
```

---

##  Verification

```bash
kubectl get pv
kubectl get pvc
kubectl get pods
kubectl get svc
```

---

## Production Notes

* Use **StatefulSets** instead of Deployments for databases
* Replace `hostPath` with cloud storage (e.g., EBS, Azure Disk)
* Avoid NodePort; prefer **ClusterIP + secure access layers**
* Implement backups and monitoring

---

## Key Takeaways

- PersistentVolumes and PersistentVolumeClaims provide durable storage for stateful applications
- Using PVCs decouples storage provisioning from application deployment
- Secrets allow sensitive information like passwords to be stored securely in Kubernetes
- Environment variables can safely consume secret values using `secretKeyRef`
- NodePort services expose databases externally for testing or development use
- Stateful workloads like databases should always use persistent storage
- Kubernetes Secrets of type `Opaque` are used to store generic sensitive data such as passwords, usernames, and database names
- `Opaque` secrets are the most commonly used secret type when no special format is required
- Other secret types include:
  - kubernetes.io/dockerconfigjson for container registry credentials
  - kubernetes.io/tls for TLS certificates and keys
  - service-account-token for API access by pods
- Secrets allow sensitive values to be injected into containers without hardcoding them in manifests
- Using secretKeyRef helps securely map secret values to environment variables
- PersistentVolumes and PersistentVolumeClaims enable stateful applications like MySQL to retain data across pod restarts
- Mounting the PVC at `/var/lib/mysql` ensures MySQL stores data in a persistent location
- Separating configuration (Secrets), storage (PV/PVC), and application logic (Deployment) improves maintainability and security