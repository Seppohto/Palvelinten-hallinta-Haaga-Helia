ensure_parent_directory_exists:
  file.directory:
    - name: C:\tmp

C:\tmp\infra-as-code:
  file.managed

deskwin:
  pkg.installed:
    - pkgs:
      - python3_x64
      - chocolatey

choco:
  chocolatey.installed:
    - names:
      - git
      - googlechrome
      - firefox
      - notepadplusplus
      - mremoteng

install_ad_tools:
  module.run:
    - name: win_servermanager.install
    - feature: RSAT-ADDS-Tools

copy_hello_py:
  file.managed:
    - name: C:\Windows\System32\hello.py
    - source: salt://windows/scripts/hello.py

copy_hello_ps1:
  file.managed:
    - name: C:\Windows\System32\hello.ps1
    - source: salt://windows/scripts/hello.ps1
