terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}


#AWS provider
/*provider "aws" {
  region     = "us-west-2"
}*/


resource "aws_instance" "my_webserver" {
  ami           = "ami-0bea529386a62a2ad"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform!" > /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
EOF

}


resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "Allow HTTPS inbound traffic and all outbound traffic"


  tags = {
    Name = "allow_tls"
  }
}


# -------------------------
# HTTPS - IPv4
# -------------------------
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.my_webserver.id
  cidr_ipv4         = "0.0.0.0/0"

  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
}


# -------------------------
# HTTPS - IPv6
# -------------------------
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
  security_group_id = aws_security_group.my_webserver.id
  cidr_ipv6         = "::/0"

  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
}


# -------------------------
# Allow all outbound IPv4
# -------------------------
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.my_webserver.id
  cidr_ipv4         = "0.0.0.0/0"

  ip_protocol = "-1"
}


# -------------------------
# Allow all outbound IPv6
# -------------------------
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.my_webserver.id
  cidr_ipv6         = "::/0"

  ip_protocol = "-1"
}