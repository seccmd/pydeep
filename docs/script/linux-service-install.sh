#!/bin/sh
#
# Generic Linux systemd service installer (POSIX sh compatible)
# Usage:
#   export SERVICE_NAME=easytier
#   export SERVICE_EXEC="/opt/EasyTier/easytier-linux-x86_64/easytier-core -d -p udp://IP:11010"
#   curl -sfL http://seccmd.net/tld/script/linux-service-install.sh | sh -
#

set -e

if [ -z "$SERVICE_NAME" ] || [ -z "$SERVICE_EXEC" ]; then
    echo "❌ ERROR: You must set environment variables SERVICE_NAME and SERVICE_EXEC first."
    echo "Example:"
    echo "  export SERVICE_NAME=myapp"
    echo "  export SERVICE_EXEC=\"/usr/local/bin/myapp --flag xxx\""
    exit 1
fi

SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"

echo "📝 Creating systemd service: $SERVICE_FILE"

cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=$SERVICE_NAME service
After=network.target

[Service]
ExecStart=$SERVICE_EXEC
Restart=always
RestartSec=5
User=root
WorkingDirectory=/root

[Install]
WantedBy=multi-user.target
EOF

echo "✅ Service file created: $SERVICE_FILE"

# Reload systemd and enable service
systemctl daemon-reload
systemctl enable "$SERVICE_NAME"
systemctl restart "$SERVICE_NAME"

echo "🚀 $SERVICE_NAME has been installed and started."
systemctl status "$SERVICE_NAME" --no-pager
