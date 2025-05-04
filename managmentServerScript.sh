#!/bin/bash

# ======= Configurable Variables =======
REPO_URL="https://github.com/ProjectIndra/managementServer.git"  # Change this to your repo URL
APP_DIR="/home/avinash/servers/managmentServer/"   # Path where the repo should be cloned
APP_PORT=5000
# ======================================

# Clone or pull the latest changes from the repository
if [ ! -d "$APP_DIR" ]; then
    echo "[*] Directory not found, cloning repository..."
    git clone "$REPO_URL" "$APP_DIR"
else
    echo "[*] Directory found, pulling latest changes..."
    cd "$APP_DIR" || exit 1
    git pull origin main  # Replace "main" with the correct branch if needed
fi

cd "$APP_DIR" || exit 1

# Run poetry install to install dependencies
echo "[*] Installing dependencies using poetry..."
/home/avinash/.local/bin/poetry install --no-root

# Set up the .env file if it doesn't already exist
if [ ! -f ".env" ]; then
    echo "[*] Creating .env file..."
    cat <<EOF > .env
MONGO_URI="mongodb+srv://kumarsubrato:tIwCh1TWkWtiFhpq@cluster0.j0fgs.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"
SECRET_KEY=''
HDFS_SERVER='http://localhost:2000'
NETWORK_SERVER='http://localhost:3000'
PROMETHEUS_CONFIG_PATH='/home/subroto/prometheus/prometheus-3.3.0-rc.0.linux-amd64/prometheus_conf.yml'
EOF
fi

# Run the Flask app directly with Poetry
echo "[*] Running Flask app..."
lsof -ti tcp:5000 | xargs -r kill -9
export $(grep -v '^#' .env | xargs)

/home/avinash/.local/bin/poetry run flask --app server.py run --host=0.0.0.0 --port $APP_PORT > >(tee -a /home/avinash/management_server.log > /dev/null) 2>&1 &
