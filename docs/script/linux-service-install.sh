#!/bin/sh
# Usage: NAME=myservice EXEC_CMD="run -a 1 -b 2" sh my-service-install.sh
# curl -sfL http://seccmd.net/tld/script/linux-service-install.sh | \
# NAME=myservice \
# EXEC_CMD="run -a 1 -b 2" sh -

SERVICE_NAME="${NAME:-myservice}"
COMMAND="${EXEC_CMD:-/bin/true}"

cat <<EOF > /etc/systemd/system/$SERVICE_NAME.service
[Unit]
Description=$SERVICE_NAME
After=network.target

[Service]
ExecStart=/bin/sh -c "$COMMAND"
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable "$SERVICE_NAME"
systemctl start "$SERVICE_NAME"

echo "$SERVICE_NAME installed and started!"
