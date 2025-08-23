# 0 Click 初始化环境 One-Stop

### One - [install0.sh](http://install0.sh)

```Bash
curl -LsSf https:/www.seccmd.net/tld/script/install0.sh | bash -s -- all
```

```Bash
# 完整初始化流程
init_all() {
    pre_install_checks  # 强制前置检查
    update_system
    install_uv
    install_docker
    install_jupyter
}

journalctl -u jupyter
```



