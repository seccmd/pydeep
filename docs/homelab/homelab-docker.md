# Home Lab Docker

## Traefik-Docker

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
      - CLOUDFLARE_EMAIL=<EMAIL>
      - CLOUDFLARE_DNS_API_TOKEN=<API TOKEN>
      - CLOUDFLARE_ZONE_API_TOKEN=<API TOKEN>

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
      - --certificatesresolvers.mydnschallenge.acme.email=EMAIL
      - --certificatesresolvers.mydnschallenge.acme.storage=/letsencrypt/acme.json

# 声明网络（关键！）
networks:
  traefik-net:
    external: true  # 引用外部创建的网络
```

### traefik.yml

```yaml
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
      email: "EMAIL"
      storage: /letsencrypt/acme.json
      dnsChallenge:
        provider: cloudflare
```

## Headscale Docker

```yaml
version: "3.8"

services:

  # Headscale 控制服务器
  headscale:
    image: headscale/headscale:latest
    container_name: headscale
    restart: unless-stopped
    command: serve  # ✅ 关键修复：直接运行 `serve` 命令
    #environment:
    #  - HEADSCALE_NOISE_PRIVATE_KEY_PATH=/var/lib/headscale/noise_private.key
    volumes:
      - ./headscale/config:/etc/headscale
      - ./headscale/data:/var/lib/headscale
    expose:
      - "8080"  # 仅内部暴露
    networks:
      - traefik-net
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.headscale.rule=Host(`headscale.home`)"
      - "traefik.http.routers.headscale.entrypoints=websecure"
      - "traefik.http.routers.headscale.tls=true"
      - "traefik.http.routers.headscale.tls.certresolver=mydnschallenge"
      - "traefik.http.services.headscale.loadbalancer.server.port=8080"

  # DERP 中继服务
  derper:
    image: fredliang/derper:latest
    container_name: derper
    hostname: derp.home  # 必须与证书域名一致
    restart: unless-stopped
    #volumes:
    #  - ./derp/certs:/tmp/derp-certs  # 证书挂载（可选）
    expose:
      #- "3478:3478/udp"  # STUN UDP端口
      - "4443"  # 仅内部暴露
    environment:
      - DERP_HOST=derp.home
      - DERP_DOMAIN=derp.home
      - DERP_ADDR=:4443
      - DERP_HTTP_PORT=-1            # 禁用 HTTP 调试页面
      #- DERP_VERIFY_CLIENTS=true     # 实验性：验证客户端（可选）
    networks:
      - traefik-net
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.derper.rule=Host(`derp.home`)"
      - "traefik.http.routers.derper.entrypoints=websecure"
      - "traefik.http.routers.derper.tls=true"
      - "traefik.http.routers.derper.tls.certresolver=mydnschallenge"
      - "traefik.http.services.derper.loadbalancer.server.port=4443"
      - "traefik.http.services.derper.loadbalancer.server.scheme=https"  # WebSocket 需 HTTPS

networks:
  traefik-net:
    external: true
```

## Jupyter Docker

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
      - "traefik.http.routers.jupyter.rule=Host(`jupyter.home`)"
      #- "traefik.http.services.jupyter.loadbalancer.server.port=8888" # 注意指定服务名称：jupyter
      # - "traefik.http.routers.jupyter.entrypoints=web"

networks:
  traefik-net:
    external: true
```

## Vscode-web Docker

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
      - PASSWORD=<your password>
    labels:
      - "traefik.enable=true"  # 显式启用
      - "traefik.http.routers.vscode.rule=Host(`vscode.home`)"
      - "traefik.http.services.vscode.loadbalancer.server.port=8080" # 显式声明端口
      - "traefik.http.routers.vscode.entrypoints=websecure"
      - "traefik.http.routers.vscode.tls.certresolver=mydnschallenge"

networks:
  traefik-net:
    external: true
```