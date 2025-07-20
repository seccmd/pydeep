# Nginx Proxy Manager​​ 管理面

### **图形化管理面板推荐**

首选Nginx Proxy Manager：如果核心需求是代理和SSL，它提供最简洁的解决方案，15分钟即可通过Docker完成部署。

次选宝塔面板：适合需要兼顾网站管理、FTP等复杂场景，但注意其资源占用较高。

## Nginx Proxy Manager​​ (推荐)

```Markdown
轻量级Docker化部署，专为反向代理和SSL设计
直观的Web界面，支持多域名、HTTP/HTTPS重定向
​​内置Let's Encrypt自动化​​，一键申请/续签证书
支持访问控制、Basic Auth等基础功能
​​适用场景​​：个人开发者或中小团队，需要快速管理代理和SSL。
​​项目地址​​：https://nginxproxymanager.com/

# 快速入门命令（Nginx Proxy Manager）​
# 通过Docker一键部署
docker run -d \
  -p 80:80 -p 81:81 -p 443:443 \
  -v data:/data \
  -v letsencrypt:/etc/letsencrypt \
  --name nginx-proxy-manager \
  jc21/nginx-proxy-manager:latest

cd C:\Users\iwanw\Videos\CWork\codebase\ailab\nginx-proxy-manager
docker run -d -p 80:80 -p 81:81 -p 443:443 -v data:/data  -v letsencrypt:/etc/letsencrypt --name nginx-proxy-manager jc21/nginx-proxy-manager:latest

```

## Guide - 

[https://nginxproxymanager.com/guide/](https://nginxproxymanager.com/guide/)

```Markdown
# 1. Install Docker and Docker-Compose
Docker Install documentation: https://docs.docker.com/get-docker/
Docker-Compose Install documentation: https://docs.docker.com/compose/install/

# 2. Create a docker-compose.yml file similar to this:

services:
  app:
    image: 'jc21/nginx-proxy-manager:latest'
    restart: unless-stopped
    ports:
      - '80:80'
      - '81:81'
      - '443:443'
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt
 
# 3. Bring up your stack by running
docker-compose up -d
# If using docker-compose-plugin
docker compose up -d


# 4. Log in to the Admin UI
# When your docker container is running, connect to it on port 81 for the admin interface. Sometimes this can take a little bit because of the entropy of keys.

http://127.0.0.1:81
# Default Admin User:
Email:    admin@example.com
Password: changeme

# Immediately after logging in with this default user you will be asked to modify your details and change your password.

```

