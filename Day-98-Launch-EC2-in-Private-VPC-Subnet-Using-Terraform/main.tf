resource "aws_vpc" "private_vpc" {
  cidr_block = var.KKE_VPC_CIDR

  tags = {
    Name = "datacenter-priv-vpc"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.private_vpc.id
  cidr_block              = var.KKE_SUBNET_CIDR
  map_public_ip_on_launch = false

  tags = {
    Name = "datacenter-priv-subnet"
  }
}

resource "aws_security_group" "private_sg" {
  name   = "datacenter-priv-sg"
  vpc_id = aws_vpc.private_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.KKE_VPC_CIDR]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "private_ec2" {
  ami                    = "ami-test"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]

  tags = {
    Name = "datacenter-priv-ec2"
  }
}