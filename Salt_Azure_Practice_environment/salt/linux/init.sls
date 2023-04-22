/tmp/infra-as-code:
  file.managed
  
hello_sh:
  file.managed:
    - name: /usr/local/bin/hello.sh
    - source: salt://scripts/hello.sh
    - mode: 755

hello_py:
  file.managed:
    - name: /usr/local/bin/hello.py
    - source: salt://scripts/hello.py
    - mode: 755
