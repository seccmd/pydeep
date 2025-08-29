# EasyTier

- https://easytier.cn/

## Linux 客户端 一键自动部署

```bash
# linux easytier download
# InstDir: /opt/EasyTier/easytier-linux-x86_64
curl -sfL http://seccmd.net/tld/script/install-easytier.sh | sh -

# linux service easytier
# Conf: /etc/systemd/system/easytier.service
export SERVICE_NAME=easytier
export SERVICE_EXEC="/opt/EasyTier/easytier-linux-x86_64/easytier-core -d -p udp://IP:11010 --network-name my-network --network-secret my-secret"
curl -sfL http://seccmd.net/tld/script/linux-service-install.sh | sh -
```

## Windows 客户端 一键自动部署

```powershell
# Install Windows service
New-Service -Name easytier -StartupType Automatic -BinaryPathName "D:\easytier\easytier-core -d -p tcp://IP:11010 -p udp://IP:11010 --network-name my-network --network-secret my-secret"
Start-Service easytier

# 删除服务
# 首先停止服务（如果它正在运行）
Stop-Service -Name easytier -Force
# 然后删除服务
sc.exe delete easytier
```

## 自建服务端操作

```bash
# 服务端-启动命令
easytier-core --ipv4 10.145.145.1 --private-mode true --network-name my-network --network-secret my-secret
```

## 客户端联网操作

```bash
easytier-core -d -p udp://ip_addr:11010 --network-name my-network --network-secret my-secret
easytier-core -d -p udp://ip_addr:11010 --network-name my-network --network-secret my-secret
```

## 下载安装版本 v2.4.2

```markdown
windows:
https://ghfast.top/https://github.com/EasyTier/EasyTier/releases/download/v2.4.2/easytier-gui_2.4.2_x64-setup.exe

linux:
https://github.com/EasyTier/EasyTier/releases/download/v2.4.2/easytier-linux-x86_64-v2.4.2.zip

mips:
https://ghfast.top/https://github.com/EasyTier/EasyTier/releases/download/v2.4.2/easytier-linux-mipsel-v2.4.2.zip
```

## 防火墙开放端口

```bash
# 协议  默认端口 - 路由器映射
TCP  11010 (TCP)
UDP  11010 (UDP)
WebSocket  11011 (TCP)
WebSocket SSL  11012 (TCP)
WireGuard  11013 (UDP)

# 私有网络 开放1080
gost -L socks5://:1080 -I tun0 &
sudo ufw allow from 10.145.145.0/24 to any port 1080
```
