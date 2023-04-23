# Variables
$url = "https://repo.saltproject.io/salt/py3/windows/latest/Salt-Minion-3006.0-Py3-AMD64-Setup.exe"
$output = "C:\Temp\Salt-Minion-3006.0-Py3-AMD64-Setup.exe"
$saltMaster = "10.0.0.6"
$computername = $env:COMPUTERNAME
$minionName = "windows-minion-" + $computername

# Create Temp directory if it doesn't exist
if (-not (Test-Path -Path "C:\Temp")) {
    New-Item -ItemType Directory -Path "C:\Temp" | Out-Null
}

# Download Salt Minion installer
Write-Host "Downloading Salt Minion installer..."
Invoke-WebRequest -Uri $url -OutFile $output

# Install Salt Minion
Write-Host "Installing Salt Minion..."
Start-Process -FilePath $output -ArgumentList "/S /master=$saltMaster /minion-name=$minionName" -Wait

# Remove the installer
Write-Host "Cleaning up..."
Remove-Item -Path $output

# Restart Salt Minion service
Write-Host "Restarting Salt Minion service..."
Restart-Service -Name salt-minion

Write-Host "Salt Minion installed and configured successfully."
