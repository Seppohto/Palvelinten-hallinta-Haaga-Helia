# Week 4. Build scripts, activate them globally, install binary program and control multiple servers with linux and windows os

First parts are done manually in my WSL to make sure the scripts work and are easy to debug.

## 1. Create script that prints shine
first create the script and test it.
```bash
cd ~
#create the file
touch hello.sh
#change script file user rights
chmod +x hello.sh
ls -la
total 36
drwx------  5 root root 4096 Apr 21 22:06 .
drwxr-xr-x 19 root root 4096 Apr 21 10:42 ..
-rw-------  1 root root 3556 Apr 21 22:05 .bash_history
-rw-r--r--  1 root root 3106 Oct 15  2021 .bashrc
drwxr-xr-x  3 root root 4096 Apr 20 15:53 .local
-rw-r--r--  1 root root    0 Apr 21 07:29 .motd_shown
-rw-r--r--  1 root root  161 Jul  9  2019 .profile
drwxr-xr-x  2 root root 4096 Apr 21 10:42 .ssh
-rw-------  1 root root  846 Apr 21 21:18 .viminfo
drwxr-xr-x  2 root root 4096 Apr 21 21:24 downloads
-rwxr-xr-x  1 root root    0 Apr 21 22:06 hello.sh

#next create the contents of the file
nano hello.sh
#and add 
#!/bin/bash
#echo "shine"

#then test the script
./hello.sh
shine
```
Set it for all users
```bash
sudo cp hello.sh /usr/local/bin/
```

## Next make hello.py script

lry's create the hello.py with correct rights
```bash
touch hello.py
chmod +x hello.py
nano hello.py
```
```python
print("hello world")
```
``` bash
python3 hello.py
#hello world
sudo cp hello.py /usr/local/bin/
hello.py
#/usr/local/bin/hello.py: line 1: syntax error near unexpected token `"hello world"'
#/usr/local/bin/hello.py: line 1: `print("hello world")'
```
So it was missing the intrepeter information and i fixed it like this
```python
#!/usr/bin/env python3
print("hello world")
```
now it works
```bash
hello.py
#hello world
```
The shebang line #!/usr/bin/env python3 tells the system to use the python3 interpreter to execute the script when it's run as an executable (e.g., ./hello.py). This allows the script to be executed without explicitly calling the python3 interpreter (e.g., python3 hello.py).

## Make these scripts automatically for salt minions

I'm going to save these scripts into this repository where I have built Infra as Code solution to set up Salt Project environment in Azure.

I wanted to start using Azure instead of Vagrant because:
- Environment is similar to environments that i use at work
- it's faster to set up now that i have done the code.
- I'm more familiar with Azure 


### Create scripts again

In WSL navigate to /usr/local/bin and use cat to print the contents and copy that to my repository

```bash
cd /usr/local/bin
sudo cp hello.py /c/Code/Palvelinten-hallinta-Haaga-Helia/Salt_Azure_Practice_environment/salt/scripts/linux
sudo cp hello.sh /c/Code/Palvelinten-hallinta-Haaga-Helia/Salt_Azure_Practice_environment/salt/scripts/linux
```

waiiiit a minute. I think I can access the same filesystem from wsl.

```bash
/usr/local/bin# sudo cp hello.sh /mnt/c/Code/Palvelinten-hallinta-Haaga-Helia/Salt_Azure_Practice_environment/salt/scripts/linux
/usr/local/bin# sudo cp hello.py /mnt/c/Code/Palvelinten-hallinta-Haaga-Helia/Salt_Azure_Practice_environment/salt/scripts/linux
```

so now the files are copied to git:
- Salt_Azure_Practice_environment\salt\scripts\linux\hello.py
- Salt_Azure_Practice_environment\salt\scripts\linux\hello.sh

### Create Environment

1. Navigate to Salt_Azure_Practice_environment folder
2. Login to correct azure az login
3. Deploy the environment that installs windows and linux minions and linux master vm.
During deployment the script installs the salt minions and a master and then it copies this git repo and copies the salt folder to the master computer /srv/salt/

edit my ubuntu/init.sls files
```
hello_sh:
  file.managed:
    - name: /usr/local/bin/hello.sh
    - source: salt://hello.sh
    - mode: 755

hello_py:
  file.managed:
    - name: /usr/local/bin/hello.py
    - source: salt://hello.py
    - mode: 755
```
4. Once it's deployed. Access the master computer and accept the keys
connect to the server
```bash
ssh olli-admin@ubuntumaster.swedencentral.cloudapp.azure.com
```
accepts the keys and run the state
```
sudo salt-key -A
sudo salt '*' state.apply scripts
```
image.png


