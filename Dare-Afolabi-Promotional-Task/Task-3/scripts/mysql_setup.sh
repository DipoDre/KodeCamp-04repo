#!/bin/bash

# Updating packages
apt-get update

# Installing packages
apt-get install -y mysql-server mysql-client

# Start and enable MySQL service
sudo systemctl start mysql
sudo systemctl enable mysql

