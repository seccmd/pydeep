# Frp

高速主机：[https://my.vultr.com/](https://my.vultr.com/)
账号：github

高速区域：都在西海岸

- [Seattle](https://my.vultr.com/subs/?id=fa6d948d-0e13-4569-a708-f4397634fbda) 西雅图
- [Silicon Valley](https://my.vultr.com/subs/?id=fcbc093f-9d14-4c03-b172-fd1d0a7ebe1d) 硅谷
- Los Angeles 洛杉矶

```
# host config - /etc/frp/frpc.toml
serverAddr = "xl6455c.glddns.com"
serverPort = 1433
loginFailExit = false   # 登陆连接失败，继续尝试连接
auth.method = "token"
auth.token = ""

[[proxies]]
name = "sockes5"
type = "tcp"
remotePort = 1081
[proxies.plugin]
type = "socks5"
```

```
# docker-compose
services:
  frpc:
    image: snowdreamtech/frpc
    container_name: frpc
    restart: always
    network_mode: host
    volumes:
      - /etc/frp/frpc.toml:/etc/frp/frpc.toml
```
