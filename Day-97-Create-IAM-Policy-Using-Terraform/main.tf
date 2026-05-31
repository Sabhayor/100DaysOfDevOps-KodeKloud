terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

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