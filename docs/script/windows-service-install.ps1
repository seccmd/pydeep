param(
    [string]$Name = "MyService",
    [string]$ExecCmd = "C:\Path\to\myapp.exe"
)

# Install Windows service
New-Service -Name $Name -BinaryPathName $ExecCmd -DisplayName $Name -StartupType Automatic

# Start the service
Start-Service -Name $Name

Write-Output "$Name installed and started!"

# Run directly with iex (one-liner like curl | sh)
# iwr -useb https://example.com/my-service-install.ps1 | iex
# iwr -useb https://example.com/my-service-install.ps1 | iex -Name "MyService" -ExecCmd "C:\Tools\myapp.exe -arg1 -arg2"
