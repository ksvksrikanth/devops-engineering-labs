#!/bin/bash
set -eux

dnf install -y httpd
systemctl enable --now httpd
echo "Custom VPC EC2 lab provisioned by Terraform" > /var/www/html/index.html
