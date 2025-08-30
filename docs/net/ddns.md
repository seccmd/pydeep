# 搭建 宽带+DDNS+虚拟机公网访问

## 拓扑图

```
【DDNS】--- 【宽带路由 DNAT 53389】 --- 【WindowsPC 53389】 --- 【虚拟机部署3389 + DDNS】
```

## 部署 DDNS-GO

```
https://github.com/jeessy2/ddns-go

1. 从 Releases 下载并解压 ddns-go

2. 安装服务
Mac/Linux: sudo ./ddns-go -s install
Win(以管理员打开cmd): .\ddns-go.exe -s install

```

## 配置 Cloudflare ddns

  - ipv4 ip
  - ipv6 ip 

## win + ipv4 方案

### 宽带路由 DNAT

宽带路由 端口映射配置

```
宽带路由:8443   -   WindowsPC:8443   - 虚拟机:443
宽带路由:53389  -   WindowsPC:53389  - 虚拟机:3389
```

### Windows 直接作为代理入口，公网开放443、3389端口

Windows 系统，代理访问，端口映射

```
# 注意代理类型：v4tov4 v6tov4
netsh interface portproxy show all
netsh interface portproxy add v6tov4 listenport=8443 listenaddress=* connectport=443 connectaddress=192.168.208.10
netsh interface portproxy add v4tov4 listenport=8443 listenaddress=* connectport=443 connectaddress=192.168.208.101
netsh interface portproxy add v6tov4 listenport=53389 listenaddress=* connectport=3389 connectaddress=192.168.208.101
netsh interface portproxy add v4tov4 listenport=53389 listenaddress=* connectport=3389 connectaddress=192.168.208.101
```

## win + ipv6 方案

操作系统开启IPv6协议栈，宽带路由支持的情况下，操作系统的IPv6地址会自动开放到公网访问。

风险：电脑没有开启防火墙，电脑开放了不安全的端口或者弱口令，不知情下暴露到公网。

### 公网 IPv6 地址

```
# 本地 IPv6 方式
Windows: ping -6 ipw.cn
macOS 或 Linux: ping6 ipw.cn

# 查询本机外网IPv4地址
curl 4.ipw.cn

# 查询本机外网IPv6地址
curl 6.ipw.cn

# 测试网络是IPv4还是IPv6访问优先(访问IPv4/IPv6双栈站点，如果返回IPv6地址，则IPv6访问优先)
curl test.ipw.cn
```
