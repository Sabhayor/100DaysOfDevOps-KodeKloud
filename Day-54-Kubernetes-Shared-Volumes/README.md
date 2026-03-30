
# Day 54 - Kubernetes Shared Volumes

## Task Summary:
This task demonstrates how multiple containers within the same Pod can share data using a common volume. The goal is to deploy a multi-container Pod where both containers mount the same `emptyDir` volume at different paths and verify data sharing between them.


### Environment Details:
- Pod name: `volume-share-devops`
- Volume name: `volume-share`
- Volume type: `emptyDir`
- Container 1:
    - Name: `volume-container-devops-1`
    - Image: `debian:latest`
    - Mount path: `/tmp/beta`
- Container 2:
    - Name: `volume-container-devops-2`
    - Image: `debian:latest`
    - Mount path: `/tmp/cluster`
- Both containers must remain running using a sleep command

## Walkthrough Steps

### 1. Create the Pod Definition

Create a file named `volume-share-devops.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: volume-share-devops
spec:
  containers:
    - name: volume-container-devops-1
      image: debian:latest
      command: ["/bin/sh", "-c", "sleep 3600"]
      volumeMounts:
        - name: volume-share
          mountPath: /tmp/beta

    - name: volume-container-devops-2
      image: debian:latest
      command: ["/bin/sh", "-c", "sleep 3600"]
      volumeMounts:
        - name: volume-share
          mountPath: /tmp/cluster

  volumes:
    - name: volume-share
      emptyDir: {}
```



### 2. Deploy the Pod

```bash
kubectl apply -f volume-share-devops.yaml
```

Verify the Pod is running:

```bash
kubectl get pods
```


### 3. Create Test File in First Container

Exec into the first container:

```bash
kubectl exec -it volume-share-devops -c volume-container-devops-1 -- /bin/sh
```

Create the file:

```bash
echo "Welcome to xFusionCorp Industries" > /tmp/beta/beta.txt
```

Exit the container:

```bash
exit
```


### 4. Verify Shared Volume in Second Container

Exec into the second container:

```bash
kubectl exec -it volume-share-devops -c volume-container-devops-2 -- /bin/sh
```

Check the file:

```bash
cat /tmp/cluster/beta.txt
```

You should see:

```
Welcome to xFusionCorp Industries
```
![Shared volume](./images/Day%2054.png)

## Outcome
- Pod `volume-share-devops` is created and running
- Both containers are in the Running state
- File beta.txt created in `/tmp/beta` of container 1
- Same file is visible in `/tmp/clauster` of container 2
- Shared volume works as expected across containers in the same Pod



## Key Takeaways

* `emptyDir` volumes are **ephemeral** and exist only for the lifecycle of the Pod.
*v `emptyDir` is a Pod-level volume shared by all containers in the same Pod.
* All containers in a Pod can **read/write to the same volume**, even if mounted at different paths.
* `hostPath` is a Node-level volume that maps a directory from the Kubernetes node into a Pod
* Data in `hostPath` persists as long as the Pod runs on the same node
* `persistentVolumeClaim (PVC)` provides cluster-managed persistent storage
* PVC-backed volumes persist even if Pods are deleted or recreated
* Volume type selection depends on data lifetime and persistence requirements
* This pattern is commonly used for:

  * Sidecar containers (e.g., logging agents)
  * Temporary data sharing
  * Build or processing pipelines inside a Pod


