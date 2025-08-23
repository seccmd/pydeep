#!/bin/bash

# Default configuration
GOST_VERSION="v2.12.0"
LISTEN_URL="socks5+tls://tld_User:tld_pAssw0rd@:443"
SERVICE_NAME="gost"
SYSTEMD_SERVICE="/etc/systemd/system/${SERVICE_NAME}.service"

# Print header
echo "=== GOST One-Click Deployment Script ==="
echo "Default listen URL: $LISTEN_URL"

if [[ ! $REPLY =~ ^[Yy]$ ]] && [[ ! -z "$REPLY" ]]; then
    echo "Installation canceled."
    exit 1
fi

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
   echo "Error: This script must be run as root. Please use sudo or switch to the root user."
   exit 1
fi

# Install wget and tar if not present
if ! command -v wget &> /dev/null; then
    echo "Installing wget..."
    if command -v apt &> /dev/null; then
        apt update && apt install -y wget tar
    elif command -v yum &> /dev/null; then
        yum install -y wget tar
    else
        echo "Error: Neither apt nor yum package manager found. Please install wget and tar manually."
        exit 1
    fi
fi

# Download and install GOST
echo "Downloading GOST $GOST_VERSION..."
DOWNLOAD_URL="https://github.com/ginuerzh/gost/releases/download/${GOST_VERSION}/gost_${GOST_VERSION#v}_linux_amd64.tar.gz"
wget -qO /tmp/gost.tar.gz "$DOWNLOAD_URL"

if [ $? -ne 0 ]; then
    echo "Download failed. Please check your network or verify the release version exists."
    exit 1
fi

# Extract and install
cd /tmp
tar -xzf gost.tar.gz gost
cp gost /usr/bin/gost
chmod +x /usr/bin/gost
rm -f /tmp/gost.tar.gz /tmp/gost

# Create systemd service file
echo "Creating systemd service: $SYSTEMD_SERVICE"
cat > "$SYSTEMD_SERVICE" << EOF
[Unit]
Description=GOST Proxy Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/gost -L=$LISTEN_URL
Restart=on-failure
RestartSec=10s
User=root
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd, enable and start service
systemctl daemon-reload
systemctl enable "$SERVICE_NAME.service"
systemctl start "$SERVICE_NAME.service"

# Wait and check status
sleep 3
if systemctl is-active --quiet "$SERVICE_NAME"; then
    echo "✅ GOST service started successfully!"
    echo "📌 Listen Address: $LISTEN_URL"
    echo "🔧 Auto-start on boot is enabled."
    echo "📋 View logs: systemctl status $SERVICE_NAME"
else
    echo "❌ Failed to start GOST. Check configuration or run: systemctl status $SERVICE_NAME"
    exit 1
fi

# Cleanup
rm -rf /tmp/gost*

exit 0
