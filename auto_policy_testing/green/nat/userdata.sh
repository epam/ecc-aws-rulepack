#!/bin/bash
# Generate NAT gateway traffic on boot (helps ecc-aws-573 green)
ping -c 20 google.com || true
ping -c 20 aws.amazon.com || true

sudo yum update -y
sudo yum install -y amazon-linux-extras
sudo amazon-linux-extras enable nginx1
sudo amazon-linux-extras install nginx1
sudo systemctl start nginx.service
sudo systemctl enable nginx.service
