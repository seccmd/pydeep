#!/bin/bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

exec > >(tee /var/log/system_init.log) 2>&1  # 所有输出重定向到日志

# 预安装检查函数（强制最先执行）
pre_install_checks() {
    echo "[$(date +'%F %T')] START PRE-INSTALL CHECKS"
    
    # 1. 系统兼容性验证
    if ! grep -q "Ubuntu" /etc/os-release; then
        echo "[ERROR] 仅支持 Ubuntu 系统，当前系统: $(lsb_release -ds)" >&2
        exit 1
    fi

    # 2. Root权限校验
    [[ $EUID -ne 0 ]] && { echo "[ERROR] 请使用 sudo 或 root 权限运行"; exit 1; }

    # 3. 硬件资源检查（内存≥2GB）
    local mem_gb=$(free -g | awk '/Mem/{print $2}')
    [[ $mem_gb -lt 2 ]] && echo "[WARN] 内存不足（当前 ${mem_gb}GB），建议≥2GB"

    # 4. 关键依赖包自动安装
    local required_pkgs=(curl wget)
    for pkg in "${required_pkgs[@]}"; do
        if ! command -v "$pkg" &>/dev/null; then
            echo "[CHECK] 安装依赖: $pkg"
            apt-get install -y "$pkg" || { echo "[ERROR] $pkg 安装失败"; exit 1; }
        fi
    done

    # 5. 服务冲突检测（如Docker）
    systemctl is-active --quiet docker && echo "[WARN] Docker 已运行，注意端口冲突"

    echo "[SUCCESS] 预安装检查通过"
}

# 系统更新模块
update_system() {
    echo "[$(date +'%F %T')] START SYSTEM UPDATE"
    apt update -y --fix-missing
    #apt upgrade -y --only-upgrade  # 仅升级已安装包
    echo "[SUCCESS] 系统更新完成"
}

# 安装 uv 工具
install_uv() {
    echo "[$(date +'%F %T')] START UV INSTALL"
    local install_script="/tmp/uv_install.sh"
    curl -fLsS "https://astral.sh/uv/install.sh" -o "$install_script"
    sh "$install_script"
    rm -f "$install_script"
    source "$HOME/.local/bin/env"
    echo "[SUCCESS] uv 安装完成"
}

# 安装 Docker
install_docker() {
    echo "[$(date +'%F %T')] START DOCKER INSTALL"
    local docker_script="/tmp/get-docker.sh"
    curl -fsSL "https://get.docker.com" -o "$docker_script"
    sh "$docker_script" --dry-run  # 安全预检
    sh "$docker_script"
    rm -f "$docker_script"
    systemctl enable --now docker
    echo "[SUCCESS] Docker 安装完成"
}

# 配置 Jupyter Lab 服务
install_jupyter() {
    echo "[$(date +'%F %T')] START JUPYTER SETUP"
    mkdir -p /opt/jupyter-lab
    tee /opt/jupyter-lab/jupyter.service > /dev/null <<EOF
[Unit]
Description=Jupyter Lab
After=network.target

[Service]
Type=simple
User=root
ExecStart=/root/.local/bin/uvx jupyter lab --port=8888 --ip=0.0.0.0 --allow-root
WorkingDirectory=/opt/jupyter-lab
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
    systemctl enable --now /opt/jupyter-lab/jupyter.service
    journalctl -u jupyter -n 10 --no-pager 
    echo "[SUCCESS] Jupyter Lab 已启动（端口 8888）"
}

# 完整初始化流程
init_all() {
    pre_install_checks  # 强制前置检查
    update_system
    install_uv
    install_docker
    install_jupyter
}

# 主控制逻辑
main() {
    local modules=("$@")
    [[ ${#modules[@]} -eq 0 ]] && { echo "用法: $0 [模块列表]"; exit 1; }

    for module in "${modules[@]}"; do
        case "$module" in
            precheck) pre_install_checks ;;  # 独立检查入口
            update)   update_system ;;
            uv)       install_uv ;;
            docker)   install_docker ;;
            jupyter)  install_jupyter ;;
            all)      init_all ;;
            *)        echo "[ERROR] 未知模块: $module"; exit 1 ;;
        esac
    done
    echo "[$(date +'%F %T')] 所有操作完成！日志：/var/log/system_init.log"
}

main "$@"
