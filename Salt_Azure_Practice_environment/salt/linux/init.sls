/tmp/infra-as-code:
  file.managed
  
hello_sh:
  file.managed:
    - name: /usr/local/bin/hello.sh
    - source: salt://linux/scripts/hello.sh
    - mode: '0755'

hellosh_symlink:
  file.symlink:
    - name: /usr/local/bin/hellosh
    - target: /usr/local/bin/hello.sh

append_string_hellosh_in_file:
  file.append:
    - name: /etc/bash.bashrc
    - text: 'alias hellosh="hello.sh"'

hello_py:
  file.managed:
    - name: /usr/local/bin/hello.py
    - source: salt://linux/scripts/hello.py
    - mode: '0755'

# I found this when the other thing didn't work
hellopy_symlink:
  file.symlink:
    - name: /usr/local/bin/hellopy
    - target: /usr/local/bin/hello.py

# this didn't work
append_string_hellopy_in_file:
  file.append:
    - name: /etc/bash.bashrc
    - text: 'alias hellopy="hello.py"'

install_dependencies:
  pkg.installed:
    - pkgs:
      - curl
      - xclip

download_micro:
  cmd.run:
    - name: 'curl https://getmic.ro | bash'
    - cwd: '/tmp'
    - require:
      - pkg: install_dependencies

move_micro:
  cmd.run:
    - name: 'mv /tmp/micro /usr/local/bin/'
    - require:
      - cmd: download_micro