# Manage a test file
/tmp/infra-as-code:
  file.managed

# Copy hello.sh
hello_sh:
  file.managed:
    - name: /usr/local/bin/hello.sh
    - source: salt://linux/scripts/hello.sh
    - mode: '0755'

# I found this when the other thing didn't work
/usr/local/bin/hellosh:
  file.symlink:
    - target: /usr/local/bin/hello.sh

# Copy hello.py
hello_py:
  file.managed:
    - name: /usr/local/bin/hello.py
    - source: salt://linux/scripts/hello.py
    - mode: '0755'

# I found this when the other thing didn't work
/usr/local/bin/hellopy:
  file.symlink:
    - target: /usr/local/bin/hello.py

# make sure that curl is installed
install_dependencies:
  pkg.installed:
    - pkgs:
      - curl
      - xclip

# download the binary micro
download_micro:
  cmd.run:
    - name: 'curl https://getmic.ro | bash'
    - cwd: '/tmp'
    - unless: 'micro --version'

# make micro usable everywhere
move_micro:
  cmd.run:
    - name: 'mv /tmp/micro /usr/local/bin/'
    - require:
      - cmd: download_micro
    - unless: 'micro --version'