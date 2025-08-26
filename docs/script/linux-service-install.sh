#!/bin/sh

# Use injected env variables or defaults
SERVICE_NAME="${NAME:-myservice}"
EXEC_CMD="${EXECSTART:-/bin/true}"

# Write systemd service file
cat <<EOF > /etc/systemd/system/$SERVICE_NAME.service
[Unit]
Description=$SERVICE_NAME
After=network.target

[Service]
ExecStart=$EXEC_CMD
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and enable/start the service
systemctl daemon-reload
systemctl enable $SERVICE_NAME
systemctl start $SERVICE_NAME
