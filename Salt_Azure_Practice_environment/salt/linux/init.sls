/tmp/infra-as-code:
  file.managed
  
hello_sh:
  file.managed:
    - name: /usr/local/bin/hello.sh
    - source: salt://linux/scripts/hello.sh
    - mode: 755

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
    - mode: 755

hellopy_symlink:
  file.symlink:
    - name: /usr/local/bin/hellopy
    - target: /usr/local/bin/hello.py

append_string_hellopy_in_file:
  file.append:
    - name: /etc/bash.bashrc
    - text: 'alias hellopy="hello.py"'

install_micro:
  pkg.installed:
    - name: micro

