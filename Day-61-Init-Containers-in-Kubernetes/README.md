# Day 61 - Init containers in kubernetes

## Task/Requirement

There are some applications that need to be deployed on Kubernetes cluster and these apps have some pre-requisites where some configurations need to be changed before deploying the app container. Some of these changes cannot be made inside the images so the nautilus team has come up with a solution to use init containers to perform these tasks during deployment. Below is a sample scenario that the team is going to test first.

1. Create a Deployment named as `ic-deploy-nautilus`.

2. Configure spec as replicas should be 1, labels app should be `ic-nautilus`, template's metadata lables app should be the same `ic-nautilus`.

3. The `initContainers` should be named as `ic-msg-nautilus`, use image debian with latest tag and use command `'/bin/bash', '-c' and 'echo Init Done - Welcome to xFusionCorp Industries > /ic/blog'`. The volume mount should be named as ic-volume-nautilus and mount path should be `/ic`.

4. Main container should be named as `ic-main-nautilus`, use image debian with latest tag and use command `'/bin/bash', '-c' and 'while true; do cat /ic/blog; sleep 5; done'`. The volume mount should be named as `ic-volume-nautilus` and mount path should be `/ic`.

5. Volume to be named as `ic-volume-nautilus` and it should be an `emptyDir` type.

## Task Summary

This task demonstrates how to use init containers in Kubernetes to handle pre-runtime configuration steps before the main application container starts.

In real-world production environments, applications often depend on preconditions such as configuration generation, file setup, or dependency checks. Since these steps may not be baked into the container image, init containers provide a controlled way to execute them before the main workload runs.

## Objective

Create a Deployment named `ic-deploy-nautilus` with:

- 1 replica
- Label: `app=ic-nautilus`
- An init container that writes a message to a shared volume
- A main container that continuously reads and prints that message
- A shared `emptyDir` volume

## Implementation Steps

### 1. Define the Deployment YAML
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ic-deploy-nautilus
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ic-nautilus
  template:
    metadata:
      labels:
        app: ic-nautilus
    spec:
      initContainers:
      - name: ic-msg-nautilus
        image: debian:latest
        command:
          - /bin/bash
          - -c
          - echo Init Done - Welcome to xFusionCorp Industries > /ic/official
        volumeMounts:
        - name: ic-volume-nautilus
          mountPath: /ic

      containers:
      - name: ic-main-nautilus
        image: debian:latest
        command:
          - /bin/bash
          - -c
          - while true; do cat /ic/official; sleep 5; done
        volumeMounts:
        - name: ic-volume-nautilus
          mountPath: /ic

      volumes:
      - name: ic-volume-nautilus
        emptyDir: {}
```

### 2. Apply the Deployment
```
kubectl apply -f deployment.yaml
```

### 3. Verify Resources

Check if the pod is running:
```
kubectl get pods
```
Inspect logs from the main container:
```
kubectl logs <pod-name>
```

You should see:
```
Init Done - Welcome to xFusionCorp Industries
```

## Outcome

- The pod is created successfully with one init container and one main container
- The init container runs first and writes the message to the shared volume
- The main container starts only after the init container completes
- The main container continuously displays the message written by the init container

## Key Takeaways

- Init containers run to completion before the main application container starts
- `emptyDir` volumes can be used to share data between init and main containers
- Init containers are useful for setup tasks that cannot be included in the application image
- Kubernetes enforces strict execution order between init containers and main containers