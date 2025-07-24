# Docker 安装 VS Code Web 版

以下是使用 Docker 安装 VS Code Web 版（code-server）的详细步骤，综合了多个最佳实践方案：

---

### **1. 基础安装（快速启动）**

```Bash
# 拉取官方镜像
docker pull codercom/code-server

# 运行容器（默认端口8080，无密码）
docker run -d \
  --name my-vscode-web \
  -p 8080:8080 \
  -v "$PWD:/home/coder/project" \
  codercom/code-server
```

**访问地址**：`http://服务器IP:8080`  

**注意**：首次访问需查看容器日志获取随机密码：

```Bash
docker logs my-vscode-web | grep "Password"
```

---

### **2. 安全增强配置**

#### **2.1 自定义密码 & HTTPS**

```Bash
docker run -d \
  --name secure-vscode \
  -p 8443:8080 \
  -v "/path/to/workspace:/home/coder" \
  -v "/path/to/ssl:/certs" \
  -e PASSWORD="yourpassword" \
  codercom/code-server \
  --cert /certs/fullchain.pem \
  --cert-key /certs/privkey.pem
```

**参数说明**：

- `PASSWORD`：设置登录密码（明文）
- `--cert`：HTTPS证书路径（需提前将证书挂载到容器内）
- 访问地址变为：`https://服务器IP:8443`  

#### **2.2 防火墙配置**

```Bash
# 开放端口（以CentOS为例）
sudo firewall-cmd --add-port=8443/tcp --permanent
sudo firewall-cmd --reload
```

---

### **3. 生产环境推荐方案**

#### **3.1 Docker Compose 部署**

创建 `docker-compose.yml` 文件：

```YAML
version: "3"
services:
  code-server:
    image: codercom/code-server
    ports:
      - "8080:8080"
    volumes:
      - ./workspace:/home/coder
      - ./config:/home/coder/.config
    environment:
      - PASSWORD=yourpassword
    restart: always
```

**启动命令**：

```Bash
docker-compose up -d
```

**优势**：  

- 配置文件化管理，易于维护  
- 自动重启保障服务可用性  

#### **3.2 资源限制与用户权限**

```Bash
docker run -d \
  --memory="4g" --cpus="2" \
  --user "$(id -u):$(id -g)" \
  -v "$HOME:/home/coder" \
  codercom/code-server
```

**说明**：  

- `--memory` 和 `--cpus` 限制资源使用  
- `--user` 避免容器内操作产生的权限问题  

---

### **4. 高级功能扩展**

#### **4.1 预装插件与配置**

```Bash
# 进入容器安装插件（如中文包）
docker exec -it my-vscode-web bash
code-server --install-extension ms-ceintl.vscode-language-pack-zh-hans
```

**或** 通过挂载预配置的 `extensions` 目录：

```Bash
-v ./extensions:/home/coder/.local/share/code-server/extensions
```

#### **4.2 多工作区支持**

```Bash
docker run -d \
  -v "/path/to/project1:/home/coder/project1" \
  -v "/path/to/project2:/home/coder/project2" \
  codercom/code-server
```

**访问方式**：URL后添加参数 `?folder=/home/coder/project1`  

---

---

### **总结**

- **快速体验**：直接运行基础命令（需处理密码问题）  
- **生产部署**：使用 Docker Compose + HTTPS + 资源限制   
- **移动端适配**：建议搭配反向代理（如 Nginx）优化访问体验   

完整配置参考：[https://coder.com/docs/code-server/latest](https://coder.com/docs/code-server/latest)
