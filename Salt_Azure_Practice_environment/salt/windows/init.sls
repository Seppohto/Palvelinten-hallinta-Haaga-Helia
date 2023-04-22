ensure_parent_directory_exists:
  file.directory:
    - name: C:\tmp

C:\tmp\infra-as-code:
  file.managed

install_chocolatey:
  cmd.run:
    - name: Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    - shell: powershell
    - unless: "choco -v"
    








