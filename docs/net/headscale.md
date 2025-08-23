# Headscale 是一款开源自托管的 Tailscale

## 一、网络主流工具选型对比

> 深入学习[https://headscale.net/stable/ref/configuration/](https://headscale.net/stable/ref/configuration/)

> Usage <https://headscale.net/stable/usage/getting-started/> 本身支持Remote CLI，默认无admin 管理界面，使用第三方的。

> Headscale - Running headscale in a container <https://headscale.net/stable/setup/install/container/>

对比多种网络打通方案：[链接地址](https://mp.weixin.qq.com/s?__biz=MzI0NTU1MTA5MA==\&mid=2247487999\&idx=1\&sn=039bcccab192e995d7bd043f3f9c7802\&chksm=e873b0c5b672096d6cb4bf8bb36f6d1f36e5507ccf455d4a54fd77d62523e8b7eb4759fecaf7\&mpshare=1\&scene=1\&srcid=0715FpXD8A6SPB8ojte3TUQl\&sharer_shareinfo=b21aee4e622b53f4a17c0c8b45c78cc7\&sharer_shareinfo_first=b21aee4e622b53f4a17c0c8b45c78cc7#rd)

### **主流工具横向对比**

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



## 二、拓扑图 Tailscale

```markdown
                            +-----------------------+
                            |      Headscale        |
                            | (Control Server)      |
                            | - 用户认证/ACL管理    |
                            | - 节点协调            |
                            +-----------+-----------+
                                        | (HTTPS API)
                                        |
+------------------------+    +---------v---------+    +------------------------+
|      Node1-PC          |    |      DERP         |    |      Node3-VPS         |
| (Windows/Linux)        <----+ (中继服务器)       +----> (云服务器/公网IP)     |
| - 100.xx.xx.xx         |    | - TCP流量转发      |    | - 100.xx.xx.xx         |
| - 子网路由(可选)       |    | - 加密盲转发       |    | - 出口节点(Exit Node)  |
+------------------------+    +---------+---------+    +------------------------+
                                        |
                                        |
                            +-----------v---------+
                            |      Node2-Mac      |
                            | (macOS/iOS)        |
                            | - 100.xx.xx.xx     |
                            | - 移动端访问       |
                            +---------------------+
```


### Node 节点清单

Headscale 注册服务

- `tailscale up --login-server  https://headscale.home:8443` —hostname=xxx
- DERP: https://rerp.home:8443

Tailscale status

- 100.64.0.1      desktop      u03          windows 
- 100.64.0.4      hk-vps       u03          linux
- 100.64.0.5      office-pc    u03          windows
- 100.64.0.6      imac         u01          macOS 

## 三、客户端安装 tailscale

```markdown
## Windows 安装 - 必须使用msi exe会报错
https://pkgs.tailscale.com/stable/tailscale-setup-1.86.0-amd64.msi

## Linux 安装
curl -fsSL https://tailscale.com/install.sh | sh

## Mac 安装 - 手动开启 tailscale 命令

## 注册服务
tailscale up --login-server https://headscale.home.xxx.com/

## 网络状态
tailscale status
tailscale netcheck

# 管理员权限
Stop-Service Tailscale
Start-Service Tailscale # 开启服务，并且必须打开 Tailscal图形界面，右下角小图标！

# 其他操作
tailscale logout
tailscale down

```

## 四、服务端操作 headscale

```markdown
## 操作命令
headscale users list
headscale users create u01

docker exec -it headscale headscale users create u01
docker exec -it headscale headscale nodes register --user u01 --key <key>

docker exec -it headscale headscale preauthkeys create --user 1 --reusable --expiration 24h
tailscale up --login-server <YOUR_HEADSCALE_URL> --authkey <YOUR_AUTH_KEY>

docker exec -it headscale headscale nodes list
docker exec -it headscale headscale nodes delete -i <ID>


# Debug

# 检查服务状态
systemctl status tailscaled  # 应为 active (running)

# 查看实时日志
journalctl -u tailscaled -f

# 测试节点连通性
tailscale ping <另一节点IP>
```

## 五、Headscale Demo 测试

- Using packages for Debian/Ubuntu (recommended)

```bash
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

```markdown
# Usage
https://headscale.net/stable/usage/getting-started/

headscale users list
headscale users create <USER>

# 注册方式一 Normal, interactive login
client: tailscale up --login-server <YOUR_HEADSCALE_URL>
server: headscale nodes register --user <USER> --key <YOUR_MACHINE_KEY>

# 注册方式二 Using a preauthkey
server: headscale preauthkeys create --user <USER>
client: tailscale up --login-server http://47.76.253.98:8080 --authkey <YOUR_AUTH_KEY>
```




## 六、问题

**退出登录即断开连接​**​：Tailscale 当用户主动退出登录（Log out）时，客户端会立即终止 VPN 连接

- Tailscale配置中，开启Run unattach 配置勾选
- 远程桌面断开后自动关闭：强制会话转移到控制台（本地会话）
    - 在远程桌面连接时，通过CMD执行以下命令：

        `query session# 获取当前会话ID（如ID=1）`

        `tscon 1 /dest:console# 将会话1转移到本地控制台`
    - **原理**：`tscon` 命令将远程会话无缝转移到本地控制台会话，保持所有进程运行，即使断开远程连接也不会终止

**/etc/default/tailscaled 配置文件丢失**

```bash
/etc/default/tailscaled 配置文件丢失

启动参数需要 --port=${PORT} $FLAGS 默认值？
ExecStart=/usr/sbin/tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/run/tailscale/tailscaled.sock --port=41641

# /etc/default/tailscaled
PORT=41641  # 默认值可省略
FLAGS="--login-server=http://your-headscale-ip:8080"
```


## 七、Headscale 技术方案介绍

Headscale 是一款开源自托管的 Tailscale 控制服务器实现，专为追求私有化部署、数据自主可控的用户设计。以下从核心价值、技术特性、部署方案、应用场景等维度系统解析其方案设计：

---

### 🔧 一、核心定位与私有化价值

1. **Tailscale 的替代控制面**  

    Headscale 完全复刻 Tailscale 控制面逻辑，兼容官方客户端，但将控制服务器从 SaaS 云端迁移至用户自有环境，实现：

    - **数据主权**：所有节点注册信息、ACL 策略、通信状态均存储于私有数据库（SQLite/PostgreSQL）；
    - **无设备限制**：开源版本无设备数量或功能限制，企业可自由扩展；
    - **协议兼容性**：基于 WireGuard 协议构建点对点加密隧道，保留高效穿透与低延迟特性。
2. **解决 SaaS 痛点**  

    针对 Tailscale 官方服务的不足：

    - **合规性**：满足金融、政企等场景的本地化部署需求；
    - **网络优化**：自建 DERP 中继节点，避免跨国流量绕行（如国内访问官方节点延迟高）；
    - **自定义扩展**：支持与 LDAP/SSO 集成、自定义 ACL 策略等。

---

### ⚙️ 二、功能特性与技术优势

|**能力模块**|**关键特性**|**技术价值**|
|-|-|-|
|**网络架构**|基于 NAT 穿透的网状拓扑（P2P 优先，中继备用）|减少中转带宽成本，直连延迟低至 10ms 级|
|**认证与权限**|支持预授权密钥、OIDC 单点登录、多命名空间隔离|灵活对接企业 IAM 系统，实现租户隔离|
|**策略控制**|精细化 ACL 策略（按 IP/端口/协议限制访问），MagicDNS 自动域名解析|替代传统防火墙规则，动态管控设备通信|
|**中继服务**|内置或自建 DERP 服务器，支持 UDP/TCP 中继|穿透严格 NAT 环境，提升连接成功率|
|**运维支持**|集成 Prometheus 监控、日志审计、API 驱动自动化|企业级可观测性与自动化运维|


---

### 🚀 三、部署方案与实践路径

#### **1. 基础部署（二进制/Systemd）**

- **适用场景**：单服务器快速部署  
- **步骤概要**：
    1. 下载二进制文件并配置：

```bash
wget https://github.com/juanfont/headscale/releases/download/v0.26.1/headscale_0.26.1_linux_amd64 -O /usr/local/bin/headscale
chmod +x /usr/local/bin/headscale
```
#### 2. 创建配置文件 `/etc/headscale/config.yaml`，关键配置：

```yaml
server_url: https://47.76.253.98  # 公网访问地址
listen_addr: 0.0.0.0:8080
ip_prefixes: [100.64.0.0/10]  # 客户端分配 IP 段
derp:
  server:
    enabled: true
    region_id: 999  # 自定义区域 ID（避免与公共 DERP 冲突）
    region_code: "selfhosted"
    region_name: "Self-hosted DERP"
    stun_listen_addr: "0.0.0.0:3478"  # STUN 服务端口
    private_key_path: /etc/headscale/derp_private.key
noise:
  private_key_path: /etc/headscale/noise_private.key  # 自动生成密钥文件
dns:
  magic_dns: true  # 启用 MagicDNS
  base_domain: "my.local"  # 替换为你的私有域名后缀
  override_local_dns: true
  nameservers:
    global:
      - "1.1.1.1"
      - "8.8.8.8"
# 必须配置的 IP 地址池
prefixes:
  v4: 100.64.0.0/10         # IPv4 地址段（必选）
  # v6: fd7a:115c:a1e0::/48 # 可选 IPv6 段
allocation: sequential      # IP 分配策略（sequential 或 random）

database:
  type: sqlite  # 或 postgres
  sqlite:
    path: /opt/jupyter-lab/headscale/db.sqlite  # SQLite 数据库文件路径
```
#### 3. 通过 Systemd 托管服务。

```bash
headscale users list
headscale users create u01

其他替代方案：使用预授权密钥​
为避免手动注册，可生成预授权密钥（适合自动化部署）：
headscale preauthkeys create -u 1

客户端直接通过密钥连接：此方式无需手动执行 nodes register 命令

tailscale up --login-server=http://47.76.253.98:8080 --authkey 15f46f928e6d5b421c08608f42978253dab8dedc49c5bc8d


```

#### **2. 容器化部署（Docker/K8s）**

- **适用场景**：需弹性扩缩容或集成云原生体系  
- **方案要点**：
    - **Docker Compose**：配置端口映射与持久化卷；
    - **Kubernetes**：通过 Ingress 暴露服务，结合 CSI 存储数据库；
    - **Sealos 一键部署**：云原生应用模板，15 秒完成部署（含可视化控制台）。

#### **3. 客户端接入**

- **命令示例（Linux）**：

```bash
tailscale up --login-server=http://<HEADSCALE_IP>:8080 --accept-dns=false
```

    访问返回的 URL 完成注册，或在 Headscale 执行：

```bash
headscale nodes register --user <命名空间> --key <设备密钥>
```
- **跨平台支持**：Windows/macOS 客户端需修改配置指向自建服务器；Android/iOS 需侧载修改版客户端。

Headscale 客户端的接入方法因操作系统而异，以下是主要平台的详细步骤和注意事项：

---

### **1. Linux 客户端接入**

#### **步骤**：

1. **安装 Tailscale 客户端**  

```bash
wget https://pkgs.tailscale.com/stable/tailscale_1.22.2_amd64.tgz  # 下载对应版本
tar zxvf tailscale_*.tgz
cp tailscale_*/tailscale /usr/bin/tailscale
cp tailscale_*/tailscaled /usr/sbin/tailscaled
chmod +x /usr/bin/tailscale /usr/sbin/tailscaled
```
2. **注册服务并启动**  

```bash
cp tailscale_*/systemd/tailscaled.service /lib/systemd/system/
systemctl enable --now tailscaled
```
3. **连接到 Headscale 服务器**  

```bash
tailscale up --login-server=http://<HEADSCALE_IP>:8080 --accept-dns=false
```
    - 执行后会生成注册链接，在浏览器中打开并在 Headscale 服务端执行类似以下命令完成注册：  

```bash
headscale nodes register --user <USERNAME> --key <KEY>
```

#### **注意事项**：

- 若需非交互式注册，可使用预授权密钥：  

```bash
tailscale up --login-server=http://<HEADSCALE_IP>:8080 --authkey <PREAUTH_KEY>
```

---

### **2. macOS 客户端接入**

#### **步骤**：

1. **安装 Tailscale 客户端**  
    - 通过 [https://tailscale.com/download下载](https://tailscale.com/download下载) macOS 版安装包。
2. **修改客户端配置**（可选）  
    - 编辑配置文件 `/etc/default/tailscaled`，指定 Headscale 服务器地址。
3. **连接 Headscale**  

```bash
tailscale up --login-server=http://<HEADSCALE_IP>:8080
```
    - 后续操作与 Linux 类似，需在服务端批准注册。

---

### **3. Windows 客户端接入**

#### **步骤**：

1. **安装 Tailscale**  
    - 下载 Windows 版安装包并运行。
2. **通过命令行连接**  

```powershell
tailscale.exe up --login-server=http://<HEADSCALE_IP>:8080
```
    - 需在服务端执行注册命令。

---

### **4. 其他平台注意事项**

- **Android/iOS**：  
    - 官方客户端不支持自定义服务器，需自行编译修改。
- **OpenBSD/FreeBSD**：  
    - 与 Linux 步骤类似，需确保内核支持 TUN 设备。

---

### **通用配置建议**

1. **HTTPS 必需性**：  
    - 生产环境建议通过 Nginx/Caddy 反向代理 Headscale 的 `server_url` 为 HTTPS，否则部分功能（如 MagicDNS）可能失效。
2. **预授权密钥**：  
    - 生成一次性或可复用的密钥简化批量部署：  

```bash
headscale preauthkeys create --user <USER> --expiry 24h
```
3. **防火墙规则**：  
    - 确保客户端可访问 Headscale 的监听端口（默认 8080）和 DERP 中继端口（如 UDP 3478）。

---

### **故障排查**

- **注册失败**：检查 `server_url` 是否可达，且服务端日志无报错。
- **NAT 穿透失败**：通过 `tailscale netcheck` 确认是否使用了备用 DERP 中继。

> 更多客户端管理命令（如查看节点、删除设备）可参考 `headscale nodes list` 和 `headscale nodes delete`。



在 Tailscale 中，如果两个节点偶尔处于非 `active` 状态（如 `offline` 或 `idle`），可以通过以下方法手动激活或主动探活：

---

### **1. 强制节点重新连接**

#### **方法 1：使用 ****`tailscale up`**** 重新激活**

在非活跃节点上执行：

```bash
tailscale up --reset
```

- `--reset` 会强制节点重新连接 Tailscale 网络，并尝试重新建立点对点（P2P）或 DERP 中继连接。

#### **方法 2：重启 ****`tailscaled`**** 服务**

```bash
sudo systemctl restart tailscaled  # Linux
```

或（Windows）：

```powershell
Restart-Service Tailscale
```

- 适用于长时间未通信导致的状态异常。

---

### **2. 手动触发 NAT 穿透检查**

执行 `tailscale netcheck` 检查当前网络环境：

```bash
tailscale netcheck
```

- 输出会显示 NAT 穿透状态（如 `UDP blocked` 或 `DERP relay`），帮助判断是否需要调整防火墙或路由器设置。

---

### **3. 使用 ****`ping`**** 或 ****`curl`**** 主动探活**

在节点 A 上主动访问节点 B 的 Tailscale IP：

```bash
ping 100.64.0.4  # 替换为目标节点的 Tailscale IP
```

或测试端口连通性：

```bash
curl http://100.64.0.4:8080  # 测试 HTTP 服务
```

- 主动流量会触发 Tailscale 自动尝试建立连接。

---

### **4. 检查并修复 DERP 中继连接**

如果节点依赖 DERP 中继（如 `relay "selfhosted"`），需确保自建 DERP 服务器正常运行：

```bash
# 在 DERP 服务器上检查服务状态
systemctl status headscale
```

- 如果 DERP 不可用，节点可能无法自动恢复，需修复 DERP 服务或改用官方中继。

---

### **5. 调整 Keepalive 设置（高级）**

在 `/etc/default/tailscaled`（Linux）或注册表（Windows）中增加 Keepalive 间隔：

```Ini
TS_DEBUG_KEEPALIVE=30s  # 默认 60s，缩短可提高活性检测频率
```

- 需重启 `tailscaled` 生效。

---

### **6. 查看日志定位问题**

```bash
journalctl -u tailscaled -f  # Linux 实时日志
```

或（Windows）：

```powershell
Get-EventLog -LogName Application -Source Tailscale* -Newest 10
```

- 关注 `magicsock` 或 `derp` 相关错误，如 `DERP reconnect failed`。

---

### **总结建议**

1. **临时恢复**：优先使用 `tailscale up --reset` 或重启服务。  
2. **长期稳定**：检查防火墙/NAT 规则，确保 UDP 41641 和 DERP 端口（如 3478）开放。  
3. **监控工具**：结合 `tailscale status --json` 输出自动化监控节点状态。

> 若问题持续，提交诊断报告：`tailscale bugreport`，并附上日志。

---

### 🏢 四、企业级扩展场景

1. **混合云组网**  

    打通 AWS/Azure 云主机与本地数据中心，替代专线 VPN，通过 ACL 限制云数据库仅内网访问。
2. **零信任安全体系**  
    - 设备双向认证（WireGuard 密钥 + 用户身份）；
    - 微隔离策略（如研发组仅能访问测试环境 IP 段）。
3. **IoT 设备互联**  

    嵌入式设备（OpenWRT 路由器）接入，实现远程管理与安全更新。

---

### ⚖️ 五、对比选型建议

|**方案**|**自托管复杂度**|**协议性能**|**企业级特性**|**适用场景**|
|-|-|-|-|-|
|**Headscale**|中 ★★☆|WireGuard（用户态）|多租户隔离、ACL 强控|中大型企业、合规严格场景|
|**NetBird**|高 ★★★|WireGuard（内核态）|官方支持完善|需开箱即用、轻量级私有部署|
|**ZeroTier**|低 ★☆☆|自有协议|免费版功能受限|个人或小型团队快速组网|


> ✅ **Headscale 核心优势**：
- **完全自主可控**：从数据存储到流量中转全程私有化；
- **成本优化**：无需按设备付费，中继服务器可复用现有资源；
- **生态兼容**：复用 Tailscale 客户端，降低迁移成本。

---

### ⚠️ 六、注意事项

1. **域名与证书**：必须配置有效域名 + HTTPS（否则客户端注册失败），可通过 Nginx/Caddy 反向代理解决。
2. **NAT 穿透优化**：若直连失败，需检查防火墙放行 UDP 3478 及 49152-65535 端口，或强化 DERP 中继。
3. **高可用设计**：生产环境建议 PostgreSQL 替代 SQLite，并部署多副本 Headscale 服务。

---

**总结**：Headscale 是当前私有化组网方案中**平衡功能、控制权与协议性能的优选**，尤其适合需定制安全策略、规避云服务依赖的企业场景。结合可视化工具 [https://github.com/next-admin/headscale-admin](https://github.com/next-admin/headscale-admin) 可进一步提升管理效率。部署详见 [https://headscale.net/](https://headscale.net/) 及 [https://github.com/juanfont/headscale。](https://github.com/juanfont/headscale。)


## 八、高级选项--advertise-routes 和 -advertise-exit-node 

在 Tailscale/Headscale 中，`--advertise-routes` 和 `--advertise-exit-node` 是两个关键的高级选项，用于扩展虚拟局域网的网络功能。以下是它们的核心作用和使用场景：

---

### 1. **`--advertise-routes`****：子网路由通告**

#### **功能**  

允许节点将其所在的**物理局域网网段**（如家庭/公司内网）共享给 Tailscale 网络中的其他设备，使这些设备能通过虚拟网络访问实际物理网络。

#### **使用场景**  

- **访问家庭NAS**：  

    家庭路由器运行 Tailscale 并通告 `192.168.1.0/24`，外出的手机/笔记本通过 Tailscale 直接访问家庭内网设备，无需额外 VPN 配置。  
- **企业多站点互联**：  

    分支机构的路由器分别通告 `10.1.0.0/24` 和 `10.2.0.0/24`，实现跨地域局域网互通。  
- **混合云组网**：  

    VPS 通告云服务器私有网段（如 `172.16.0.0/16`），本地设备直接访问云内资源。

#### **配置示例**  

```Bash
# 家庭路由器通告本地网段
tailscale up --advertise-routes=192.168.1.0/24 --login-server=https://headscale.example.com

# Headscale 启用路由（需管理员操作）
headscale routes enable -n <命名空间> <节点名> 192.168.1.0/24
```

#### **注意事项**  

- 需在 Headscale 控制端手动审批路由（默认关闭）。  
- 通告的网段不能与 Tailscale 虚拟 IP 段（如 `100.64.0.0/10`）冲突。

---

### 2. **`--advertise-exit-node`****：出口节点通告**

#### **功能**  

将当前节点设为**流量出口**，允许其他 Tailscale 设备通过该节点访问互联网，类似 VPN 的全局代理模式。

#### **使用场景**  

- **安全远程办公**：  

    公司内网设备作为出口节点，员工在外通过该节点访问互联网，流量加密且隐藏真实 IP。  
- **绕过地域限制**：  

    海外 VPS 作为出口节点，实现科学上网（需遵守当地法律）。  
- **移动设备共享蜂窝IP**：  

    手机开启出口节点模式，测试机通过手机流量动态切换 IP（如测试短信接口防刷）。

#### **配置示例**  

```Bash
# 将当前节点设为出口节点
tailscale up --advertise-exit-node --login-server=https://headscale.example.com

# 其他设备使用该出口节点
tailscale up --exit-node=<出口节点IP> --exit-node-allow-lan-access
```

#### **注意事项**  

- 出口节点需开启 IP 转发（Linux 执行 `echo 1 > /proc/sys/net/ipv4/ip_forward`）。  
- 可能显著增加出口节点的流量负载和电池消耗（移动设备）。

---

### 3. **组合使用案例**

#### **家庭网络枢纽**  

- **路由器配置**：  

```bash
tailscale up --advertise-routes=192.168.1.0/24 --advertise-exit-node
```
    - 其他设备可访问家庭内网（如 NAS），同时通过家庭宽带出口上网。  
- **手机临时切换IP**：  

    动态启用手机作为出口节点，测试机通过 `--exit-node` 快速更换公网 IP。

---

### 4. **常见问题**  

- **路由未生效**：  

    检查 Headscale 控制端是否启用路由（`headscale routes list`）。  
- **流量泄露**：  

    若出口节点未正确配置防火墙，可能导致本地网络暴露（建议搭配 `--exit-node-allow-lan-access=false`）。  

通过这两个选项，Tailscale/Headscale 能实现从简单的设备互联到复杂的混合网络架构，满足灵活组网需求。



## 九、--exit-node 如果开启切换出口后，  是不是默认所有请求，都走 新的出口了？



在 Tailscale/Headscale 网络中，当您通过 `--exit-node` 参数指定某个节点为出口节点后，**默认情况下所有互联网流量都会通过该出口节点转发**，但本地局域网（LAN）流量是否经过出口节点取决于额外配置。以下是具体规则和注意事项：

---

### 1. **默认行为：全局流量重定向**

- **所有互联网流量**：  

    启用出口节点后，设备的所有对外互联网请求（如访问百度、GitHub）默认会通过出口节点的公网 IP 流出，您的本地 IP 会被隐藏。
- **配置命令示例**：  

```Bash
tailscale up --exit-node=<出口节点IP>
```

---

### 2. **局域网流量的特殊处理**

- **默认不重定向局域网流量**：  

    Tailscale 默认不会将本地局域网（如 `192.168.1.0/24`）的流量转发到出口节点，而是直接通过本地网络通信。
- **允许局域网流量重定向**：  

    若需强制所有流量（包括局域网）都经过出口节点，需显式添加 `--exit-node-allow-lan-access=true` 参数：  

```Bash
tailscale up --exit-node=<出口节点IP> --exit-node-allow-lan-access=true
```

---

### 3. **例外情况**

- **Tailscale 虚拟网络流量**：  

    与其他 Tailscale 节点的通信（如 `100.x.y.z`）始终为点对点直连（或通过 DERP 中继），不受出口节点影响。
- **按需排除特定流量**：  

    可通过路由策略或 ACL 规则限制某些目标 IP 不经过出口节点（需手动配置）。

---

### 4. **验证流量路径**

- **检查当前路由**：  

    执行以下命令确认流量走向：  

```Bash
tailscale status --exit-node
```

    输出中会显示 `Exit node: <IP>` 和流量统计。
- **测试公网 IP**：  

    访问 [https://ipv4.icanhazip.com](https://ipv4.icanhazip.com) 确认显示的 IP 是否为出口节点的公网 IP。

---

### 5. **注意事项**

- **性能影响**：  

    出口节点可能成为瓶颈，尤其是高延迟或低带宽场景（如跨国节点）。
- **安全风险**：  

    若出口节点被入侵，所有流量可能被监听，建议仅信任自建节点。
- **移动设备耗电**：  

    手机作为出口节点时，电池消耗会显著增加。

---

### 总结

- **默认生效范围**：仅互联网流量，不包括本地局域网。  
- **全流量重定向**：需额外启用 `--exit-node-allow-lan-access`。  
- **Tailscale 节点间流量**：始终独立于出口节点。  

如需临时关闭出口节点，运行 `tailscale up --exit-node=""`。



## 十、如何实现 类似 socks5的效果？  设备A，通过socks5 直接访问设备B的网络。

以下是实现设备A通过SOCKS5代理直接访问设备B网络的几种方法，结合不同技术方案和适用场景：

---

### 一、**基于Tailscale的虚拟局域网方案** 

1. **核心原理**  
    - 使用Tailscale为设备A和设备B创建加密的虚拟局域网（基于WireGuard），所有设备分配`100.x.x.x`固定IP，无需公网IP或端口转发。  
    - 通过子网路由（`--advertise-routes`）将设备B的本地网络暴露给设备A，实现类似SOCKS5的透明代理效果。
2. **配置步骤**  
    - **设备B（服务端）**：  

```Bash
# 启用子网路由（假设设备B的局域网为192.168.1.0/24）
tailscale up --advertise-routes=192.168.1.0/24 --login-server=https://headscale.example.com
```
    - **设备A（客户端）**：  

```Bash
# 接受子网路由并连接
tailscale up --accept-routes --exit-node=<设备B的TailscaleIP>
```
    - **验证**：设备A可直接访问设备B所在局域网的任何服务（如`192.168.1.100:8080`）。
3. **优势**  
    - 零配置NAT穿透，自动建立P2P直连或通过DERP中继。  
    - 端到端加密，无需额外代理工具。

---

### 二、**传统SOCKS5代理搭建方案** 

1. **在设备B上部署SOCKS5服务**  
    - **Python实现**（需设备B安装Python）：  

```Python
import socket, socks
socks.set_default_proxy(socks.SOCKS5, "0.0.0.0", 1080)  # 监听1080端口
socket.socket = socks.socksocket
```
    - **专业工具**：如`Dante`或`3proxy`，支持高性能并发。
2. **设备A配置代理**  
    - **命令行工具**：  

```Bash
curl --socks5 <设备B_IP>:1080 http://内网服务地址
```
    - **全局系统代理**：在设备A的网络设置中填写SOCKS5代理地址（设备B的IP和端口）。
3. **注意事项**  
    - 需在设备B的防火墙放行SOCKS5端口（如1080）。  
    - 若设备B在NAT后，需配置路由器端口转发或使用内网穿透工具（如frp）。

---

### 三、**SSH隧道转SOCKS5（无需额外安装）** 

1. **通过SSH动态端口转发**  
    - 在设备A执行：  

```Bash
ssh -D 1080 user@<设备B_IP>  # 本地1080端口映射为设备B的SOCKS5代理
```
    - 设备A的应用程序配置SOCKS5代理为`127.0.0.1:1080`，所有流量通过设备B转发。
2. **适用场景**  
    - 设备B需运行SSH服务（默认22端口）。  
    - 适合临时访问或安全要求高的环境（SSH自带加密）。

---

### 四、**Docker容器化SOCKS5服务** 

1. **在设备B运行SOCKS5容器**  

```Bash
docker run -d --name=socks5 -p 1080:1080 serjs/go-socks5-proxy
```
2. **设备A通过容器IP访问**  
    - 若设备B的Docker网络为桥接模式，需映射宿主机端口（如`-p 1080:1080`）。

---

### **方案对比**

|方案|适用场景|复杂度|安全性|性能|
|-|-|-|-|-|
|Tailscale子网路由|长期稳定访问，多设备互通|低|高（加密）|高（P2P）|
|传统SOCKS5代理|需兼容老旧应用或特定协议|中|依赖配置|中|
|SSH隧道|临时访问，设备已开放SSH|低|高|中|
|Docker SOCKS5|快速部署，环境隔离|中|中|中|


---

### **推荐选择**

- **优先Tailscale**：若设备B为家庭NAS或企业内网，Tailscale的子网路由最便捷安全。  
- **临时需求**：SSH隧道或轻量SOCKS5容器更灵活。  
- **跨平台兼容**：传统SOCKS5代理适配性最广（如支持游戏客户端）。