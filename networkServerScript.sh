#!/bin/bash

# ======= Configurable Variables =======
REPO_URL="https://github.com/ProjectIndra/networkServer.git"
APP_DIR="/home/avinash/servers/networkServer"
APP_PORT=3000
# ======================================

# Clone or pull the latest changes from the repository
if [ ! -d "$APP_DIR" ]; then
    echo "[*] Directory not found, cloning repository..."
    git clone "$REPO_URL" "$APP_DIR"
else
    echo "[*] Directory found, pulling latest changes..."
    cd "$APP_DIR" || exit 1
    git pull origin master
fi

cd "$APP_DIR" || exit 1

# Run poetry install to install dependencies
echo "[*] Installing dependencies using poetry..."
/home/avinash/.local/bin/poetry install --no-root

# Set up the .env file if it doesn't already exist
if [ ! -f ".env" ]; then
    echo "[*] Creating .env file..."
    cat <<EOF > .env
REDIS_HOST="localhost"
REDIS_PORT=6379
REDIS_DB=0
ENDPOINT="34.170.133.5:51820"
SUDO_PASSWORD="sadasdasdasd"
EOF
fi

# Change permissions of /etc/wireguard folder to 777
echo "[*] Changing permissions of /etc/wireguard to 777..."
sudo chmod 777 /etc/wireguard

# Run the server directly with Poetry
echo "[*] Running server... (Poetry)"
lsof -ti tcp:$APP_PORT | xargs -r kill -9
export $(grep -v '^#' .env | xargs)
/home/avinash/.local/bin/poetry run python server.py > >(tee -a /home/avinash/network_server.log > /dev/null) 2>&1 &

echo "[*] Server started in background."
