# 实践 Headscale Tailscale

对比多种网络打通方案：[链接地址](https://mp.weixin.qq.com/s?__biz=MzI0NTU1MTA5MA==\&mid=2247487999\&idx=1\&sn=039bcccab192e995d7bd043f3f9c7802\&chksm=e873b0c5b672096d6cb4bf8bb36f6d1f36e5507ccf455d4a54fd77d62523e8b7eb4759fecaf7\&mpshare=1\&scene=1\&srcid=0715FpXD8A6SPB8ojte3TUQl\&sharer_shareinfo=b21aee4e622b53f4a17c0c8b45c78cc7\&sharer_shareinfo_first=b21aee4e622b53f4a17c0c8b45c78cc7#rd)

### **主流工具横向对比：Easytier到底牛在哪？**

废话不多说，直接上表格，让你一目了然。

|特性|Easytier|ZeroTier / Tailscale|FRP / Natapp|Cloudflare Tunnel|
|-|-|-|-|-|
|**核心原理**|P2P虚拟局域网|P2P虚拟局域网|端口转发|端口转发/虚拟网络|
|**配置复杂度**|**极低**|低|**高**|中等|
|**依赖公网IP**|**需要（但可共用）**|不需要|**需要**|不需要|
|**中心化依赖**|**完全去中心化**|**依赖官方控制器**|自建服务端，半中心化|依赖Cloudflare|
|**安全性/隐私**|**极高（流量端到端加密）**|高（依赖官方）|中等（取决于自己配置）|高（依赖Cloudflare）|
|**使用场景**|个人/小团队私有网络|个人/企业级便捷组网|将内网服务暴露到公网|将服务接入CF生态|
|**我的评价**|简单、私密、自由|**最方便**  ，但有束缚|功能强大，但**太折腾**|免费用户的福音，但有绑定|


**一句话总结：**

- • **FRP**：适合需要将服务（如网站）明确暴露到公网的场景。
- • **ZeroTier/Tailscale**：追求极致方便，不介意依赖第三方服务的个人和团队首选。
- • **Cloudflare Tunnel**：如果你已经是Cloudflare用户，用它整合服务体验极佳。
- • **Easytier**：**想要ZeroTier的方便，又想要FRP的自主可控，那么Easytier就是为你量身定做的。**



## 服务端Headscale - Using packages for Debian/Ubuntu (recommended)

```Bash
# Install
https://headscale.net/stable/setup/install/official/

# Download - https://github.com/juanfont/headscale/releases/latest
HEADSCALE_VERSION="0.26.1" # See above URL for latest version, e.g. "X.Y.Z" 
HEADSCALE_ARCH="amd64"

wget --output-document=headscale.deb \
 "https://github.com/juanfont/headscale/releases/download/v${HEADSCALE_VERSION}/headscale_${HEADSCALE_VERSION}_linux_${HEADSCALE_ARCH}.deb"

sudo apt install ./headscale.deb
sudo nano /etc/headscale/config.yaml
sudo systemctl enable --now headscale
sudo systemctl status headscale

# 只测试配置以下选项 /etc/headscale/config.yaml
server_url: http://47.76.253.98:8080
listen_addr: 0.0.0.0:8080
```

```Markdown
# Usage
https://headscale.net/stable/usage/getting-started/

# Show help
headscale help
# Show help for a specific command
headscale <COMMAND> --help

headscale users list
headscale users create <USER>

# 注册方式一 Normal, interactive login
tailscale up --login-server <YOUR_HEADSCALE_URL>
headscale nodes register --user <USER> --key <YOUR_MACHINE_KEY>

# 注册方式二 Using a preauthkey
headscale preauthkeys create --user <USER>

tailscale up --login-server http://47.76.253.98:8080 --authkey <YOUR_AUTH_KEY>
```

## Headscale - Using standalone binaries (advanced)

* 还没有测试。

## Headscale - Running headscale in a container

<https://headscale.net/stable/setup/install/container/>

## 客户端 tailscale

```Markdown
# Download
https://tailscale.com/download/linux

# Linux install
curl -fsSL https://tailscale.com/install.sh | sh


# todo 测试 直接下载 deb 包
```

Windows 客户端

```Markdown
# Windows - 安装失败
https://pkgs.tailscale.com/stable/tailscale-setup-latest.exe

# 安装msi包，成功
https://pkgs.tailscale.com/stable/#windows

# 管理员权限
Stop-Service Tailscale
Start-Service Tailscale

# 测试一个小时，一直卡着，无法认证
tailscale logout
tailscale down
Stop-Service -Name "Tailscale"
Remove-Item -Path "$env:ProgramData\Tailscale\*.state" -Force
tailscale up  --login-server http://47.76.253.98:8080 --accept-dns=false

# ！！！！！！ 终于搞定了，必须打开 Tailscal图形界面，右下角小图标！！！！！！
```

## Debug

```Markdown
# 检查服务状态
systemctl status tailscaled  # 应为 active (running)

# 查看实时日志
journalctl -u tailscaled -f

# 测试节点连通性
tailscale ping <另一节点IP>
```

## 问题

```Bash
/etc/default/tailscaled 配置文件丢失

启动参数需要 --port=${PORT} $FLAGS 默认值？
ExecStart=/usr/sbin/tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/run/tailscale/tailscaled.sock --port=41641

# /etc/default/tailscaled
PORT=41641  # 默认值可省略
FLAGS="--login-server=http://your-headscale-ip:8080"
```
