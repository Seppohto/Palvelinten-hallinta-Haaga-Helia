/tmp/infra-as-code:
  file.managed
  
hello_sh:
  file.managed:
    - name: /usr/local/bin/hello.sh
    - source: salt://linux/scripts/hello.sh
    - mode: 755

ensure_string_hellosh_in_file:
  file.line:
    - name: /usr/local/bin/hello.sh
    - mode: ensure
    - content: 'alias hellosh="hello.sh"'

hello_py:
  file.managed:
    - name: /usr/local/bin/hello.py
    - source: salt://linux/scripts/hello.py
    - mode: 755

ensure_string_hellopy_in_file:
  file.line:
    - name: /usr/local/bin/hello.py
    - mode: ensure
    - content: 'alias hellopy="hello.py"'

install_micro:
  pkg.installed:
    - name: micro

