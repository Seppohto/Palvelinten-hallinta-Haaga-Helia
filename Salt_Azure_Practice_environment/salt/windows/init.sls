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
    - unless: choco -v
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
install_ad_tools:
  module.run:
    - name: win_servermanager.install
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
