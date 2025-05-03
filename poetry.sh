#!/bin/bash

# ======= Configurable Variables =======
POETRY_VERSION="2.1.1"  # Set the version you want
# ======================================

echo "[*] Installing Poetry version $POETRY_VERSION..."

# Download and install Poetry
curl -sSL https://install.python-poetry.org | python3 - --version $POETRY_VERSION

# Ensure poetry is available globally
export PATH="$HOME/.local/bin:$PATH"

# Verify installation
echo "[*] Verifying Poetry installation..."
poetry --version

echo "[✅] Poetry $POETRY_VERSION has been successfully installed."
