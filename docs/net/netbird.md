# 基于Netbird开源平台独立部署



[资讯：全球CFO遭钓鱼攻击，黑客利用合法工具NetBird实施精准打击](https://www.wolai.com/hNNZXsKCFfjdiHCaXK8jDd)

[鱼叉式钓鱼警报：NetBird 远程访问木马借虚假招聘传播](https://www.wolai.com/cdBBXGAGhM7sP4u2oVbAgX)

[告别复杂配置！NetBird助你轻松构建安全私有网络](https://www.wolai.com/3xcjJPFkyQTD47LQ2nA6HA)

[15.1k star！告别复杂网络配置！NetBird让企业异地组网变得超简单](https://www.wolai.com/wNj4Vv74osbfSfP7F5prFV)


以下是一套基于Netbird开源平台的独立部署实施方案，适用于搭建私有网络实验环境。方案结合官方文档和社区实践，涵盖环境准备、服务端部署、客户端接入、网络配置及维护全流程，确保高效安全。

***

## **一、环境准备**

1. **服务器要求**

   * **配置**：Linux VM（推荐Debian/Ubuntu/CentOS），最低1核CPU、2GB内存、10GB存储。

   * **网络**：

     * 开放 **TCP端口**：80（HTTP）、443（HTTPS）、33073（管理）、10000（信令服务）。
     * 开放 **UDP端口**：3478（STUN/TURN）、49152-65535（P2P通信）。

   * **域名**：需准备一个指向服务器公网IP的域名（如`netbird.example.com`），并提前配置DNS解析。

2. **依赖软件**
   * 安装Docker与Docker Compose（推荐最新版）：

```Bash
curl -fsSL https://get.docker.com | sh
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

```
- 安装工具包：`jq`（JSON处理）、`curl`（网络请求）：  
```

```Bash
sudo apt install -y jq curl  # Debian/Ubuntu
sudo yum install -y jq curl  # CentOS/RHEL
```

***

## **二、服务端部署**

### **步骤1：一键安装NetBird**

```Bash
export NETBIRD_DOMAIN=netbird.example.com  # 替换为你的域名
curl -fsSL https://github.com/netbirdio/netbird/releases/latest/download/getting-started-with-zitadel.sh | bash
```

* **输出结果**：脚本自动生成管理员账号（如`admin@netbird.example.com`）和随机密码，保存至终端。

* **自动完成**：

  * 部署NetBird管理服务、Signal服务、STUN/TURN服务（Coturn）、Zitadel身份认证服务。
  * 申请Let's Encrypt SSL证书，启用HTTPS加密。

### **步骤2：访问管理控制台**

1. 登录URL：`https://<你的域名>`（如`https://netbird.example.com`）。

2. **初始配置**：

   * 修改默认密码，启用双因素认证（2FA）。
   * 添加新用户（支持本地账号或集成OIDC提供商如Google/Azure AD）。

### **自定义配置（可选）**

* **禁用单账户模式**：编辑`docker-compose.yml`，在`management`服务中添加`--disable-single-account-mode`参数。
* **反向代理**：若需与Nginx Proxy Manager集成，修改`docker-compose.yml`中的端口映射（如将Dashboard端口从443改为8011）。

***

## **三、客户端接入**

### **安装客户端**

* **Linux/macOS**：

```Bash
curl -fsSL https://pkgs.netbird.io/install.sh | sh
sudo netbird up --setup-key=<管理控制台生成的Setup Key>
```

* **Windows**：
  * 下载安装包：访问`https://pkgs.netbird.io/windows`，安装后输入Setup Key。
* **移动端**：
  * Android/iOS应用商店搜索“NetBird”，扫码管理控制台的二维码加入网络。

### **验证连接**

```Bash
netbird status --detail  # 查看设备状态、分配的IP（如100.64.0.2）
ping 100.64.0.3         # 测试与其他客户端的连通性
```

***

## **四、网络实验环境配置**

### **1. 访问控制策略**

* **创建策略组**：按部门/项目分组（如`dev-group`、`prod-group`）。

* **配置规则**：

  * 允许`dev-group`访问测试服务器IP（如`100.64.1.0/24`）。
  * 禁止非工作时间访问生产环境。

### **2. 站点间互联（SD-WAN）**

* **路由配置**：
  * 在管理控制台的 **Network Routes** 中添加静态路由（如`192.168.1.0/24` → 目标Peer IP）。
* **防火墙设置**：

```Bash
# 启用IP伪装（Masquerade）确保跨网段通信
firewall-cmd --add-masquerade --permanent
firewall-cmd --reload
```

### **3. 中继模式优化**

* **严格NAT环境**：在客户端设置中启用 **Relay Mode**，强制流量经TURN服务器中转。
* **自建中继节点**：在多地部署NetBird Relay服务，提升跨区域速度。

***

## **五、维护与监控**

1. **备份数据**

   * 配置文件：复制安装目录下的`docker-compose.yml`、`management.json`等文件。
   * 数据库：备份Zitadel（PostgreSQL）和管理服务（CockroachDB）数据。

2. **升级版本**

```Bash
cd /netbird-install-dir
docker-compose pull  # 拉取新镜像
docker-compose up -d  # 重启服务
```

```
**注意**：需先检查[https://github.com/netbirdio/netbird/releases是否含破坏性变更。](https://github.com/netbirdio/netbird/releases是否含破坏性变更。)  
```

3. **故障排查**

   * 查看日志：`docker-compose logs -f signal`（信令服务）或`management`（管理服务）。
   * 监控仪表盘：实时查看设备状态、流量拓扑、连接延迟。

***

## **六、高级功能扩展**

* **Kubernetes集成**：通过[https://github.com/netbirdio/kubernetes-operator管理容器网络。](https://github.com/netbirdio/kubernetes-operator%E7%AE%A1%E7%90%86%E5%AE%B9%E5%99%A8%E7%BD%91%E7%BB%9C%E3%80%82)
* **量子安全加密**：启用Rosenpass协议（Post-Quantum VPN）。
* **API自动化**：调用管理服务的REST API实现策略批量配置。

***

## **总结**

此方案可在**15分钟内**完成NetBird私有网络部署，具备以下优势：

✅ **零配置组网**：自动NAT穿透，无需手动开放端口或配置路由。

✅ **企业级安全**：端到端WireGuard加密 + SSO/MFA集成。

✅ **跨平台支持**：全设备（包括OpenWRT路由器）无缝接入。

✅ **成本优化**：自托管避免云服务费用，资源占用低于传统VPN。

遇到问题可查阅[https://docs.netbird.io/或加入https://join.slack.com/t/netbirdio/shared\_invite/zt-31rofwmxc-27akKd0Le0vyRpBcwXkP0g获取支持。](https://docs.netbird.io/%E6%88%96%E5%8A%A0%E5%85%A5https://join.slack.com/t/netbirdio/shared_invite/zt-31rofwmxc-27akKd0Le0vyRpBcwXkP0g%E8%8E%B7%E5%8F%96%E6%94%AF%E6%8C%81%E3%80%82)
