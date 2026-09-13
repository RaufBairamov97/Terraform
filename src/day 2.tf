terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
/*provider "aws" {
  region = "us-east-1"
}*/

provider "aws" {
  region     = "us-west-2"

}


resource "aws_instance" "ec2-instanceRauf" {
  ami           = "ami-0bea529386a62a2ad"
  instance_type = "t3.micro"

  tags = {
    Name = "EC2_instance_RaufVafa"
  }
}


# # Create a VPC
# resource "aws_vpc" "example" {
#   cidr_block = "10.0.0.0/16"
# }