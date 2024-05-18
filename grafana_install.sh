#!/bin/bash

# Function to handle errors
handle_error() {
    echo "Error on line $1"
    exit 1
}

# Trap errors and call handle_error function
trap 'handle_error $LINENO' ERR

# Update package list
echo "Updating package list..."
sudo apt-get update

# Install necessary packages
echo "Installing necessary packages..."
sudo apt-get install -y apt-transport-https software-properties-common wget

# Download Grafana GPG key
echo "Downloading Grafana GPG key..."
sudo wget -q -O /usr/share/keyrings/grafana.key https://apt.grafana.com/gpg.key

# Add Grafana repository to sources list
echo "Adding Grafana repository to sources list..."
echo "deb [signed-by=/usr/share/keyrings/grafana.key] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list

# Update package list again
echo "Updating package list again..."
sudo apt-get update

# Install Grafana
echo "Installing Grafana..."
sudo apt-get install -y grafana

# Start Grafana server
echo "Starting Grafana server..."
sudo systemctl start grafana-server

# Enable Grafana server to start on boot
echo "Enabling Grafana server to start on boot..."
sudo systemctl enable grafana-server

# Check Grafana server status
echo "Checking Grafana server status..."
sudo systemctl status grafana-server

# Additional service management commands
echo "Starting Grafana server service..."
sudo service grafana-server start

echo "Restarting Grafana server service..."
sudo service grafana-server restart

# Check if Grafana is running
if systemctl is-active --quiet grafana-server; then
    echo "Grafana is successfully installed and running."
else
    echo "There was an issue installing or starting Grafana."
    exit 1
fi
