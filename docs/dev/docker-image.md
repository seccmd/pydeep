# Docker Image


### Docker kali

```Markdown
## 官方镜像：
## https://www.kali.org/docs/containers/official-kalilinux-docker-images/
docker pull kalilinux/kali-rolling:latest
docker run -it --rm kalilinux/kali-rolling:latest

## 安装默认工具包​​ kali-linux-default 元包（约 300+ 工具）： 下载安装 15G 文件
apt update && sudo apt upgrade -y
apt install -y kali-linux-default

## nmap 报错：需要网络权限
docker run --rm -it --cap-add=NET_RAW --cap-add=NET_ADMIN kalilinux/kali-rolling:latest

## 配置固化​​：始终使用 Dockerfile + docker-compose.yml 管理配置
# docker-compose.yml 示例（避免手动操作）
services:
  app:
    image: nginx:alpine
    cap_add:
      - NET_ADMIN
      - NET_RAW
    ports:
      - "80:80"
      - "443:443"
```

### Docker nodejs

```Markdown
# Docker has specific installation instructions for each operating system.
# Please refer to the official documentation at https://docker.com/get-started/

# Pull the Node.js Docker image:
docker pull node:22-alpine

# Create a Node.js container and start a Shell session:
docker run -it --rm --entrypoint sh node:22-alpine

# Verify the Node.js version:
node -v # Should print "v22.17.0".

# Verify npm version:
npm -v # Should print "10.9.2".

```