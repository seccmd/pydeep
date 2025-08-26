#!/bin/sh
# Usage: NAME=myservice sh my-service-uninstall.sh
# curl -sfL https://example.com/linux-service-uninstall.sh | NAME=myservice sh -

SERVICE_NAME="${NAME:-myservice}"

echo "Stopping $SERVICE_NAME ..."
systemctl stop "$SERVICE_NAME"

echo "Disabling $SERVICE_NAME ..."
systemctl disable "$SERVICE_NAME"

echo "Resetting failed state for $SERVICE_NAME ..."
systemctl reset-failed "$SERVICE_NAME"

SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"
if [ -f "$SERVICE_FILE" ]; then
    echo "Removing service file $SERVICE_FILE ..."
    rm -f "$SERVICE_FILE"
else
    echo "Service file $SERVICE_FILE not found, skipping removal."
fi

echo "Reloading systemd daemon ..."
systemctl daemon-reload

echo "$SERVICE_NAME uninstalled successfully!"
