# Traefik 部署文档

以下是基于 **单服务器节点** 的 Traefik 部署方案，专为 **简单场景**（如本地开发、小型测试环境）设计，兼顾易用性和基本功能。

---

## **单节点 Traefik 部署文档**

### **一、目标与适用场景**

- **目标**：  
    - 快速部署一个轻量级 Traefik 网关，支持服务路由、HTTPS 和 Dashboard。
    - 无需高可用、动态服务发现等复杂功能，适合单节点环境。
- **适用场景**：  
    - 本地开发环境。
    - 小型测试集群（如单台服务器或 Docker Desktop）。
    - 快速验证 Traefik 功能。

---

### **二、部署环境要求**

|组件|版本/要求|
|-|-|
|**操作系统**|Linux（Ubuntu/CentOS）或 Docker Desktop（Windows/macOS）|
|**Docker**|>= 20.10.x|
|**域名**|可选（如需 HTTPS）|


---

### **三、部署步骤**

#### **1. 使用 Docker Compose 部署 Traefik**

创建 `docker-compose.yml` 文件：

```YAML
version: "3"
services:
  traefik:
    image: traefik:v2.11
    container_name: traefik
    ports:
      - "80:80"            # HTTP 入口
      - "443:443"          # HTTPS 入口（可选）
      - "8080:8080"        # Dashboard 端口
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro  # 监听 Docker 事件
      - ./traefik.yml:/etc/traefik/traefik.yml         # 配置文件
      - ./acme.json:/etc/traefik/acme.json             # Let's Encrypt 证书存储
    command:
      - --api.insecure=true                          # 开启 Dashboard（生产环境需关闭）
      - --providers.docker=true                      # 启用 Docker 服务发现
      - --entrypoints.web.address=:80                # HTTP 入口
      - --entrypoints.websecure.address=:443         # HTTPS 入口（可选）
      - --certificatesresolvers.myresolver.acme.email=admin@example.com
      - --certificatesresolvers.myresolver.acme.storage=/etc/traefik/acme.json
      - --certificatesresolvers.myresolver.acme.httpchallenge.entrypoint=web  # HTTP 挑战
```

#### **2. 配置 Traefik 主配置文件 ****`traefik.yml`**

```YAML
# traefik.yml
log:
  level: INFO

entryPoints:
  web:
    address: ":80"
  websecure:
    address: ":443"

providers:
  docker:
    endpoint: "unix:///var/run/docker.sock"
    exposedByDefault: false  # 仅显式标记的服务才会被 Traefik 管理

certificatesResolvers:
  myresolver:
    acme:
      email: admin@example.com
      storage: /etc/traefik/acme.json
      httpChallenge:
        entryPoint: web
```

#### **3. 启动 Traefik**

```Bash
docker-compose up -d
```

---

### **四、接入服务（以 Spring Boot 应用为例）**

假设有一个 Spring Boot 应用，通过以下 `docker-compose.yml` 接入 Traefik：

```YAML
version: "3"
services:
  app:
    image: your-springboot-app:latest
    container_name: springboot-app
    ports:
      - "13080:8080"  # 服务实际端口
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.app.rule=Host(`app.example.com`)"  # 域名规则
      - "traefik.http.services.app.loadbalancer.server.port=8080"  # 服务端口
    networks:
      - traefik
    depends_on:
      - traefik

networks:
  traefik:
    external: true
```

---

### **五、访问与验证**

1. **Traefik Dashboard**  
    - 访问 `http://localhost:8080` 查看服务状态和路由规则。
    - 注意：生产环境需关闭 `--api.insecure=true` 并启用 HTTPS。
2. **服务访问**  
    - 如果使用内网环境，直接访问 `http://localhost:13080`。
    - 如果绑定域名（如 `app.example.com`），需在 DNS 中解析域名到服务器 IP，并通过 `https://app.example.com` 访问（需公网 IP 和域名）。

---

### **六、常见问题与排查**

#### **1. 服务无法访问**

