terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Security Group
resource "aws_security_group" "my_webserver" {
  name        = "Dynamic Security Group"
  description = "Security Group with dynamic inbound rules"

  # Dynamic inbound rules
  dynamic "ingress" {
    for_each = [80, 443, 8080, 1541, 9092]

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.10.0.0/16"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "Dynamic-Security-Group"
    Project = "Terraform"
    Owner   = "Rauf Bairamov"
  }
}