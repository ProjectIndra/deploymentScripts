#!/bin/bash

set -e

echo "[*] Installing Redis..."
sudo apt install -y redis-server

echo "[*] Verifying installation..."
if command -v redis-server > /dev/null && command -v redis-cli > /dev/null; then
    echo "[✓] Redis installed and ready to use."
else
    echo "[!] Redis installation failed."
    exit 1
fi

echo "[*] Starting Redis service..."
sudo systemctl enable redis-server
sudo systemctl start redis-server

echo "[✓] Redis service started and enabled at boot."
