#!/bin/bash

# 默认配置（可修改）
GOST_VERSION="v2.12.0"
LISTEN_URL="socks5+tls://user:pass@:443"
SERVICE_NAME="gost"
SYSTEMD_SERVICE="/etc/systemd/system/${SERVICE_NAME}.service"

# 提示用户输入配置（可选：改为脚本参数传入）
echo "=== GOST 一键部署脚本 ==="
echo "默认监听: $LISTEN_URL"
read -p "请输入监听地址 (如 socks5+tls://user:pass@:443): " input_listen
LISTEN_URL=${input_listen:-$LISTEN_URL}

# 确认
echo
echo "将使用以下配置启动 GOST:"
echo "  监听地址: $LISTEN_URL"
read -p "确认继续? [Y/n] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]] && [[ ! -z "$REPLY" ]]; then
    echo "已取消。"
    exit 1
fi

# 检查是否为 root
if [[ $EUID -ne 0 ]]; then
   echo "错误: 此脚本必须以 root 权限运行。请使用 sudo 或切换到 root 用户。" 
   exit 1
fi

# 安装 wget 和 tar（如果未安装）
command -v wget >/dev/null 2>&1 || { echo "正在安装 wget..."; apt update && apt install -y wget || yum install -y wget; }
command -v tar >/dev/null 2>&1 || { echo "正在安装 tar..."; apt install -y tar || yum install -y tar; }

# 下载并安装 gost
echo "正在下载 gost $GOST_VERSION ..."
wget -qO /tmp/gost.tar.gz "https://github.com/ginuerzh/gost/releases/download/$GOST_VERSION/gost_${GOST_VERSION#v}_linux_amd64.tar.gz"
if [ $? -ne 0 ]; then
    echo "下载失败，请检查网络或版本是否存在。"
    exit 1
fi

# 解压并安装
cd /tmp
tar -xzf gost.tar.gz gost
cp gost /usr/bin/gost
chmod +x /usr/bin/gost
rm -f /tmp/gost.tar.gz /tmp/gost

# 创建 systemd 服务文件
echo "创建 systemd 服务文件: $SYSTEMD_SERVICE"
cat > $SYSTEMD_SERVICE << EOF
[Unit]
Description=GOST Proxy Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/gost -L=$LISTEN_URL
Restart=on-failure
RestartSec=10s
User=nobody
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

# 重载 systemd 配置
systemctl daemon-reload

# 设置开机自启并启动服务
systemctl enable $SERVICE_NAME.service
systemctl start $SERVICE_NAME.service

# 检查状态
sleep 3
if systemctl is-active --quiet $SERVICE_NAME; then
    echo "✅ GOST 服务已成功启动！"
    echo "📌 监听地址: $LISTEN_URL"
    echo "🔧 开机自启已启用。"
    echo "📋 查看日志: systemctl status $SERVICE_NAME"
else
    echo "❌ GOST 启动失败，请检查配置或运行 systemctl status $SERVICE_NAME 查看详情。"
    exit 1
fi

# 清理
rm -rf /tmp/gost*

exit 0
