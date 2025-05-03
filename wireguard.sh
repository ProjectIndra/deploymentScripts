#!/bin/bash

set -e

echo "[*] Installing WireGuard..."
sudo apt install -y wireguard

echo "[*] Verifying installation..."
if command -v wg > /dev/null && command -v wg-quick > /dev/null; then
    echo "[✓] WireGuard installed and ready to use."
else
    echo "[!] WireGuard installation failed."
    exit 1
fi
