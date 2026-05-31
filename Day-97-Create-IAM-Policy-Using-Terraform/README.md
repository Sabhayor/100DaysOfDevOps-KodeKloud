# Day 97 - Create IAM Policy Using Terraform

## Task Summary

Create an AWS IAM policy named **`iampolicy_james`** in the **us-east-1** region using Terraform. The policy must provide **read-only access to Amazon EC2**, allowing users to view EC2 instances, AMIs, and snapshots from the AWS Management Console.

---

### Step 1: Create `main.tf`

Add the following configuration:

```hcl
resource "aws_iam_policy" "iampolicy_james" {
  name        = "iampolicy_james"
  description = "Read-only access to EC2 resources"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:Describe*"
        ]
        Resource = "*"
      }
    ]
  })
}
```

### Step 2: Initialize Terraform

```bash
terraform init
```

This downloads the AWS provider and initializes the working directory.


### Step 3: Validate the Configuration

```bash
terraform validate
```

Ensure Terraform reports:

```text
Success! The configuration is valid.
```

### Step 4: Review the Execution Plan

```bash
terraform plan
```

Verify that Terraform will create the IAM policy named **iampolicy_james**.


### Step 5: Create the IAM Policy

```bash
terraform apply -auto-approve
```
![IAM_Policy](./images/kodekloud%20terminal.png)

## Expected Outcome

Terraform creates an IAM policy named:

```text
iampolicy_james
```

with the permission:

```text
ec2:Describe*
```

This grants read-only access to EC2 resources, including:

* EC2 Instances
* Amazon Machine Images (AMIs)
* EBS Snapshots
* Other EC2 metadata and descriptions

