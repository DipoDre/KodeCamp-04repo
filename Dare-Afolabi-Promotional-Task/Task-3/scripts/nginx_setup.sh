#!/bin/bash

# Update package list and install Nginx
sudo apt-get update
sudo apt-get install -y nginx

# Start and enable Nginx service
sudo systemctl start nginx
sudo systemctl enable nginx

# Allow Nginx through the firewall
sudo ufw allow 'Nginx Full'


