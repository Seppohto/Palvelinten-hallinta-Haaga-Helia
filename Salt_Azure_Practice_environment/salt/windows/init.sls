ensure_parent_directory_exists:
  file.directory:
    - name: C:\tmp

C:\tmp\infra-as-code:
  file.managed

deskwin:
  pkg.installed:
    - pkgs:
      - git
      - python3_x64
      - chrome
      - chocolatey
      - firefox


chocolatey.installed:
  - name: notepadplusplus
chocolatey.installed:
  - name: mremoteng


install_ad_tools:
  module.run:
    - name: win_servermanager.install
    - feature: RSAT-ADDS-Tools
