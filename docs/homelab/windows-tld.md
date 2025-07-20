# Windows TLD

## 一、Windows Cmd Powersehll Proxifier

目的：如果让Cmd_Powersehll设置，通过Socks5代理访问

第一步：安装配置Proxifier

- 代理配置规则：powershell.exe  curl.exe
- **配置域名解析选项**：取消第一个默认勾选【本地DNS解析】，启用第二个【远程DNS解析】

第二步：全局代理

- 如果不知道具体的 应用名称，可以打开全局代理，看一下访问行为，再添加规则。


## 二、Docker Desktop on Windows

Docs: [https://docs.docker.com/desktop/setup/install/windows-install/](https://docs.docker.com/desktop/setup/install/windows-install/)

```Markdown
## need wsl 2
wsl --version
wsl --install
wsl --update

## install Docker Desktop
- 官网手动下载，点击安装 www.docker.com
- 命令行安装，参考官方文档
- 设置网络代理
In the Secure Web Server HTTPS box, paste your socks5://host:port URL.
```

然后直接在命令行操作 docker ps

```Markdown
# ​1. 拉取 Nginx 的 Alpine 版本镜像
# 为什么选择 Alpine 版？​​​​轻量​​：镜像体积小（约 20MB，标准版约 130MB），启动更快。
docker pull nginx:alpine

# 2. 运行 Nginx 容器​​
# 启动一个临时容器（退出后自动删除）：
docker run --rm -d -p 8080:80 --name my-nginx nginx:alpine

# 自定义配置或挂载文件​
docker run -d -p 8080:80 \
  -v /path/to/your/html:/usr/share/nginx/html \
  -v /path/to/your/nginx.conf:/etc/nginx/nginx.conf \
  --name my-nginx nginx:alpine

# 4. 进入容器调试​​ 若需检查容器内文件或修改配置：
docker exec -it my-nginx sh

# Alpine 镜像默认使用 sh（非 bash），进入后可执行命令如：
nginx -t           # 测试配置文件语法
apk update         # 更新包列表（Alpine 使用 apk 包管理器）
apk add curl       # 安装工具（如 vim）

# 5. 构建自定义镜像（可选）​​
# 若需预装额外工具（如 curl），可创建 Dockerfile：
FROM nginx:alpine
RUN apk add --no-cache curl
COPY ./custom-html /usr/share/nginx/html
# 构建并运行：
docker build -t my-custom-nginx .
docker run -d -p 8080:80 --name my-nginx my-custom-nginx

```


## 三、SSHD on Windows

```PowerShell
# SSH_Manager.ps1
# Function: One-click enable/disable Windows OpenSSH Server with key authentication and specified user access
# Requires administrator privileges

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("Enable", "Disable", "Configure")]
    [string]$Action,
    [string]$AllowedUser = "Admin"  # Replace with your desired username
)

# Security Configuration Function
function Invoke-SecurityConfiguration {
    param(
        [string]$Username
    )

    # Backup original config file
    $configPath = "$env:ProgramData\ssh\sshd_config"
    Copy-Item $configPath "$configPath.bak" -Force

    # Disable password auth & enable key auth
    (Get-Content $configPath) | ForEach-Object {
        $_ -replace '#?PasswordAuthentication\s+.+', 'PasswordAuthentication no' `
           -replace '#?PubkeyAuthentication\s+.+', 'PubkeyAuthentication yes' `
           -replace '#?PermitRootLogin\s+.+', 'PermitRootLogin no' `
           -replace '#?AllowUsers\s+.+', "AllowUsers $Username"
    } | Set-Content $configPath -Force

    # Add AllowUsers directive if missing
    if (-not (Select-String -Path $configPath -Pattern "AllowUsers $Username")) {
        Add-Content $configPath "`nAllowUsers $Username" -Force
    }

    # Fix key file permissions (critical security setting)
    $authorizedKeys = "$env:ProgramData\ssh\administrators_authorized_keys"
    if (Test-Path $authorizedKeys) {
        icacls $authorizedKeys /inheritance:r /grant "SYSTEM:(F)" "$env:USERNAME:(F)"
    }
}

# Main Logic
switch ($Action) {
    "Enable" {
        # Install OpenSSH service if not present
        if (-not (Get-WindowsCapability -Online -Name "OpenSSH.Server*" | Where-Object State -eq "Installed")) {
            Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
        }

        # Start service and set to auto-start
    Set-Service -Name sshd -StartupType Automatic
        Start-Service sshd

        # Configure firewall
        New-NetFirewallRule -Name "OpenSSH-Server" -DisplayName "OpenSSH Server (sshd)" `
            -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22

        Write-Host "[+] SSH Enabled" -ForegroundColor Green
    }
    
    "Disable" {
        # Stop service and disable auto-start
        Stop-Service sshd -Force -ErrorAction SilentlyContinue
        Set-Service -Name sshd -StartupType Disabled

        # Remove firewall rule
        Remove-NetFirewallRule -DisplayName "OpenSSH Server (sshd)" -ErrorAction SilentlyContinue

        Write-Host "[-] SSH Disabled" -ForegroundColor Red
    }
    
    "Configure" {
        # Apply security configuration
        Invoke-SecurityConfiguration -Username $AllowedUser
        Write-Host "[+] Security Configuration Applied - Only [$AllowedUser] account allowed with key authentication" -ForegroundColor Green
    }
}

# Verify status
$status = (Get-Service sshd).Status
Write-Host "Service Status: $status | Config Path: $env:ProgramData\ssh\sshd_config"
```
