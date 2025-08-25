# GOST Clash Tunnel Deploy

## 一键部署脚本

```bash
# 一键安装 GOST
curl -fsSL https:/www.seccmd.net/tld/script/install-gost.sh | bash

# 一键卸载 GOST
curl -fsSL https:/www.seccmd.net/tld/script/uninstall-gost.sh | bash

# 一键下载配置
curl https:/www.seccmd.net/tld/conf/us-clash.yaml -o us-clash.yaml
```

## 一、GOST 服务端安装部署

### GOST 服务端 任选其一

```bash
下载地址：
GOST v2: https://github.com/ginuerzh/gost/releases
GOST v3: https://github.com/go-gost/gost/releases
```

### GOST 测试命令

```bash
# 服务端VPS，开启加密带认证的代理服务
gost -L socks5+tls://user:pass@:443

# 客户端PC，开启本地socks5代理，并将流量转发到远端服务端VPS
gost -L socks5://:1080 -F socks5+tls://user:pass@server_ip_or_domain:443
```

## 二、Clash 客户端安全部署

保存下文中配置文件，导入 Clash 客户端

### Clash 客户端 任选其一

```markdown
# Clash Verge Rev
Clash Verge Rev下载地址：https://github.com/clash-verge-rev/clash-verge-rev/releases
Clash Verge Rev使用教程：https://clashvergerev.org/

# Clash Nyanpasu
Clash Nyanpasu下载地址：https://github.com/libnyanpasu/clash-nyanpasu/releases
Clash Nyanpasu使用教程：https://clashnyanpasu.org/

# ClashX Meta
ClashX Meta下载地址：https://github.com/MetaCubeX/ClashX.Meta/releases
ClashX Meta使用教程：https://clashxmeta.org/
```

### Clash 客户端 配置文件

```yaml
# 代理节点配置
proxies:
  - name: "socks"
    type: socks5
    server: 192.168.1.20 or xl6455c.glddns.com
    port: 1081
    username: user
    password: pass
    tls: true
    skip-cert-verify: true
    udp: true

# 代理组配置（必需补充）
proxy-groups:
  - name: "PROXY"
    type: select
    proxies:
      - "socks"
      - DIRECT

# 规则配置（国内不转发）
rules:
  - DOMAIN-SUFFIX,local,DIRECT
  - IP-CIDR,127.0.0.0/8,DIRECT
  - IP-CIDR,172.16.0.0/12,DIRECT
  - IP-CIDR,192.168.0.0/16,DIRECT
  - IP-CIDR,10.0.0.0/8,DIRECT

  - DOMAIN-SUFFIX,deepl.com,DIRECT

  - GEOIP,CN,DIRECT
  - MATCH,PROXY
```

> Clash Editor，一个 实验性质 的 Clash 配置文件编辑向导。

- https://clash.skk.moe/

## 三、Homelab 生产部署

### 部署设备 GliNet

```bash
# 开放端口：
1080 - frp  - us vps socks5
1081 - gost - cn socks5+tls

# 部署命令：
gost -L socks5+tls://user:pass@:1081 -F socks5://127.0.0.1:1080

# 检查运行
ps | grep gost
```

### 设置gost开机自启

```bash
#!/bin/sh /etc/rc.common

START=90
STOP=90
USE_PROCD=1
PROC="/mnt/mmcblk0p1/gost/gost -L socks5+tls://user:pass@:1081 -F socks5://127.0.0.1:1080"

start_service() {
        echo start gost
        procd_open_instance
        procd_set_param command $PROC
        procd_set_param respawn
        procd_close_instance
}

service_triggers() {
        procd_add_reload_trigger "rpcd"
}

service gost start
service gost enable
```

## 四、Vultr 测试部署

- https://www.vultr.com/

```bash
# 如果你没有现成的证书，可以使用自签名证书（仅测试用）：

openssl req -x509 -nodes -newkey rsa:2048 -keyout key.pem -out cert.pem -days 365 -subj "/CN=example.com"

# 服务端：

gost -L socks5+tls://user:pass@:443?cert=/path/to/cert.pem&key=/path/to/key.pem

# 客户端：

gost -L socks5://:1080 -F socks5+tls://user:pass@server_ip_or_domain:443

```

### 设置开机自启
```bash
# 设置gost开机自启
touch /etc/systemd/system/gost.service #创建service文件
vi /etc/systemd/system/gost.service #编辑service文件

---

[Unit]
Description=GOST SERVER
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/gost -L=ss://chacha20:passwd@:8338 -F=socks5://ip:7891 # 其中passwd需要修改成你需要的ss的密码，ip是你内网服务器的内网ip。然后保存并退出。
Restart=on-failure
RestartSec=42s

[Install]
WantedBy=multi-user.target

---

# 重新加载配置文件
systemctl daemon-reload
#设置gost开机自启
systemctl enable gost.service
# 启动服务
systemctl start gost.service
# 重启服务
systemctl restart gost.service
## 查看运行状态 ##
systemctl status gost.service
## 实时日志 ##
journalctl -u gost.service -f


# 设置Clash开机自启
touch /etc/systemd/system/clash.service #创建service文件
vi /etc/systemd/system/clash.service #编辑service文件

---

[Unit]
Description=clash daemon

[Service]
Type=simple
User=root
ExecStart=/usr/bin/clash -d /root/.config/clash/
Restart=on-failure

[Install]
WantedBy=multi-user.target

---

# 重新加载配置文件
systemctl daemon-reload
#设置clash开机自启
systemctl enable clash.service
# 启动服务
systemctl start clash.service
# 重启服务
systemctl restart clash.service
## 查看运行状态 ##
systemctl status clash.service
## 实时日志 ##
journalctl -u clash.service -f
内网服务器的透明代理
```
