# Harjoitus viikko 2

## Johdanto
Tässä raportissa käsitellään demonien (daemons) hallintaa ja automatisointia Salt-työkalulla. Demonit ovat taustaprosesseja, jotka ajavat palveluita tai sovelluksia käyttöjärjestelmän taustalla. Demonien hallinta voi olla haastavaa, mutta automatisointi Saltin avulla helpottaa tehtävää merkittävästi.

Raportti käsittelee konkreettisesti OpenSSH-palvelimen asennusta, konfigurointia ja hallintaa Saltin avulla. Luvut käsittelevät käsin tehtyä asennusta ja konfigurointia, konfiguraation automatisointia Saltilla, sekä asetusten muuttamista ja demonin käynnistyksen testaamista ja vaikutusta Saltin avulla.

Raportti on tarkoitettu niille, jotka ovat kiinnostuneita demonien hallinnasta ja automatisoinnista, ja jotka haluavat oppia käyttämään Salt-työkalua demonien hallintaan.

# Karvinen 2018 -artikkelin tiivistelmä

Artikkelissa "Pkg-File-Service – Control Daemons with Salt – Change SSH Server Port" opetetaan, miten demonien (daemons) käyttöä voi hallita automatisoimalla asennus- ja konfiguraatioprosessit Salt-työkalulla. Artikkeli keskittyy erityisesti OpenSSH-palvelimen konfigurointiin ja uuden kuuntelupisteen (port 8888) lisäämiseen.

- voit hallita helposti suuria määriä tällä työkalulla
- asenna softa
- korvaa config file
- restart daemon

- tehdään ssh config tiedosto
- ajetaan se orjille


# OpenSSH-palvelimen käsin asennus ja konfigurointi
Tässä luvussa suoritettiin OpenSSH-palvelimen käsin asennus ja konfigurointi seuraavien vaiheiden mukaisesti:

virtuaalikoneet ylös

```
vagrant up
```

yhdistäminen koneeseen
```
vagrant ssh t001
```
SSH asennus
```
vagrant@t001:~$ sudo apt-get install openssh-server
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
openssh-server is already the newest version (1:8.4p1-5+deb11u1).
0 upgraded, 0 newly installed, 0 to remove and 10 not upgraded.
vagrant@t001:~$
```


Muokattiin tiedostoa /etc/ssh/sshd_config lisäämällä uusi kuuntelupiste:
```
cd /etc/ssh
sudoedit sshd_config
# Lisätään uusi kuuntelupiste kommentoimalla port rivi ja muokkaamalla porttia
Port 2222
```

Testattiin konfiguraation toimivuus yhdistämällä 
```
vagrant@tmaster:~$ nc -vz 192.168.12.3 2222
192.168.12.3: inverse host lookup failed: Host name lookup failure
(UNKNOWN) [192.168.12.3] 2222 (?) : Connection refused
vagrant@tmaster:~$ nc -vz 192.168.12.3 22
192.168.12.3: inverse host lookup failed: Host name lookup failure
(UNKNOWN) [192.168.12.3] 22 (ssh) open
vagrant@tmaster:~$
```
Eli restartti jääny tekemättä?
```
vagrant@t001:~$ sudo systemctl restart ssh
```
jumii

Suoritin 
```
vagrant dest
```

hmm: Eli vika olikin Ip osoitteessa. ja se toimi mutta kesti pitkään älytä katsoa se ja varmistaa


vagrant@tmaster:~$ nc -vz 192.168.12.100 8888
192.168.12.100: inverse host lookup failed: Unknown host
(UNKNOWN) [192.168.12.100] 8888 (?) open
vagrant@tmaster:~$ nc -vz 192.168.12.100 22
192.168.12.100: inverse host lookup failed: Unknown host
(UNKNOWN) [192.168.12.100] 22 (ssh) : Connection refused
vagrant@tmaster:~$


# Automatisoidaan Saltilla

## I followed closely to the instructions and opened ports 888 and 22

https://terokarvinen.com/2018/pkg-file-service-control-daemons-with-salt-change-ssh-server-port/?fromSearch=salt%20ssh
no problems

