ensure_parent_directory_exists:
  file.directory:
    - name: C:\tmp

C:\tmp\infra-as-code:
  file.managed

chocoinstall:
    pkg.installed:
      - name: chocolatey

choco:
  chocolatey.installed:
    - names:
      - git
      - python3
      - googlechrome
      - firefox
      - notepadplusplus
      - mremoteng

install_ad_tools:
  module.run:
    - name: win_servermanager.install
    - feature: RSAT-ADDS-Tools
