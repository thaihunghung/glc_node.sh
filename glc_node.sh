#!/bin/bash

# Ensure script is run as root
if [ "$(id -u)" != "0" ]; then
    echo "This script needs to be run with root user privileges."
    echo "Please try using 'sudo -i' to switch to the root user, and then run this script again."
    exit 1
fi

# Check and install required tools (figlet and toilet) and Docker
function setup_environment() {
    echo "Checking and installing required tools..."
    
    # Install figlet and toilet for styled text
    if ! command -v figlet &> /dev/null; then
        echo "Installing figlet..."
        sudo apt-get update
        sudo apt-get install -y figlet
    fi
    if ! command -v toilet &> /dev/null; then
        echo "Installing toilet..."
        sudo apt-get install -y toilet
    fi

    # Install Docker
    if ! command -v docker &> /dev/null; then
        echo "Docker not detected, installing..."
        sudo apt-get update
        sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
        sudo apt-get update
        sudo apt-get install -y docker-ce
    fi
}

# Display styled "WibuCrypto" and run Glacier Verifier
function run_wibucrypto_validator() {
    clear
    toilet -f future "WibuCrypto" --gay
    echo
    echo "Welcome to WibuCrypto Validator Setup!"
    echo

    # Prompt for Private Key
    read -p "Input Your PrivateKey (EVM): " YOUR_PRIVATE_KEY
    if [ -z "$YOUR_PRIVATE_KEY" ]; then
        echo "Private Key cannot be empty. Please run the script again and provide a valid private key."
        exit 1
    fi

    # Pull Docker image
    echo "Pulling the latest Docker image for glaciernetwork/glacier-verifier:v0.0.1..."
    docker pull docker.io/glaciernetwork/glacier-verifier:v0.0.3

    # Run Docker container
    docker run -d \
        -e PRIVATE_KEY=$YOUR_PRIVATE_KEY \
        --name glacier-verifier \
        docker.io/glaciernetwork/glacier-verifier:v0.0.3

    echo "Glacier Verifier container started successfully with the provided private key."
}

# Execute script
setup_environment
run_wibucrypto_validator
