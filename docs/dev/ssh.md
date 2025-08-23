# SSH in One


## 启用/关闭 Windows SSH 服务器

启用/关闭 Windows SSH 服务器、强制密钥认证并限制登录账号的 PowerShell 脚本，已集成安全配置：

```PowerShell
# SSH_Manager.ps1
# 功能：一键启用/禁用 Windows OpenSSH 服务器，配置密钥认证+指定账号登录
# 需以管理员权限运行

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("Enable", "Disable")]
    [string]$Action,
    [string]$AllowedUser = "Admin"  # 替换为你的指定账号
)

# 安全配置函数
function Configure-SSH {
    # 备份原始配置文件
    $configPath = "$env:ProgramData\ssh\sshd_config"
    Copy-Item $configPath "$configPath.bak" -Force

    # 禁用密码登录 & 启用密钥认证
    (Get-Content $configPath) | ForEach-Object {
        $_ -replace '#?PasswordAuthentication\s+.+', 'PasswordAuthentication no' `
           -replace '#?PubkeyAuthentication\s+.+', 'PubkeyAuthentication yes' `
           -replace '#?PermitRootLogin\s+.+', 'PermitRootLogin no' `
           -replace '#?AllowUsers\s+.+', "AllowUsers $AllowedUser"
    } | Set-Content $configPath -Force

    # 添加AllowUsers指令（如不存在）
    if (-not (Select-String -Path $configPath -Pattern "AllowUsers $AllowedUser")) {
        Add-Content $configPath "`nAllowUsers $AllowedUser" -Force
    }

    # 修复密钥文件权限（关键安全设置）
    $authorizedKeys = "$env:ProgramData\ssh\administrators_authorized_keys"
    if (Test-Path $authorizedKeys) {
        icacls $authorizedKeys /inheritance:r /grant "SYSTEM:(F)" "$env:USERNAME:(F)"
    }
}

# 主逻辑
switch ($Action) {
    "Enable" {
        # 安装OpenSSH服务
        if (-not (Get-WindowsCapability -Online -Name "OpenSSH.Server*" | Where-Object State -eq "Installed")) {
            Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
        }

        # 启动服务并设自启
        Start-Service sshd
        Set-Service -Name sshd -StartupType Automatic

        # 应用安全配置
        Configure-SSH

        # 放行防火墙
        New-NetFirewallRule -Name "OpenSSH-Server" -DisplayName "OpenSSH Server (sshd)" `
            -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22

        Write-Host "✅ SSH 已启用 - 仅允许账号 [$AllowedUser] 通过密钥登录" -ForegroundColor Green
    }
    "Disable" {
        # 停止服务并禁用自启
        Stop-Service sshd -Force -ErrorAction Silentl
        Set-Service -Name sshd -StartupType Disabled

        # 移除防火墙规则
        Remove-NetFirewallRule -DisplayName "OpenSSH Server (sshd)" -ErrorAction SilentlyContinue

        Write-Host "⛔ SSH 已关闭" -ForegroundColor Red
    }
}

# 验证状态
$status = (Get-Service sshd).Status
Write-Host "服务状态: $status | 配置路径: $env:ProgramData\ssh\sshd_config"
```

### 🔒 安全设计说明

1. **强制密钥认证**
    - 禁用密码登录：`PasswordAuthentication no`[citation:10][citation:11]
    - 启用公钥认证：`PubkeyAuthentication yes`
    - 修复密钥文件权限：防止权限错误导致认证失效[citation:9]
2. **账号白名单**
    - 仅允许指定账号：`AllowUsers Admin`（替换`Admin`为你的账号）[citation:9]
    - 禁止root登录：`PermitRootLogin no`[citation:11]
3. **服务管理**
    - 自动安装OpenSSH（如未安装）
    - 防火墙规则自动配置：仅开放22端口
    - 服务自启管理：启用时设自启，禁用时彻底关闭

### ⚠️ 使用前准备

1. **生成SSH密钥对**（客户端执行）：

```Bash
ssh-keygen -t ed25519
```
2. **部署公钥到Windows服务器**：
    - 复制 `id_ed25519.pub` 内容
    - 保存到 `C:\ProgramData\ssh\administrators_authorized_keys`

### 🚀 执行方式

```PowerShell
# 启用SSH（指定账号为Admin）
.\SSH_Manager.ps1 -Action Enable -AllowedUser Admin

# 关闭SSH
.\SSH_Manager.ps1 -Action Disable
```

> 安全提示：首次启用后，**立即测试密钥登录**：
`ssh Admin@服务器IP
`若失败请检查 `administrators_authorized_keys` 文件权限（右键→属性→安全→仅保留SYSTEM和当前用户完全控制）[citation:9]

### 📌 关键配置项说明

|配置指令|设定值|安全作用|
|-|-|-|
|`PasswordAuthentication`|`no`|彻底禁用密码登录[citation:11]|
|`PubkeyAuthentication`|`yes`|强制密钥认证|
|`AllowUsers`|指定用户名|限制登录账号白名单|
|`administrators_authorized_keys`权限|仅SYSTEM+用户|防止权限继承导致认证失效|


> 此脚本已实现企业级安全基线配置，无需额外操作即可抵御密码爆破攻击。建议定期审计 `sshd_config` 文件完整性[citation:10]。

