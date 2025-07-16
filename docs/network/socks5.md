# SOCKS5 服务器

<https://github.com/rofl0r/microsocks>

```text
microsocks -1 -q -i listenip -p port -u user -P passw -b bindaddr -w wl
```

所有参数都是可选的。默认情况下，listenip 为 0.0.0.0，端口为 1080。

* 选项 -q 禁用日志记录。
* 选项 -b 指定传出连接绑定到哪个 ip
* 选项 -w 允许指定以逗号分隔的 IP 地址白名单，这些 IP 地址可以使用代理而无需用户/密码身份验证。例如 -w 127.0.0.1,192.168.1.1.1,::1 或仅 -w 10.0.0.1 仅允许访问这些 IP，选择一个不可能猜测的用户/密码组合。
* 选项 -1 激活 auth\_once 模式：一旦特定 IP 地址使用用户/密码成功验证，它将被添加到白名单中，并且可以在未验证的情况下使用代理。这对于不支持用户/密码验证的程序（如 Firefox）非常方便。为了使其工作，您基本上需要与支持它的另一个程序建立一个连接，然后您也可以使用 Firefox。例如，使用 curl 进行一次身份验证： curl --socks5 用户:密码@listenip:端口 anyurl

## SOCKS5功能

* 身份验证：无、密码、一次性
* IPv4、IPv6、DNS
* TCP（目前没有 UDP）
