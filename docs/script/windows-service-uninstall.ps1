param(
    [string]$Name = "MyService"
)

# Stop the service
if (Get-Service -Name $Name -ErrorAction SilentlyContinue) {
    Stop-Service -Name $Name -Force
    sc.exe delete $Name
    Write-Output "$Name removed!"
} else {
    Write-Output "Service $Name not found."
}

# iwr -useb https://example.com/my-service-uninstall.ps1 | iex -Name "MyService"
