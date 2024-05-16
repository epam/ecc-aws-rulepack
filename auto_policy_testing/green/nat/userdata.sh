#!/bin/bash
sudo yum update -y
sudo yum install -y amazon-linux-extras
sudo amazon-linux-extras enable nginx1
sudo amazon-linux-extras install nginx1
sudo systemctl start nginx.service
sudo systemctl enable nginx.service 