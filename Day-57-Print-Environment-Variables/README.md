# Day 57 - Print Environment Variables

## Task Summary
The objective is to create a Kubernetes Pod that defines and uses environment variables within a container. The container should print a formatted greeting message using these variables and exit successfully without restarting.

This simulates a real-world scenario where applications rely on environment variables for configuration (e.g., service names, environments, or branding).


### Environment Details:

Define a Pod named `print-envars-greeting` with:
- Container name: `print-env-container`
- Image: `bash`
- Three environment variables:
  - `GREETING=Welcome to`
  - `COMPANY=Nautilus`
  - `GROUP=Ltd`
- Command to print values
- Restart policy set to `Never`


## Solution Steps

### 1. Create Pod Definition

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: print-envars-greeting
spec:
  restartPolicy: Never
  containers:
    - name: print-env-container
      image: bash
      command: ["/bin/sh", "-c", 'echo "$(GREETING) $(COMPANY) $(GROUP)"']
      env:
        - name: GREETING
          value: "Welcome to"
        - name: COMPANY
          value: "Nautilus"
        - name: GROUP
          value: "Ltd"
```

### 2. Apply the Configuration

```bash
kubectl apply -f pod.yaml
```

---

### 3. Verify Pod Execution

Check pod status:

```bash
kubectl get pods
```

### 4 .Fetch logs to confirm output:

```bash
kubectl logs -f print-envars-greeting
```

### Expected Output

```bash
Welcome to Nautilus Ltd
```
![Environmental variables](./images/Day%2057.png)
---

### Outcome
- Pod `print-envars-greeting` is created successfully
- Container prints the greeting message using environment variables
- Output is displayed in pod logs as: `Welcome to Nautilus Ltd`
- Pod completes execution and does not restart
- No CrashLoopBackOff occurs

## Key Takeaway
- Environment variables can be injected directly into Pods
- Containers can access environment variables at runtime
- `restartPolicy:` Never is useful for one-time or batch jobs
- `kubectl logs` is used to capture container output
- Kubernetes Pods can be used for simple task execution and validation
