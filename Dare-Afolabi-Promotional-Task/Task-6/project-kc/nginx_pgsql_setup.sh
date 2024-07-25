#!/bin/bash

# Update package list and install Nginx
sudo apt-get update
sudo apt-get install -y nginx

# Start and enable Nginx service
sudo systemctl start nginx
sudo systemctl enable nginx

# Allow Nginx through the firewall
sudo ufw allow 'Nginx Full'

# Update package list and install PostgreSQL
sudo apt-get update
sudo apt-get install -y postgresql-common
sudo /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh

# Start and enable PostgreSQL service
sudo systemctl start postgresql.service
sudo systemctl enable postgresql.service