#!/bin/bash

# Documentation: https://ubuntu.com/server/docs/service-openssh
# Tutorial video: https://www.youtube.com/watch?v=Wlmne44M6fQ

# Update machine
sudo apt update
sudo apt upgrade

# Install ssh
sudo apt install openssh-server

# Check if ssh is enabled
sudo systemctl status ssh
#ctr+C to exit

# Allow firewall ssh
sudo ufw allow ssh

# Get the IP address.
ip a
#OR
sudo apt install net-tools
ifconfig
#The ip is the eno1 inet
# New command for IP address:
ip address show

# Generate public/private key pair
ssh-keygen
# Press enter on first line without typing anything to save it on the suggested folder
# Enter password of choice

# Now there are two keys on the folder .ssh/id_rsa.
# Show public key
cat .ssh/id_rsa.pub
# Show private key
cat .ssh/id_rsa
# Cat copies file to another location. If nothing specified, default is prompted on terminal screen.
