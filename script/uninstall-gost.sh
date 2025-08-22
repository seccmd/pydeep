#!/bin/bash

# Simple GOST uninstall script
# Removes GOST service, binary, and systemd configuration

SERVICE_NAME="gost"
BINARY_PATH="/usr/bin/gost"
SYSTEMD_SERVICE="/etc/systemd/system/${SERVICE_NAME}.service"

# Check root
if [ $EUID -ne 0 ]; then
    echo "Error: This script must be run as root." >&2
    exit 1
fi

echo "Stopping $SERVICE_NAME service..."
systemctl stop "$SERVICE_NAME" > /dev/null 2>&1 || true

echo "Disabling $SERVICE_NAME service..."
systemctl disable "$SERVICE_NAME" > /dev/null 2>&1 || true

echo "Removing systemd service file..."
rm -f "$SYSTEMD_SERVICE"

echo "Reloading systemd..."
systemctl daemon-reload

echo "Removing GOST binary..."
rm -f "$BINARY_PATH"

echo "Cleaning up temporary files..."
rm -rf /tmp/gost* > /dev/null 2>&1 || true

echo "GOST has been uninstalled successfully."
exit 0
