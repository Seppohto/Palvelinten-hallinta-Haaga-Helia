# Viikko 5 - Suolaa ikkunoille
lähde: [Control Windows with Salt](https://terokarvinen.com/2018/control-windows-with-salt/)

-kuinka Salttia käytetään windowsservereiden halintaan. 
-asennetaan ohjelmistoja
testataan toimintoja paikallisesti
- tehdään automaatinen ohjelmistojen asennus sls

lähde: [Using Salt with Windows](https://tuomasvalkamo.com/CMS-course/week-5/)
- kirjoitti Salt-tilan luodakseen tiedoston, mutta sai aluksi virheen koodissa olevan puuttuvan kaksoispisteen vuoksi.
- teknistä tietoa Windows-koneestaan käyttäen grains-moduulia ja tallensivat sen tekstitiedostoon. - näyttivät myös, miten sen voi tallentaa JSON-muodossa.
- kirjoittaja testasi, olivatko portit avoinna vai suljettuna sekä Linuxilla että Windowsilla käyttäen netcatia Linuxissa ja Test-NetConnectionia Windowsissa.
- He näyttivät esimerkkejä avoimista ja suljetuista porteista kummallakin käyttöjärjestelmällä.


1. A

```
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
```
2. B

powershell:

salt-call --local state.single file.managed C:\Temp\foobar -l debug

salt-call --local state.single grains.items

3. C ja D

```
# Ensure parent directory exists
ensure_parent_directory_exists:
  file.directory:
    - name: C:\tmp

# Manage a test file
C:\tmp\infra-as-code:
  file.managed

# Install Chocolatey
chocolatey:
  module.run:
    - name: chocolatey.bootstrap
    - unless: choco --version
    - shell: powershell

# Install Chocolatey packages
choco:
  chocolatey.installed:
    - names:
      - git
      - googlechrome
      - firefox
      - notepadplusplus
      - mremoteng
    - require:
      - module: chocolatey

# Install AD tools
win_servermanager.install:
  module.run:
    - feature: RSAT-ADDS-Tools
    - unless: (Get-WindowsFeature -Name RSAT-ADDS-Tools).Installed -eq $True
    - shell: powershell

# Copy hello.py
copy_hello_py:
  file.managed:
    - name: C:\Windows\System32\hello.py
    - source: salt://windows/scripts/hello.py

# Copy hello.ps1
copy_hello_ps1:
  file.managed:
    - name: C:\Windows\System32\hello.ps1
    - source: salt://windows/scripts/hello.ps1
```
