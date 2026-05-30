# Day 96 - Create EC2 Instance Using Terraform

## Task Summary

Provision an AWS EC2 instance using Terraform with the following requirements:

- Instance Name: `xfusion-ec2`
- AMI: `ami-0c101f26f147fa7fd`
- Instance Type: `t2.micro`
- Create RSA Key Pair: `xfusion-kp`
- Attach the default security group
- Use only `main.tf` in `/home/bob/terraform`


## Solution Steps

### Step 1: Create `main.tf`

```hcl
resource "tls_private_key" "xfusion_kp" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "xfusion_kp" {
  key_name   = "xfusion-kp"
  public_key = tls_private_key.xfusion_kp.public_key_openssh
}

data "aws_security_group" "default" {
  name = "default"
}

resource "aws_instance" "xfusion_ec2" {
  ami                    = "ami-0c101f26f147fa7fd"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.xfusion_kp.key_name
  vpc_security_group_ids = [data.aws_security_group.default.id]

  tags = {
    Name = "xfusion-ec2"
  }
}
```

### Step 2: Initialize Terraform

```bash
terraform init
```

This downloads the required providers and initializes the working directory.


### Step 3: Validate the Configuration

```bash
terraform validate
```

Expected output:

```text
Success! The configuration is valid.
```

### Step 4: Review the Execution Plan

```bash
terraform plan
```

Verify that Terraform will create:

- RSA key pair `xfusion-kp`
- EC2 instance `xfusion-ec2`


### Step 5: Apply the Configuration

```bash
terraform apply -auto-approve
```

Terraform provisions:

- RSA private/public key
- AWS key pair
- EC2 instance using the specified AMI
- Default security group attachment

### Step 6: Verify Resources

```bash
terraform state list
```

Expected resources:

```text
aws_instance.xfusion_ec2
aws_key_pair.xfusion_kp
tls_private_key.xfusion_kp
```
![Terraform apply and show list](./images/terraform%20apply%20and%20state%20list.png)


You can also verify the instance details:

```bash
terraform state show aws_instance.xfusion_ec2
```

## Key Terraform Concepts Practiced

- AWS EC2 provisioning
- RSA key generation with `tls_private_key`
- AWS Key Pair creation
- Data sources (`aws_security_group`)
- Resource dependencies
- Tagging AWS resources
- Infrastructure as Code (IaC)