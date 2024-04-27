#!/bin/bash

# Banner Display
echo "---------------------------------------------"
echo " WELCOME TO WINNODE PINGPONG SETUP"
echo "---------------------------------------------"

# Install Docker on Ubuntu if not installed and always download PINGPONG file from GitHub

# Stop on any error
set -e

# Step 1: Update the system
echo "Updating system packages..."
sudo apt update
sudo apt upgrade -y

# Check if Docker is already installed
if ! command -v docker &> /dev/null
then
    # Step 2: Install required packages
    echo "Installing required packages..."
    sudo apt install apt-transport-https ca-certificates curl software-properties-common screen -y

    # Step 3: Add Docker's official GPG key
    echo "Adding Docker's official GPG key..."
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    # Step 4: Add Docker repository
    echo "Adding Docker repository..."
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Step 5: Update apt package index
    echo "Updating apt package index..."
    sudo apt update

    # Step 6: Install Docker Engine
    echo "Installing Docker Engine..."
    sudo apt install docker-ce docker-ce-cli containerd.io -y

    # Step 7: Verify Docker Installation
    echo "Checking Docker status..."
    sudo systemctl status docker

    # Step 8: Run Docker without sudo (Optional)
    echo "Adding current user to Docker group..."
    sudo usermod -aG docker ${USER}
    echo "Please log out and back in to apply group changes, or run 'su - ${USER}'"

    # Step 9: Test Docker Installation
    echo "Testing Docker installation with hello-world container..."
    docker run hello-world
else
    echo "Docker is already installed. Skipping installation..."
fi

# Check if screen is installed
if ! command -v screen &> /dev/null
then
    # Step 10: Install screen if not installed
    echo "Screen is not installed. Installing screen..."
    sudo apt install screen -y
else
    echo "Screen is already installed. Skipping installation..."
fi

# Always execute file download
echo "Downloading PINGPONG file..."
curl -L https://pingpong-build.s3.ap-southeast-1.amazonaws.com/linux/latest/PINGPONG -o PINGPONG
echo "File download completed successfully!"

# Ask for the device ID from the user
echo "Please enter your device ID:"
read device_id

# Make PINGPONG executable
echo "Making PINGPONG executable..."
chmod +x ./PINGPONG

# Create and detach a screen session to run PINGPONG
echo "Starting PINGPONG in a new screen session..."
screen -dmS PingpongSession ./PINGPONG --key $device_id

echo "PINGPONG is running in a detached screen session named 'PingpongSession'."
echo "To attach to the screen session, use 'screen -r PingpongSession'."
echo "Script completed!"
