# Day 95 - Create Security Group Using Terraform

## Task Objective

Create an AWS Security Group named `xfusion-sg` in the **default VPC** within the `us-east-1` region using Terraform.

The security group must:

* Allow **HTTP (80)** from `0.0.0.0/0`
* Allow **SSH (22)** from `0.0.0.0/0`

Terraform working directory:

```bash
/home/bob/terraform
```

> A `provider.tf` file is already provided, so only create the `main.tf`.

---

### Step 1: Create the `main.tf` File

```bash
sudo vi main.tf
```

Add the following configuration:

```hcl
# Fetch the default VPC
data "aws_vpc" "default" {
  default = true
}

# Create Security Group
resource "aws_security_group" "xfusion_sg" {
  name        = "xfusion-sg"
  description = "Security group for Nautilus App Servers"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "xfusion-sg"
  }
}
```

Save and exit the file.



### Step 2: Initialize Terraform

```bash
terraform init
```

This downloads the AWS provider plugins defined in the existing `provider.tf`.


### Step 3: Validate the Configuration

```bash
terraform validate
```

Expected output:

```bash
Success! The configuration is valid.
```

### Step 4: Preview the Deployment

```bash
terraform plan
```

Review the resources Terraform will create.


### Step 5: Apply the Configuration

```bash
terraform apply -auto-approve
```

Terraform will create:

* `xfusion-sg` security group
* HTTP inbound rule on port 80
* SSH inbound rule on port 22

### Step 6: Verify the Security Group

```bash
aws ec2 describe-security-groups --group-names xfusion-sg --region us-east-1
```

Verify that:

* The security group name is `xfusion-sg`
* HTTP and SSH rules are attached
* The resource exists in the default VPC

