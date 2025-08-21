# Gost

- [https://gost.run/getting-started/quick-start/](https://gost.run/getting-started/quick-start/)

# 使用 GOST 搭建 SOCKS5 over TLS 代理

根据 GOST 官方文档，我将为你介绍如何搭建一个本地 SOCKS5 客户端通过 TLS 加密连接到远程 SOCKS5 服务端。

## 服务端配置

首先在服务器上运行 GOST 服务端：

```Bash
gost -L socks5+tls://:443?cert=/path/to/cert.pem&key=/path/to/key.pem
```

参数说明：

- `-L` 表示监听模式
- `socks5+tls` 指定协议类型
- `:443` 监听端口
- `cert` 和 `key` 指定 TLS 证书和私钥路径

如果你没有现成的证书，可以使用自签名证书（仅测试用）：

```Bash
openssl req -x509 -nodes -newkey rsa:2048 -keyout key.pem -out cert.pem -days 365 -subj "/CN=example.com"
```

## 客户端配置

在本地机器上运行 GOST 客户端：

```Bash
gost -L socks5://:1080 -F socks5+tls://server_ip_or_domain:443
```

参数说明：

- `-L socks5://:1080` 在本地 1080 端口启动 SOCKS5 代理
- `-F socks5+tls://...` 指定上游服务器地址

## 验证连接

1. 配置完成后，你可以将浏览器或其他应用的代理设置为 `127.0.0.1:1080` (SOCKS5)
2. 或者使用 curl 测试：

```Bash
curl --socks5 127.0.0.1:1080 https://www.example.com
```

## 高级配置

### 添加认证

如果需要用户名密码认证：

服务端：

```Bash
gost -L socks5+tls://user:pass@:443?cert=/path/to/cert.pem&key=/path/to/key.pem
```

客户端：

```Bash
gost -L socks5://:1080 -F socks5+tls://user:pass@server_ip_or_domain:443
```

### 使用系统代理

在 Windows/macOS 上，可以设置系统代理指向 `127.0.0.1:1080`

### 开机自启

可以将命令添加到系统启动项中，或使用 systemd 服务管理（Linux）

## 注意事项

1. 确保服务器防火墙开放了 443 端口
2. 生产环境建议使用正规 CA 签发的证书
3. 可以结合其他协议如 relay 或 ws 实现更复杂的代理链

希望这个配置对你有帮助！如需更复杂的配置，可以参考 GOST 的官方文档。
