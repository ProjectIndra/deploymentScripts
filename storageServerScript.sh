#!/bin/bash

# ========== Configuration ==========
REPO_URL="https://github.com/ProjectIndra/storageServer.git"
APP_DIR="/home/avinash/servers/storageServer"
APP_PORT=2000
LOG_FILE="/home/avinash/storage_server.log"
# ===================================

# Kill any existing process using the port
echo "[*] Checking for processes using port $APP_PORT..."
PID=$(lsof -t -i:$APP_PORT)
if [ -n "$PID" ]; then
    echo "[*] Killing process $PID using port $APP_PORT"
    kill -9 "$PID"
fi

# Clone or pull the repo
if [ ! -d "$APP_DIR" ]; then
    echo "[*] Cloning repo..."
    git clone "$REPO_URL" "$APP_DIR"
else
    echo "[*] Pulling latest changes..."
    cd "$APP_DIR" || exit 1
    git pull origin master
fi

cd "$APP_DIR" || exit 1

# Initialize Poetry if pyproject.toml or poetry.lock is not found
if [ ! -f "pyproject.toml" ] && [ ! -f "poetry.lock" ]; then
    echo "[*] pyproject.toml or poetry.lock not found, initializing Poetry..."
    /home/avinash/.local/bin/poetry init --no-interaction
    /home/avinash/.local/bin/poetry add flask
else
    echo "[*] pyproject.toml or poetry.lock found, skipping Poetry initialization."
fi

# Install dependencies using Poetry
echo "[*] Installing dependencies using Poetry..."
/home/avinash/.local/bin/poetry install --no-root

# Run the Flask app using Poetry and log output
echo "[*] Starting Flask server on port $APP_PORT..."
/home/avinash/.local/bin/poetry run flask --app server.py run --host=0.0.0.0 --port=$APP_PORT > "$LOG_FILE" 2>&1 < /dev/null &

echo "[✅] Server started on port $APP_PORT, logging to $LOG_FILE"
