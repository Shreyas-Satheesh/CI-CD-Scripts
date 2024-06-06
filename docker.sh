#!/bin/bash

# Update the package index
sudo apt update &&

# Install prerequisites
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release &&

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg &&

# Set up the stable repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null &&

# Update the package index again
sudo apt update &&

# Install Docker Engine, Docker CLI, and Containerd
sudo apt install -y docker-ce docker-ce-cli containerd.io &&

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose &&

# Apply executable permissions to the Docker Compose binary
sudo chmod +x /usr/local/bin/docker-compose &&

# Create a symbolic link to /usr/bin
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose &&

# Verify Docker installation
sudo systemctl status docker &&

# Add current user to Docker group (this allows running Docker without sudo)
sudo usermod -aG docker $USER &&

# Print Docker and Docker Compose versions
sudo docker --version &&
sudo docker-compose --version &&
sudo docker run hello-world

# Prompt user to logout and log back in to apply Docker group changes
echo "Please log out and log back in to apply the Docker group changes."
