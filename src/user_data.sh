#!/bin/bash

yum update -y
yum install -y httpd

systemctl enable httpd
systemctl start httpd

echo "<h1>WebServer</h1>" > /var/www/html/index.html
echo "<p>Built by Terraform!</p>" >> /var/www/html/index.html