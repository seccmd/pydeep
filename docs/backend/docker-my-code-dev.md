# Docker 快速编程测试环境

我想通过 docker compose 快速搭建一个国内的 编程环境，要求如下：

```Markdown
# docker run -it --rm -p 3000:3000 ubuntu bash
services:
  test-env:
    image: ubuntu
    command: bash
    ports:
      - "3000:3000"
    volumes:
      - ./app:/app  # 挂载本地目录到容器
    tty: true       # 保持终端交互
```

```YAML
services:
  dev-env:
    image: ubuntu:24.04     # 预先构建好的编程环境
    container_name: code-dev-02
    #entrypoint: /setup.sh  # 启动时自动执行初始化脚本 - 启动时不会保存
    entrypoint: /bin/bash
    ports:
      - "3000:3000"
      - "8000:8000"
    volumes:
      - ./app:/app  # 挂载本地目录到容器
      - ./setup.sh:/setup.sh  # 挂载本地目录到容器
    environment:
      TZ: Asia/Shanghai
      DEBIAN_FRONTEND: noninteractive
    tty: true

# docker compose up -d
# docker compose exec dev-env bash
# /setup.sh  进入容器后手动执行，安装部署才会保存

# 问题：
# ​​entrypoint的修改不保存​​：因其发生在容器初始化阶段，且未通过卷或镜像固化。
​​# exec的修改可保存​​：因容器运行时修改直接作用于可写层（直到容器删除）。
```



我将为您创建一个优化的 Docker Compose 配置，快速搭建具有国内高速源的 Python/Node.js 开发环境。以下是完整的 `docker-compose.yml` 文件：

```YAML
services:
  dev-env:
    image: my-code-dev     # 预先构建好的编程环境
    container_name: code-dev-01
    entrypoint: /bin/bash  # 启动时自动执行初始化脚本
    ports:
      - "3000:3000"
      - "8000:8000"
    volumes:
      - ./app:/app  # 挂载本地目录到容器
    environment:
      TZ: Asia/Shanghai
    tty: true

# 启动和进入容器
# docker compose up -d
# docker compose exec dev-env bash
```

Dockfile 构建 my-code-dev

```Docker
FROM ubuntu:24.04

# 复制初始化脚本
COPY setup.sh /setup.sh

# 在构建阶段执行初始化（RUN）
RUN chmod +x /setup.sh && /setup.sh

# 设置容器启动时的默认命令（非初始化）
ENTRYPOINT /bin/bash  # 保持容器运行但不执行setup

# 构建与运行​​：
# docker build -t my-code-dev .
# docker run -it --rm -p 3000:3000 -p 8000:8000 my-code-dev bash
```

在同一目录下创建 `setup.sh` 文件（用于执行初始化任务）：

```Bash
#!/bin/bash

# 临时禁用证书验证（仅测试环境）​
echo 'Acquire::https::Verify-Peer "false";' > /etc/apt/apt.conf.d/99ignore-ssl
echo 'Acquire::https::Verify-Host "false";' >> /etc/apt/apt.conf.d/99ignore-ssl

# 更新软件源并替换为清华源
cp /etc/apt/sources.list.d/ubuntu.sources /etc/apt/sources.list.d/ubuntu.sources.bak
tee /etc/apt/sources.list.d/ubuntu.sources << 'EOF'
Types: deb
URIs: https://mirrors.tuna.tsinghua.edu.cn/ubuntu
Suites: noble noble-updates noble-backports
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

Types: deb
URIs: https://mirrors.tuna.tsinghua.edu.cn/ubuntu
Suites: noble-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
EOF

echo "正在更新软件源..."
apt-get update -y
echo "安装基础工具..."
apt-get install -y curl wget unzip python3 python3-pip

# 安装 uv
echo "安装 uv 工具..."
curl -LsSf https://astral.sh/uv/install.sh | sh

# 使用 NodeSource 国内镜像
curl -fsSL https://deb.nodesource.com/setup_current.x | bash -
apt-get install -y nodejs

# 配置 Python pip 清华源
echo "配置 Pip 清华源..."
mkdir -p /etc/pip
cat > /etc/pip/pip.conf <<EOF
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
[install]
trusted-host = pypi.tuna.tsinghua.edu.cn
EOF

# 配置 NPM 淘宝源
echo "配置 NPM 淘宝源..."
npm config set registry https://registry.npmmirror.com

# 安装 Qwen-Coder 和 Claude Code
echo "安装编程工具..."
npm install -g @qwen-code/qwen-code
npm install -g @anthropic-ai/claude-code

# 保持容器运行
echo "开发环境已就绪！"
echo "访问地址：http://localhost:3000"
#exec /bin/bash
```



### 使用说明：

1. 创建项目目录：

```Bash
mkdir dev-env && cd dev-env
touch docker-compose.yml setup.sh
chmod +x setup.sh
```
2. 将上述代码分别复制到 `docker-compose.yml` 和 `setup.sh` 文件中
3. 启动开发环境：

```Bash
docker compose up -d
```
4. 进入容器：

```Bash
docker exec -it cn-dev-env bash
```

### 验证环境：

1. 检查 pip 源配置：

```Bash
pip config list
# 应显示: global.index-url='https://pypi.tuna.tsinghua.edu.cn/simple'
```
2. 检查 NPM 源配置：

```Bash
npm config get registry
# 应显示: https://registry.npmmirror.com/
```
3. 验证工具安装：

```Bash
uv --version
qwen-coder --help
claude-code --version
```

### 环境特点：

1. **国内高速源**：
    - APT → 清华源
    - PIP → 清华源
    - NPM → 淘宝镜像源
2. **预装工具**：
    - Python 3
    - Node.js + NPM
    - UV (ultra-fast Python包管理)
    - Qwen-Coder (通义代码模型)
    - Claude Code (Claude编程助手)
3. **自动初始化**：
    - 启动容器时自动执行配置脚本
    - 挂载本地目录到容器 `/app`
    - 端口 3000 直接映射

此环境适合国内开发者快速搭建隔离的开发测试环境，所有下载都会走国内镜像源加速。