- **原因**：  
    - 服务未加入 `traefik` 网络。
    - `labels` 配置错误（如域名冲突、端口不匹配）。
- **解决**：  
    - 检查服务的 `networks` 是否包含 `traefik`。
    - 确保 `traefik.http.services.app.loadbalancer.server.port` 与服务实际端口一致。

#### **2. HTTPS 证书申请失败**

- **原因**：  
    - 域名未解析到服务器 IP。
    - HTTP 挑战端口 80 被占用或防火墙限制。
- **解决**：  
    - 确保域名解析正确，且服务器 80 端口对外开放。
    - 检查防火墙规则（如 `ufw` 或云服务商安全组）。

#### **3. Dashboard 404**

- **原因**：  
    - 未开启 `--api.insecure=true`。
    - 浏览器缓存或配置未生效。
- **解决**：  
    - 检查 `docker-compose.yml` 中的 `command` 参数。
    - 重启 Traefik 容器并刷新页面。

---

### **七、扩展建议**

1. **启用 HTTPS**  
    - 如果服务器有公网 IP 和域名，可启用 Let's Encrypt 自动申请证书。
    - 修改 `traefik.yml` 中的 `certificatesresolvers` 配置，并确保域名解析正确。
2. **添加中间件**  
    - 通过 `labels` 配置限流、身份验证等中间件：

```YAML
labels:
  - "traefik.http.middlewares.auth.basicauth.users=admin:$$apr1$$H6uskkkW$$IgYV7a8LqGJr0RT5V2y5FQ=="
  - "traefik.http.routers.app.middlewares=auth"
```
3. **日志与监控**  
    - 启用 `log.level: DEBUG` 查看详细日志。
    - 集成 Prometheus 监控（需额外配置）。

---

### **八、总结**

此方案通过 **单节点 Docker 部署** 实现了 Traefik 的基本功能，适合快速验证和小型场景。核心特点包括：

- **简单部署**：仅需 `docker-compose.yml` 和 `traefik.yml`。
- **动态路由**：通过 Docker 标签自动注册服务。
- **HTTPS 支持**：集成 Let's Encrypt（需域名解析）。

如需升级为生产环境，可参考原案中的高可用架构和 ETCD 集群方案。


## === Traefik 极简入门 Demo：快速体验动态路由

只需要两个文件和三条命令，即可运行最简单的 Traefik 测试环境：

## 📂 文件结构

```YAML
traefik-demo/
├── docker-compose.yml    # 核心配置文件
└── index.html            # 测试页面
```

## 🚀 极简配置方案

### 1. 创建项目目录和文件

```Bash
mkdir traefik-demo && cd traefik-demo
touch docker-compose.yml
echo "<h1>Traefik 极简演示成功!</h1>" > index.html
```

### 2. docker-compose.yml 内容

```YAML
version: '3'

services:
  # Traefik 网关
  traefik:
    image: traefik:v2.10
    ports:
      - "80:80"     # HTTP 端口
      - "8080:8080" # 内置 Dashboard
    command:
      - "--api.insecure=true"      # 启用简单 Dashboard
      - "--providers.docker=true"  # 启用 Docker 自动发现
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro

  # 演示网站
  webserver:
    image: nginx:alpine
    volumes:
      - ./index.html:/usr/share/nginx/html/index.html
    labels:
      - "traefik.http.routers.web.rule=Host(`demo.local`)"
```

> 总共只有 **13 行**配置代码！

## ⚡ 启动服务

```Bash
docker-compose up -d
```

## 🌐 访问测试

### 方法 1：修改 hosts 文件（推荐）

```Bash
# 临时添加本地解析（Linux/Mac）
sudo -- sh -c "echo '127.0.0.1 demo.local' >> /etc/hosts"

# Windows 在管理员终端执行：
Add-Content -Path C:\Windows\System32\drivers\etc\hosts -Value "127.0.0.1 demo.local"
```

