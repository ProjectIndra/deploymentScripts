#!/bin/bash

# ======= Configurable Variables =======
NODE_VERSION="18.20.8"  # Node.js version to install
# ======================================

# Update package list
echo "[*] Updating package list..."
sudo apt update -y

# Install dependencies
echo "[*] Installing dependencies..."
sudo apt install -y curl gnupg2 lsb-release ca-certificates

# Add NodeSource repository for the specific Node.js version
echo "[*] Adding NodeSource repository for Node.js $NODE_VERSION..."
curl -fsSL https://deb.nodesource.com/setup_$NODE_VERSION.x | sudo -E bash -

# Install Node.js and npm
echo "[*] Installing Node.js $NODE_VERSION and npm..."
sudo apt install -y nodejs

# Install npm explicitly if it's not installed
echo "[*] Installing npm explicitly..."
sudo apt install -y npm

# Verify installation
echo "[*] Verifying Node.js and npm installation..."
node -v
npm -v

echo "[*] Node.js $NODE_VERSION and npm installed successfully."