```
vagrant@tmaster:~$ sudo salt-key
Accepted Keys:
Denied Keys:
Unaccepted Keys:
t001
t002
Rejected Keys:
vagrant@tmaster:~$ sudo salt-key -a
Usage: salt-key [options]

salt-key: error: -a option requires 1 argument
vagrant@tmaster:~$ sudo salt-key -A
The following keys are going to be accepted:
Unaccepted Keys:
t001
t002
Proceed? [n/Y] Y
Key for minion t001 accepted.
Key for minion t002 accepted.
vagrant@tmaster:~$ sudo salt '*' test.ping
t001:
    True
t002:
    True
vagrant@tmaster:~$ cat /srv/salt/sshd.sls
cat: /srv/salt/sshd.sls: No such file or directory
vagrant@tmaster:~$ touch /srv/salt/sshd.sls
touch: cannot touch '/srv/salt/sshd.sls': No such file or directory
vagrant@tmaster:~$ echo "openssh-server: /srv/salt/sshd.sls
>  pkg.installed
> /etc/ssh/sshd_config:
>  file.managed:
>    - source: salt://sshd_config
> sshd:
>  service.running:
>    - watch:
>      - file: /etc/ssh/sshd_config"^C
vagrant@tmaster:~$ touch^Csrv/salt/sshd.sls
vagrant@tmaster:~$ $ sudo mkdir -p /srv/salt/
-bash: $: command not found
vagrant@tmaster:~$ $ sudo touch /srv/salt/sshd.sls
-bash: $: command not found
vagrant@tmaster:~$ sudo mkdir -p /srv/salt/
vagrant@tmaster:~$ sudo touch /srv/salt/sshd.sls
vagrant@tmaster:~$ $ sudo nano /srv/salt/sshd.sls
-bash: $: command not found
vagrant@tmaster:~$ sudo nano /srv/salt/sshd.sls
vagrant@tmaster:~$ vagrant@tmaster:~$ $ sudo touch /srv/salt/sshd_config
-bash: $: command not found
vagrant@tmaster:~$ sudo touch /srv/salt/sshd_config
vagrant@tmaster:~$  $ sudo nano /srv/salt/sshd_config
-bash: $: command not found
vagrant@tmaster:~$ $ sudo nano /srv/salt/sshd_config
-bash: $: command not found
vagrant@tmaster:~$ sudo nano /srv/salt/sshd_config
vagrant@tmaster:~$ vagrant@tmaster:~$ $ sudo salt '*' state.apply sshd
-bash: $: command not found
vagrant@tmaster:~$ sudo salt '*' state.apply sshd
t002:
----------
          ID: openssh-server
    Function: pkg.installed
      Result: True
     Comment: All specified packages are already installed
     Started: 13:53:51.961639
    Duration: 41.107 ms
     Changes:
----------
          ID: /etc/ssh/sshd_config
    Function: file.managed
      Result: True
     Comment: File /etc/ssh/sshd_config updated
     Started: 13:53:52.008642
    Duration: 68.64 ms
     Changes:
              ----------
              diff:
                  ---
                  +++
                  @@ -1,127 +1,31 @@
                  -#    $OpenBSD: sshd_config,v 1.103 2018/04/09 20:41:22 tj Exp $
                  -
                  -# This is the sshd server system-wide configuration file.  See
                  -# sshd_config(5) for more information.
                  -
                  -# This sshd was compiled with PATH=/usr/bin:/bin:/usr/sbin:/sbin
                  -
                  -# The strategy used for options in the default sshd_config shipped with
                  -# OpenSSH is to specify options with their default value where
                  -# possible, but leave them commented.  Uncommented options override the
                  -# default value.
                  -
                  -Include /etc/ssh/sshd_config.d/*.conf
                  -
                  -#Port 22
                  -#AddressFamily any
                  -#ListenAddress 0.0.0.0
                  -#ListenAddress ::
                  -
                  -#HostKey /etc/ssh/ssh_host_rsa_key
                  -#HostKey /etc/ssh/ssh_host_ecdsa_key
                  -#HostKey /etc/ssh/ssh_host_ed25519_key
                  -
                  -# Ciphers and keying
                  -#RekeyLimit default none
                  -
                  -# Logging
                  -#SyslogFacility AUTH
                  -#LogLevel INFO
                  -
                  -# Authentication:
                  -
                  -#LoginGraceTime 2m
                  -#PermitRootLogin prohibit-password
                  -#StrictModes yes
                  -#MaxAuthTries 6
                  -#MaxSessions 10
                  -
                  -#PubkeyAuthentication yes
                  -
                  -# Expect .ssh/authorized_keys2 to be disregarded by default in future.
                  -#AuthorizedKeysFile  .ssh/authorized_keys .ssh/authorized_keys2
                  -
                  -#AuthorizedPrincipalsFile none
                  -
                  -#AuthorizedKeysCommand none
                  -#AuthorizedKeysCommandUser nobody
                  -
                  -# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
                  -#HostbasedAuthentication no
                  -# Change to yes if you don't trust ~/.ssh/known_hosts for
                  -# HostbasedAuthentication
                  -#IgnoreUserKnownHosts no
                  -# Don't read the user's ~/.rhosts and ~/.shosts files
                  -#IgnoreRhosts yes
                  -
                  -# To disable tunneled clear text passwords, change to no here!
                  -PasswordAuthentication no
                  -#PermitEmptyPasswords no
                  -
                  -# Change to yes to enable challenge-response passwords (beware issues with
                  -# some PAM modules and threads)
                  +# DON'T EDIT - managed file, changes will be overwritten
                  +Port 8888
                  +Protocol 2
                  +HostKey /etc/ssh/ssh_host_rsa_key
                  +HostKey /etc/ssh/ssh_host_dsa_key
                  +HostKey /etc/ssh/ssh_host_ecdsa_key
                  +HostKey /etc/ssh/ssh_host_ed25519_key
                  +UsePrivilegeSeparation yes
                  +KeyRegenerationInterval 3600
                  +ServerKeyBits 1024
                  +SyslogFacility AUTH
                  +LogLevel INFO
                  +LoginGraceTime 120
                  +PermitRootLogin prohibit-password
                  +StrictModes yes
                  +RSAAuthentication yes
                  +PubkeyAuthentication yes
                  +IgnoreRhosts yes
                  +RhostsRSAAuthentication no
                  +HostbasedAuthentication no
                  +PermitEmptyPasswords no
                   ChallengeResponseAuthentication no
                  -
                  -# Kerberos options
                  -#KerberosAuthentication no
                  -#KerberosOrLocalPasswd yes
                  -#KerberosTicketCleanup yes
                  -#KerberosGetAFSToken no
                  -
                  -# GSSAPI options
                  -#GSSAPIAuthentication no
                  -#GSSAPICleanupCredentials yes
                  -#GSSAPIStrictAcceptorCheck yes
                  -#GSSAPIKeyExchange no
                  -
                  -# Set this to 'yes' to enable PAM authentication, account processing,
                  -# and session processing. If this is enabled, PAM authentication will
                  -# be allowed through the ChallengeResponseAuthentication and
                  -# PasswordAuthentication.  Depending on your PAM configuration,
                  -# PAM authentication via ChallengeResponseAuthentication may bypass
                  -# the setting of "PermitRootLogin without-password".
                  -# If you just want the PAM account and session checks to run without
                  -# PAM authentication, then enable this but set PasswordAuthentication
                  -# and ChallengeResponseAuthentication to 'no'.
                  +X11Forwarding yes
                  +X11DisplayOffset 10
                  +PrintMotd no
                  +PrintLastLog yes
                  +TCPKeepAlive yes
                  +AcceptEnv LANG LC_*
                  +Subsystem sftp /usr/lib/openssh/sftp-server
                   UsePAM yes

                  -#AllowAgentForwarding yes
                  -#AllowTcpForwarding yes
                  -#GatewayPorts no
                  -X11Forwarding yes
                  -#X11DisplayOffset 10
                  -#X11UseLocalhost yes
                  -#PermitTTY yes
                  -PrintMotd no
                  -#PrintLastLog yes
                  -#TCPKeepAlive yes
                  -#PermitUserEnvironment no
                  -#Compression delayed
                  -#ClientAliveInterval 0
                  -#ClientAliveCountMax 3
                  -#UseDNS no
                  -#PidFile /var/run/sshd.pid
                  -#MaxStartups 10:30:100
                  -#PermitTunnel no
                  -#ChrootDirectory none
                  -#VersionAddendum none
                  -
                  -# no default banner path
                  -#Banner none
                  -
                  -# Allow client to pass locale environment variables
                  -AcceptEnv LANG LC_*
                  -
                  -# override default of no subsystems
                  -Subsystem    sftp    /usr/lib/openssh/sftp-server
                  -
                  -# Example of overriding settings on a per-user basis
                  -#Match User anoncvs
                  -#    X11Forwarding no
                  -#    AllowTcpForwarding no
                  -#    PermitTTY no
                  -#    ForceCommand cvs server
                  -ClientAliveInterval 120
                  -
                  -# debian vagrant box speedup
                  -UseDNS no
----------
          ID: sshd
    Function: service.running
      Result: True
     Comment: Service restarted
     Started: 13:53:52.155740
    Duration: 131.455 ms
     Changes:
              ----------
              sshd:
                  True

Summary for t002
------------
Succeeded: 3 (changed=2)
Failed:    0
------------
Total states run:     3
Total run time: 241.202 ms
t001:
----------
          ID: openssh-server
    Function: pkg.installed
      Result: True
     Comment: All specified packages are already installed
     Started: 13:53:51.973245
    Duration: 44.31 ms
     Changes:
----------
          ID: /etc/ssh/sshd_config
    Function: file.managed
      Result: True
     Comment: File /etc/ssh/sshd_config updated
     Started: 13:53:52.022379
    Duration: 65.966 ms
     Changes:
              ----------
              diff:
                  ---
                  +++
                  @@ -1,127 +1,31 @@
                  -#    $OpenBSD: sshd_config,v 1.103 2018/04/09 20:41:22 tj Exp $
                  -
                  -# This is the sshd server system-wide configuration file.  See
                  -# sshd_config(5) for more information.
                  -
                  -# This sshd was compiled with PATH=/usr/bin:/bin:/usr/sbin:/sbin
                  -
                  -# The strategy used for options in the default sshd_config shipped with
                  -# OpenSSH is to specify options with their default value where
                  -# possible, but leave them commented.  Uncommented options override the
                  -# default value.
                  -
                  -Include /etc/ssh/sshd_config.d/*.conf
                  -
                  -#Port 22
                  -#AddressFamily any
                  -#ListenAddress 0.0.0.0
                  -#ListenAddress ::
                  -
                  -#HostKey /etc/ssh/ssh_host_rsa_key
                  -#HostKey /etc/ssh/ssh_host_ecdsa_key
                  -#HostKey /etc/ssh/ssh_host_ed25519_key
                  -
                  -# Ciphers and keying
                  -#RekeyLimit default none
                  -
                  -# Logging
                  -#SyslogFacility AUTH
                  -#LogLevel INFO
                  -
                  -# Authentication:
                  -
                  -#LoginGraceTime 2m
                  -#PermitRootLogin prohibit-password
                  -#StrictModes yes
                  -#MaxAuthTries 6
                  -#MaxSessions 10
                  -
                  -#PubkeyAuthentication yes
                  -
                  -# Expect .ssh/authorized_keys2 to be disregarded by default in future.
                  -#AuthorizedKeysFile  .ssh/authorized_keys .ssh/authorized_keys2
                  -
                  -#AuthorizedPrincipalsFile none
                  -
                  -#AuthorizedKeysCommand none
                  -#AuthorizedKeysCommandUser nobody
                  -
                  -# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
                  -#HostbasedAuthentication no
                  -# Change to yes if you don't trust ~/.ssh/known_hosts for
                  -# HostbasedAuthentication
                  -#IgnoreUserKnownHosts no
                  -# Don't read the user's ~/.rhosts and ~/.shosts files
                  -#IgnoreRhosts yes
                  -
                  -# To disable tunneled clear text passwords, change to no here!
                  -PasswordAuthentication no
                  -#PermitEmptyPasswords no
                  -
                  -# Change to yes to enable challenge-response passwords (beware issues with
                  -# some PAM modules and threads)
                  +# DON'T EDIT - managed file, changes will be overwritten
                  +Port 8888
                  +Protocol 2
                  +HostKey /etc/ssh/ssh_host_rsa_key
                  +HostKey /etc/ssh/ssh_host_dsa_key
                  +HostKey /etc/ssh/ssh_host_ecdsa_key
                  +HostKey /etc/ssh/ssh_host_ed25519_key
                  +UsePrivilegeSeparation yes
                  +KeyRegenerationInterval 3600
                  +ServerKeyBits 1024
                  +SyslogFacility AUTH
                  +LogLevel INFO
                  +LoginGraceTime 120
                  +PermitRootLogin prohibit-password
                  +StrictModes yes
                  +RSAAuthentication yes
                  +PubkeyAuthentication yes
                  +IgnoreRhosts yes
                  +RhostsRSAAuthentication no
                  +HostbasedAuthentication no
                  +PermitEmptyPasswords no
                   ChallengeResponseAuthentication no
                  -
                  -# Kerberos options
                  -#KerberosAuthentication no
                  -#KerberosOrLocalPasswd yes
                  -#KerberosTicketCleanup yes
                  -#KerberosGetAFSToken no
                  -
                  -# GSSAPI options
                  -#GSSAPIAuthentication no
                  -#GSSAPICleanupCredentials yes
                  -#GSSAPIStrictAcceptorCheck yes
                  -#GSSAPIKeyExchange no
                  -
                  -# Set this to 'yes' to enable PAM authentication, account processing,
                  -# and session processing. If this is enabled, PAM authentication will
                  -# be allowed through the ChallengeResponseAuthentication and
                  -# PasswordAuthentication.  Depending on your PAM configuration,
                  -# PAM authentication via ChallengeResponseAuthentication may bypass
                  -# the setting of "PermitRootLogin without-password".
                  -# If you just want the PAM account and session checks to run without
                  -# PAM authentication, then enable this but set PasswordAuthentication
                  -# and ChallengeResponseAuthentication to 'no'.
                  +X11Forwarding yes
                  +X11DisplayOffset 10
                  +PrintMotd no
                  +PrintLastLog yes
                  +TCPKeepAlive yes
                  +AcceptEnv LANG LC_*
                  +Subsystem sftp /usr/lib/openssh/sftp-server
                   UsePAM yes

                  -#AllowAgentForwarding yes
                  -#AllowTcpForwarding yes
                  -#GatewayPorts no
                  -X11Forwarding yes
                  -#X11DisplayOffset 10
                  -#X11UseLocalhost yes
                  -#PermitTTY yes
                  -PrintMotd no
                  -#PrintLastLog yes
                  -#TCPKeepAlive yes
                  -#PermitUserEnvironment no
                  -#Compression delayed
                  -#ClientAliveInterval 0
                  -#ClientAliveCountMax 3
                  -#UseDNS no
                  -#PidFile /var/run/sshd.pid
                  -#MaxStartups 10:30:100
                  -#PermitTunnel no
                  -#ChrootDirectory none
                  -#VersionAddendum none
                  -
                  -# no default banner path
                  -#Banner none
                  -
                  -# Allow client to pass locale environment variables
                  -AcceptEnv LANG LC_*
                  -
                  -# override default of no subsystems
                  -Subsystem    sftp    /usr/lib/openssh/sftp-server
                  -
                  -# Example of overriding settings on a per-user basis
                  -#Match User anoncvs
                  -#    X11Forwarding no
                  -#    AllowTcpForwarding no
                  -#    PermitTTY no
                  -#    ForceCommand cvs server
                  -ClientAliveInterval 120
                  -
                  -# debian vagrant box speedup
                  -UseDNS no
----------
          ID: sshd
    Function: service.running
      Result: True
     Comment: Service restarted
     Started: 13:53:52.172508
    Duration: 132.051 ms
     Changes:
              ----------
              sshd:
                  True

Summary for t001
------------
Succeeded: 3 (changed=2)
Failed:    0
------------
Total states run:     3
Total run time: 242.327 ms
vagrant@tmaster:~$ $ ssh -p 8888 tero@<slave-ip-address>
-bash: syntax error near unexpected token `newline'
vagrant@tmaster:~$ $ ssh -p 8888 tero@<slave-ip-address>
-bash: syntax error near unexpected token `newline'
vagrant@tmaster:~$ nc -vz 192.168.12.3 8888
192.168.12.3: inverse host lookup failed: Unknown host
(UNKNOWN) [192.168.12.3] 8888 (?) : Connection refused
vagrant@tmaster:~$ sudo salt grains.item ipv4
No minions matched the target. No command was sent, no jid was assigned.
ERROR: No return received
vagrant@tmaster:~$ sudo salt '*' grains.item ipv4
t001:
    ----------
    ipv4:
        - 10.0.2.15
        - 127.0.0.1
        - 192.168.12.100
t002:
    ----------
    ipv4:
        - 10.0.2.15
        - 127.0.0.1
        - 192.168.12.102
vagrant@tmaster:~$ nc -vz 192.168.12.100 8888
192.168.12.100: inverse host lookup failed: Unknown host
(UNKNOWN) [192.168.12.100] 8888 (?) open
vagrant@tmaster:~$ nc -vz 192.168.12.100 22
192.168.12.100: inverse host lookup failed: Unknown host
(UNKNOWN) [192.168.12.100] 22 (ssh) : Connection refused
vagrant@tmaster:~$
vagrant@tmaster:~$ sudo salt '*' state.apply sshd
t001:
----------
          ID: openssh-server
    Function: pkg.installed
      Result: True
     Comment: All specified packages are already installed
     Started: 14:04:58.587921
    Duration: 36.702 ms
     Changes:
----------
          ID: /etc/ssh/sshd_config
    Function: file.managed
      Result: True
     Comment: File /etc/ssh/sshd_config updated
     Started: 14:04:58.629634
    Duration: 87.389 ms
     Changes:
              ----------
              diff:
                  ---
                  +++
                  @@ -1,5 +1,6 @@
                   # DON'T EDIT - managed file, changes will be overwritten
                   Port 8888
                  +Port 22
                   Protocol 2
                   HostKey /etc/ssh/ssh_host_rsa_key
                   HostKey /etc/ssh/ssh_host_dsa_key
----------
          ID: sshd
    Function: service.running
      Result: True
     Comment: Service restarted
     Started: 14:04:58.792377
    Duration: 108.968 ms
     Changes:
              ----------
              sshd:
                  True

Summary for t001
------------
Succeeded: 3 (changed=2)
Failed:    0
------------
Total states run:     3
Total run time: 233.059 ms
t002:
----------
          ID: openssh-server
    Function: pkg.installed
      Result: True
     Comment: All specified packages are already installed
     Started: 14:04:58.769383
    Duration: 38.572 ms
     Changes:
----------
          ID: /etc/ssh/sshd_config
    Function: file.managed
      Result: True
     Comment: File /etc/ssh/sshd_config updated
     Started: 14:04:58.813519
    Duration: 65.744 ms
     Changes:
              ----------
              diff:
                  ---
                  +++
                  @@ -1,5 +1,6 @@
                   # DON'T EDIT - managed file, changes will be overwritten
                   Port 8888
                  +Port 22
                   Protocol 2
                   HostKey /etc/ssh/ssh_host_rsa_key
                   HostKey /etc/ssh/ssh_host_dsa_key
----------
          ID: sshd
    Function: service.running
      Result: True
     Comment: Service restarted
     Started: 14:04:58.950224
    Duration: 112.928 ms
     Changes:
              ----------
              sshd:
                  True

Summary for t002
------------
Succeeded: 3 (changed=2)
Failed:    0
------------
Total states run:     3
Total run time: 217.244 ms
vagrant@tmaster:~$ nc -vz 192.168.12.100 22
192.168.12.100: inverse host lookup failed: Unknown host
(UNKNOWN) [192.168.12.100] 22 (ssh) open
vagrant@tmaster:~$ nc -vz 192.168.12.100 8888
192.168.12.100: inverse host lookup failed: Unknown host
(UNKNOWN) [192.168.12.100] 8888 (?) open
vagrant@tmaster:~$ sudo salt '*' state.apply sshd
t001:
----------
          ID: openssh-server
    Function: pkg.installed
      Result: True
     Comment: All specified packages are already installed
     Started: 14:12:02.731051
    Duration: 81.875 ms
     Changes:
----------
          ID: /etc/ssh/sshd_config
    Function: file.managed
      Result: True
     Comment: File /etc/ssh/sshd_config is in the correct state
     Started: 14:12:02.817540
    Duration: 67.386 ms
     Changes:
----------
          ID: sshd
    Function: service.running
      Result: True
     Comment: The service sshd is already running
     Started: 14:12:02.886477
    Duration: 70.729 ms
     Changes:

Summary for t001
------------
Succeeded: 3
Failed:    0
------------
Total states run:     3
Total run time: 219.990 ms
t002:
----------
          ID: openssh-server
    Function: pkg.installed
      Result: True
     Comment: All specified packages are already installed
     Started: 14:12:02.815354
    Duration: 43.697 ms
     Changes:
----------
          ID: /etc/ssh/sshd_config
    Function: file.managed
      Result: True
     Comment: File /etc/ssh/sshd_config is in the correct state
     Started: 14:12:02.863822
    Duration: 54.64 ms
     Changes:
----------
          ID: sshd
    Function: service.running
      Result: True
     Comment: The service sshd is already running
     Started: 14:12:02.920023
    Duration: 58.644 ms
     Changes:

Summary for t002
------------
Succeeded: 3
Failed:    0
------------
Total states run:     3
Total run time: 156.981 ms
vagrant@tmaster:~$```

