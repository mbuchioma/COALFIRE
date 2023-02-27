#!/bin/bash
yum update -y
yum install httpd -y 
systemctl start httpd
systemctl enable httpd
echo "<html><body><h1><Welcome to Chioma's Demo><h/1></body></html>" > /var/www/html/index.html