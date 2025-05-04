#!/bin/bash

# Script to install Docker, Docker Compose, add user to Docker group, and start services

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Docker if not installed
if ! command_exists docker; then
    echo "Docker not found. Installing Docker..."
    sudo apt update
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io
else
    echo "Docker is already installed."
fi

# Install Docker Compose if not installed
if ! command_exists docker-compose; then
    echo "Docker Compose not found. Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
else
    echo "Docker Compose is already installed."
fi

# Add the current user to the Docker group
if groups $USER | grep &>/dev/null "\bdocker\b"; then
    echo "User $USER is already in the Docker group."
else
    echo "Adding user $USER to the Docker group..."
    sudo usermod -aG docker $USER
    echo "You need to log out and log back in for the group change to take effect."
fi

# Restart Docker service
echo "Restarting Docker service..."
sudo systemctl restart docker

# Start Docker Compose services
echo "Starting Docker Compose services..."
docker-compose up --build