然后在浏览器访问：[http://demo.local](http://demo.local)

### 方法 2：使用 curl 直接测试

```Bash
# 直接访问（会显示 404，但证明路由生效）
curl -H "Host: demo.local" http://localhost

# 查看容器响应内容
curl -H "Host: demo.local" http://localhost | grep -o "极简演示成功"
```

## 🖥 查看 Dashboard

浏览器访问：[http://localhost:8080](http://localhost:8080)

在 Dashboard 中可看到：

- 当前运行的路由规则
- 后端服务列表
- 实时请求统计

## 🔄 动态添加新服务

不需要修改任何配置，直接在终端运行：

```Bash
# 启动第二个服务（PHP网站）
docker run -d \
  --name php-demo \
  -e PMA_ARBITRARY=1 \
  -p :80 \
  --label "traefik.http.routers.php.rule=Host(\`php.local\`)" \
  php:8.2-apache

# 添加 hosts 解析
sudo -- sh -c "echo '127.0.0.1 php.local' >> /etc/hosts"
```

访问：[http://php.local](http://php.local) → 显示 PHP 信息页

## 🧹 清理环境

```Bash
# 停止并删除所有服务
docker-compose down

# 删除动态创建的服务
docker stop php-demo && docker rm php-demo

# 恢复 hosts 文件
sudo sed -i '/demo.local/d' /etc/hosts
sudo sed -i '/php.local/d' /etc/hosts
```

## 🎯 核心概念总结

|组件|作用|示例|
|-|-|-|
|**Traefik**|智能网关|`image: traefik:v2.10`|
|**路由规则**|请求转发逻辑|`Host(`demo.local`)`|
|**Docker提供者**|自动发现服务|`--providers.docker=true`|
|**标签 (labels)**|动态配置|`traefik.http.routers.web.rule=...`|


通过这个极简 demo，您已经体验了：

1. 自动路由配置（无需手动修改Nginx）
2. 服务动态发现
3. 零配置网关管理
4. 实时流量监控

接下来可以逐步添加 HTTPS、中间件等进阶功能！


## === Traefik 全流程指南

## 从零开始基于 Traefik 搭建 HTTP 服务：全流程指南

下面是从零开始搭建基于 Traefik 的 HTTP 服务的完整流程，包含可操作的详细步骤和验证方法：

## 📦 基础环境准备

```Bash
# 1. 安装 Docker (若未安装)
sudo apt-get update && sudo apt-get install -y docker.io docker-compose

# 2. 创建专用目录和网络
mkdir traefik-http-demo && cd traefik-http-demo
docker network create traefik-net
```

## 🔧 步骤 1：基础 HTTP 服务搭建

### 文件结构

```YAML
traefik-http-demo/
├── docker-compose.yml
└── web/
    └── index.html   # 示例页面
```

### 1.1 创建示例网页

```Bash
mkdir web
echo "<h1>Welcome to Traefik Demo!</h1>" > web/index.html
```

### 1.2 docker-compose.yml

```YAML
version: '3'

services:
  # Traefik 网关
  traefik:
    image: traefik:v2.10
    container_name: traefik
    command:
      - "--log.level=INFO"
      - "--api.insecure=true"         # 启用Dashboard（仅限测试环境）
      - "--providers.docker=true"     # 启用Docker提供者
      - "--providers.docker.exposedbydefault=false" # 禁用自动暴露所有容器
      - "--entrypoints.web.address=:80" # 定义HTTP入口点
    ports:
      - "80:80"       # HTTP
      - "8080:8080"   # Dashboard
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
    networks:
      - traefik-net

  # 示例Web服务（Nginx）
  webapp:
    image: nginx:alpine
    container_name: webapp
    volumes:
      - ./web:/usr/share/nginx/html:ro
    labels:
      - "traefik.enable=true"  # 显式启用Traefik
      - "traefik.http.routers.webapp.rule=Host(`demo.local`)" 
      - "traefik.http.routers.webapp.entrypoints=web" # 使用HTTP入口点
    networks:
      - traefik-net

networks:
  traefik-net:
    external: true
```

### 1.3 启动服务

```Bash
docker-compose up -d
```

### 1.4 测试访问

```Bash
# 添加本地hosts解析（临时）
echo "127.0.0.1 demo.local" | sudo tee -a /etc/hosts

# 访问Web服务
curl http://demo.local
# 应输出: <h1>Welcome to Traefik Demo!</h1>

# 查看Dashboard
curl -I http://localhost:8080/dashboard/
```

## 🚀 步骤 2：添加HTTPS支持

### 2.1 更新 docker-compose.yml

```YAML
services:
  traefik:
    command:
      # ...保留原有参数...
      - "--entrypoints.websecure.address=:443" # 新增HTTPS入口点
      # Let's Encrypt配置
      - "--certificatesresolvers.myletsencrypt.acme.email=your-email@example.com"
      - "--certificatesresolvers.myletsencrypt.acme.storage=/etc/traefik/acme.json"
      - "--certificatesresolvers.myletsencrypt.acme.httpchallenge.entrypoint=web"
    ports:
      - "80:80"        # HTTP
      - "443:443"      # HTTPS（新增）
      # ...保留Dashboard端口...

  webapp:
    labels:
      # ...保留原有标签...
      # 新增HTTPS配置
      - "traefik.http.routers.webapp.tls=true"
      - "traefik.http.routers.webapp.tls.certresolver=myletsencrypt"
    # ...其他保持不变...
```

### 2.2 创建证书存储文件

```Bash
mkdir acme
touch acme/acme.json
chmod 600 acme/acme.json  # 关键权限设置
```

### 2.3 更新volumes挂载

```YAML
services:
  traefik:
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./acme:/etc/traefik/acme  # 持久化存储证书
```

### 2.4 重启服务

```Bash
docker-compose down && docker-compose up -d
```

## 🔐 步骤 3：增强安全性

### 3.1 强制HTTPS重定向

```YAML
services:
  webapp:
    labels:
      # ...保留其他标签...
      # 添加重定向中间件
      - "traefik.http.middlewares.redirect-to-https.redirectscheme.scheme=https"
      - "traefik.http.routers.webapp-http.rule=Host(`demo.local`)"
      - "traefik.http.routers.webapp-http.entrypoints=web"
      - "traefik.http.routers.webapp-http.middlewares=redirect-to-https"
```

### 3.2 添加基础认证（Dashboard）

```Bash
# 生成密码
echo $(htpasswd -nb admin securepassword) | sed -e 's/\$/$$/g'
# 输出示例: admin:$$apr1$$9iGGLzys$$l5B6ZYTXox.SBKP01X3d./
```

```YAML
services:
  traefik:
    command:
      # ...保留原有参数...
      # 添加基础认证
      - "--api.middlewares=dashboard-auth"
      - "--api.middlewares.dashboard-auth.basicauth.users=admin:$$apr1$$9iGGLzys$$l5B6ZYTXox.SBKP01X3d./"
      - "--entrypoints.dashboard.address=:8080"
      - "--api.dashboard=true"
      - "--api.insecure=false"  # 禁用非安全API
    labels:
      - "traefik.enable=true"
      # Dashboard安全路由
      - "traefik.http.routers.dashboard.rule=Host(`traefik.local`)"
      - "traefik.http.routers.dashboard.service=api@internal"
      - "traefik.http.routers.dashboard.middlewares=dashboard-auth"
      - "traefik.http.routers.dashboard.entrypoints=websecure"
      - "traefik.http.routers.dashboard.tls=true"
      - "traefik.http.routers.dashboard.tls.certresolver=myletsencrypt"
```

### 3.3 更新hosts文件

```Bash
echo "127.0.0.1 traefik.local" | sudo tee -a /etc/hosts
```

## 📊 步骤 4：验证服务

### 服务状态检查

```Bash
# 检查容器状态
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# 输出示例：
# NAMES        STATUS        PORTS
# traefik      Up 5 minutes  0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp, 0.0.0.0:8080->8080/tcp
# webapp       Up 5 minutes  80/tcp
```

### HTTP重定向测试

```Bash
# HTTP访问应自动跳转到HTTPS
curl -I http://demo.local

# 应返回：
# HTTP/1.1 302 Found
# Location: https://demo.local/
```

### HTTPS服务验证

```Bash
# HTTPS访问应正常
curl -k https://demo.local

# 证书验证
openssl s_client -connect demo.local:443 -servername demo.local </dev/null 2>/dev/null | openssl x509 -noout -dates

# 输出应包含：
# notBefore=Jul 18 00:00:00 2023 GMT
# notAfter=Oct 16 00:00:00 2023 GMT
```

### Dashboard访问

1. 浏览器访问 [https://traefik.local](https://traefik.local) 
2. 使用用户名 `admin` 和密码 `securepassword` 登录
3. 应看到Traefik Dashboard展示所有路由信息

## 📝 最终 docker-compose.yml

```YAML
version: '3'

services:
  traefik:
    image: traefik:v2.10
    container_name: traefik
    command:
      - "--log.level=INFO"
      - "--providers.docker=true"
      - "--providers.docker.exposedbydefault=false"
      - "--entrypoints.web.address=:80"
      - "--entrypoints.websecure.address=:443"
      - "--certificatesresolvers.myletsencrypt.acme.email=your-email@example.com"
      - "--certificatesresolvers.myletsencrypt.acme.storage=/etc/traefik/acme/acme.json"
      - "--certificatesresolvers.myletsencrypt.acme.httpchallenge.entrypoint=web"
      - "--api.middlewares=dashboard-auth"
      - "--api.middlewares.dashboard-auth.basicauth.users=admin:$$apr1$$9iGGLzys$$l5B6ZYTXox.SBKP01X3d./"
      - "--entrypoints.dashboard.address=:8080"
      - "--api.dashboard=true"
      - "--api.insecure=false"
    ports:
      - "80:80"
      - "443:443"
      - "8080:8080"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./acme:/etc/traefik/acme
    networks:
      - traefik-net
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.dashboard.rule=Host(`traefik.local`)"
      - "traefik.http.routers.dashboard.service=api@internal"
      - "traefik.http.routers.dashboard.middlewares=dashboard-auth"
      - "traefik.http.routers.dashboard.entrypoints=websecure"
      - "traefik.http.routers.dashboard.tls=true"
      - "traefik.http.routers.dashboard.tls.certresolver=myletsencrypt"

  webapp:
    image: nginx:alpine
    container_name: webapp
    volumes:
      - ./web:/usr/share/nginx/html:ro
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.webapp.rule=Host(`demo.local`)"
      - "traefik.http.routers.webapp.entrypoints=websecure"
      - "traefik.http.routers.webapp.tls=true"
      - "traefik.http.routers.webapp.tls.certresolver=myletsencrypt"
      # HTTP重定向中间件
      - "traefik.http.middlewares.redirect-to-https.redirectscheme.scheme=https"
      - "traefik.http.routers.webapp-http.rule=Host(`demo.local`)"
      - "traefik.http.routers.webapp-http.entrypoints=web"
      - "traefik.http.routers.webapp-http.middlewares=redirect-to-https"
    networks:
      - traefik-net

networks:
  traefik-net:
    external: true
```

## 🔄 常用操作命令

```Bash
# 查看Traefik日志
docker logs -f traefik

# 实时路由状态
curl http://localhost:8080/api/http/routers | jq .

# 动态更新配置（无需重启）
docker compose up -d --force-recreate webapp

# 移除服务
docker-compose down --volumes --remove-orphans
```

至此，您已拥有完整的基于 Traefik 的 HTTPS 服务，包含自动证书管理、安全Dashboard访问和HTTP重定向功能。

## === Traefik-Main

docker-compose.yml

```yaml
version: "3"
services:
  traefik:
    image: traefik:v2.10
    container_name: traefik-main
    networks:
      - traefik-net
    ports:
      - "80:80"            # HTTP 入口
      - "443:443"          # HTTPS 入口（可选）
      - "8080:8080"        # Dashboard 端口
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro  # 监听 Docker 事件
      - ./traefik.yml:/etc/traefik/traefik.yml         # 配置文件
      - ./letsencrypt:/letsencrypt             # Let's Encrypt 证书存储
    environment:
      - CLOUDFLARE_EMAIL=admin@qq.com
      - CLOUDFLARE_DNS_API_TOKEN=
      - CLOUDFLARE_ZONE_API_TOKEN=

    command:
      - --api.insecure=true                          # 开启 Dashboard（生产环境需关闭）
      - --api.dashboard=true
      - --entrypoints.dashboard.address=:8080
      - --providers.docker=true                      # 启用 Docker 服务发现
      - --entrypoints.web.address=:80                # HTTP 入口
      - --entrypoints.websecure.address=:443         # HTTPS 入口（可选）
      - --certificatesresolvers.mydnschallenge.acme.tlschallenge=false
      - --certificatesresolvers.mydnschallenge.acme.dnschallenge=true
      - --certificatesresolvers.mydnschallenge.acme.dnschallenge.provider=cloudflare
      - --certificatesresolvers.mydnschallenge.acme.email=admin@qq.cm
      - --certificatesresolvers.mydnschallenge.acme.storage=/letsencrypt/acme.json
# 声明网络（关键！）
networks:
  traefik-net:
    external: true  # 引用外部创建的网络
```

traefik.yml

```yaml
# traefik.yml
log:
  level: INFO

api:
  insecure: true
  dashboard: true
  # debug: true  # 可选，开启调试模式

entryPoints:
  web:
    address: ":80"
  websecure:
    address: ":443"

providers:
  docker:
    endpoint: "unix:///var/run/docker.sock"
    exposedByDefault: false  # 仅显式标记的服务才会被 Traefik 管理

certificatesResolvers:
  mydnschallenge:
    acme:
      email: "admin@qq.cm"
      storage: /letsencrypt/acme.json
      dnsChallenge:
        provider: cloudflare
```
## === vscode-web

docker-compose.yml

```yaml
version: '3.8'

services:
  vscode-web:
    image: codercom/code-server
    container_name: vscode-web
    networks:
      - traefik-net
    ports:
      - ":8080"
    volumes:
      - ./project:/home/coder/project
    environment:
      - PASSWORD=123456789    # Web 登陆密码
    labels:
      - "traefik.enable=true"  # 显式启用
      - "traefik.http.routers.vscode.rule=Host(`vscode.home.xxx.com`)"
      - "traefik.http.services.vscode.loadbalancer.server.port=8080" # 显式声明端口
      #- "traefik.http.middlewares.auth.basicauth.users=admin:$$apr1$$yOgcs058$$hres5BMliUl8A/hGAPhkO1"
      # 应用中间件到路由
      #- "traefik.http.routers.vscode.middlewares=auth"
      - "traefik.http.routers.vscode.entrypoints=websecure"
      - "traefik.http.routers.vscode.tls.certresolver=mydnschallenge"
networks:
  traefik-net:
    external: true
```

## === Jupyter Notebook

```yaml
version: '3'

services:
  jupyter:
    image: jupyter/minimal-notebook:latest
    container_name: my-jupyter
    networks:
      - traefik-net
    ports:
      - ":8888"
    volumes:
      - ./notebooks:/home/jovyan/work
    environment:
      - JUPYTER_ENABLE_LAB=yes
      #- JUPYTER_TOKEN=""
      #- JUPYTER_NOTEBOOK_ARGS=--no-browser --ip=0.0.0.0 --NotebookApp.token=''
    command:
      - start-notebook.sh
      - --NotebookApp.allow_origin='https://colab.research.google.com'
      - --IdentityProvider.allow_password_change=False
    restart: unless-stopped
    labels:
      - "traefik.enable=true"  # 显式启用
      - "traefik.http.routers.jupyter.rule=Host(`jupyter.home.xxx.com`)"
      #- "traefik.http.services.jupyter.loadbalancer.server.port=8888" # 注意指定服务名称：jupyter

networks:
  traefik-net:
    external: true
```
