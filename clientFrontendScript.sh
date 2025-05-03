#!/bin/bash

# ======= Configurable Variables =======
REPO_URL="https://github.com/ProjectIndra/clientFrontend.git"
APP_DIR="/home/avinash/servers/frontend"
BRANCH="feature/uiux-improvment"
BACKEND_LINK="http://localhost:5000"
LOG_FILE="/home/avinash/frontend.log"
PORT=3000
# ======================================

# Kill any process using port 3000
echo "[*] Killing any process running on port $PORT..."
lsof -ti tcp:$PORT | xargs -r kill -9 2>&1 | tee -a "$LOG_FILE" > /dev/null

# Clone or update the repository
if [ ! -d "$APP_DIR" ]; then
    echo "[*] Cloning repository..."
    git clone --branch "$BRANCH" "$REPO_URL" "$APP_DIR"
else
    echo "[*] Pulling latest changes..."
    cd "$APP_DIR" || exit 1
    git fetch origin "$BRANCH"
    git reset --hard "origin/$BRANCH"
fi

export REACT_APP_MG_SERVER="$BACKEND_LINK"

cd "$APP_DIR" || exit 1

# Check if build folder exists
if [ ! -d "build" ]; then
    echo "[!] Error: 'build/' directory not found in the repository. Aborting."
    exit 1
fi

# Install 'serve' globally if not already installed
if ! command -v serve &> /dev/null; then
    echo "[*] Installing 'serve' globally..."
    npm install -g serve
fi

# Serve the React build
echo "[*] Serving React app from build/ on http://localhost:$PORT"
serve -s build -l "$PORT" > /dev/null 2>> "$LOG_FILE" &
