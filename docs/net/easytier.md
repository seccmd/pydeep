# EasyTier

- https://easytier.cn/

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
```
