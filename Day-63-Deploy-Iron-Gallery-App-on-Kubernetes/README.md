# Day 63 - Deploy Iron Gallery App (Nautilus Variant)

## Task/Requirement

There is an iron gallery app that the Nautilus DevOps team was developing. They have recently customized the app and are going to deploy the same on the Kubernetes cluster. Below you can find more details:

1. Create a namespace `iron-namespace-nautilus`

2. Create a deployment `iron-gallery-deployment-nautilus` for iron gallery under the same namespace you created.

- Labels run should be `iron-gallery`.

- Replicas count should be 1.

- Selector's matchLabels run should be `iron-gallery`.

- Template labels run should be `iron-gallery` under metadata.

- The container should be named as `iron-gallery-container-nautilus`, use `kodekloud/irongallery:2.0` image ( use exact image name / tag ).

- Resources limits for memory should be 100Mi and for CPU should be 50m.

- First volumeMount name should be `config`, its mountPath should be `/usr/share/nginx/html/data`.

- Second volumeMount name should be `images`, its mountPath should be `/usr/share/nginx/html/uploads`.

- First volume name should be `config` and give it `emptyDir` and second volume name should be `images`, also give it `emptyDir`.

3. Create a deployment `iron-db-deployment-nautilus` for iron db under the same namespace.

- Labels db should be `mariadb`.

- Replicas count should be 1.

- Selector's matchLabels db should be `mariadb`.

- Template labels db should be `mariadb` under metadata.

- The container name should be `iron-db-container-nautilus`, use `kodekloud/irondb:2.0` image ( use exact image name / tag ).

- Define environment, set `MYSQL_DATABASE` its value should be `database_apache`, set `MYSQL_ROOT_PASSWORD` and `MYSQL_PASSWORD` value should be with some complex passwords for DB connections, and `MYSQL_USER` value should be any custom user ( except root ).

- Volume mount name should be db and its mountPath should be `/var/lib/mysql`. Volume name should be `db` and give it an `emptyDir`.

4. Create a service for iron db which should be named `iron-db-service-nautilus` under the same namespace. Configure spec as selector's `db` should be `mariadb`. Protocol should be `TCP`, port and targetPort should be `3306` and its type should be `ClusterIP`.

5. Create a service for iron gallery which should be named `iron-gallery-service-nautilus` under the same namespace. Configure spec as selector's run should be `iron-gallery`. Protocol should be `TCP`, port and targetPort should be `80`, nodePort should be `32678` and its type should be `NodePort`.


Note:


We don't need to make connection b/w database and front-end now, if the installation page is coming up it should be enough for now.

The kubectl utility on the jump-host has been configured to work with the Kubernetes cluster.   


## Task Summary

This task involves deploying a two-tier application on Kubernetes within an isolated namespace. The **Iron Gallery frontend** and **Iron DB (MariaDB) backend** are deployed as separate workloads with proper labels, resource constraints, and ephemeral storage. Services are configured to enable internal communication and external access.

---

## Objectives

* Create a dedicated namespace for isolation
* Deploy frontend and backend using Kubernetes Deployments
* Configure environment variables for database initialization
* Use `emptyDir` volumes for ephemeral storage
* Expose services using **ClusterIP** (DB) and **NodePort** (frontend)
---

##  Implementation

### 1. Create Namespace

```bash
kubectl create namespace iron-namespace-nautilus
```

---

### 2. Iron Gallery Deployment (Frontend)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: iron-gallery-deployment-nautilus
  namespace: iron-namespace-nautilus
spec:
  replicas: 1
  selector:
    matchLabels:
      run: iron-gallery
  template:
    metadata:
      labels:
        run: iron-gallery
    spec:
      containers:
      - name: iron-gallery-container-nautilus
        image: kodekloud/irongallery:2.0
        resources:
          limits:
            memory: "100Mi"
            cpu: "50m"
        volumeMounts:
        - name: config
          mountPath: /usr/share/nginx/html/data
        - name: images
          mountPath: /usr/share/nginx/html/uploads
      volumes:
      - name: config
        emptyDir: {}
      - name: images
        emptyDir: {}
```

Apply:

```bash
kubectl apply -f iron-gallery-deployment.yaml
```

---

### 3. Iron DB Deployment (Backend)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: iron-db-deployment-nautilus
  namespace: iron-namespace-nautilus
spec:
  replicas: 1
  selector:
    matchLabels:
      db: mariadb
  template:
    metadata:
      labels:
        db: mariadb
    spec:
      containers:
      - name: iron-db-container-nautilus
        image: kodekloud/irondb:2.0
        env:
        - name: MYSQL_DATABASE
          value: database_apache
        - name: MYSQL_ROOT_PASSWORD
          value: StrongRootPass123!
        - name: MYSQL_PASSWORD
          value: StrongUserPass123!
        - name: MYSQL_USER
          value: ironuser
        volumeMounts:
        - name: db
          mountPath: /var/lib/mysql
      volumes:
      - name: db
        emptyDir: {}
```

Apply:

```bash
kubectl apply -f iron-db-deployment.yaml
```

---

### 4. Iron DB Service (ClusterIP)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: iron-db-service-nautilus
  namespace: iron-namespace-nautilus
spec:
  selector:
    db: mariadb
  ports:
  - protocol: TCP
    port: 3306
    targetPort: 3306
  type: ClusterIP
```

Apply:

```bash
kubectl apply -f iron-db-service.yaml
```

---

### 5. Iron Gallery Service (NodePort)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: iron-gallery-service-nautilus
  namespace: iron-namespace-nautilus
spec:
  selector:
    run: iron-gallery
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
    nodePort: 32678
  type: NodePort
```

Apply:

```bash
kubectl apply -f iron-gallery-service.yaml
```

---

## Verification

```bash
kubectl get all -n iron-namespace-nautilus
```

Access the app:

```bash
http://<NODE-IP>:32678
```

If the installation page loads, deployment is successful.

---

## Production Notes

* `emptyDir` volumes are **ephemeral** → not suitable for production DB workloads
* Secrets should replace plaintext environment variables
* PersistentVolumes should back MariaDB for durability
* NodePort is acceptable for testing; production setups should use **Ingress + LoadBalancer**

---

## Outcome
- Namespace `iron-namespace-nautilus` exists
- Two deployments are running:
    - Iron Gallery front-end deployment
    - Iron Gallery database deployment
- Database service is accessible internally via ClusterIP on port 3306
- Iron Gallery application is accessible externally via NodePort 32678
- The Iron Gallery installation page is reachable, indicating successful deployment

## Key Takeaways
- Namespaces help logically isolate application resources within a Kubernetes cluster
- A ClusterIP service is used for the database since it should be accessible only inside the cluster 
- A NodePort service is used for the application to allow external access from outside the cluster
- emptyDir volumes provide temporary storage required by containers at runtime
- Deployments ensure the desired number of application pods are always running