# Harjoitus 1

###### Tein harjoituksen Maanantain 3.4.2023 HP Elitebook läppärillä kotonani.

Asensin koneelle Vagrantin ja Virtualboxin [tehtävänannon ohjeilla](https://terokarvinen.com/2023/palvelinten-hallinta-2023-kevat/)

Loin Vagrant tiedoston opettajan ohjeilla

Käynnistin koneet Vagrant up komennolla PowerShellissä ja n. 20 min päästä totesin ettei se vielä toiminut, koska vagrant up komento jumahti toisen koneen kohtaan t002: Unpacking python3-croniter (0.3.34-3) ...

control C ja sen jälkeen oltiin jumissa taas jumissa
```
t002: Preparing to unpack .../22-python3-croniter_0.3.34-3_all.deb ...
    t002: Unpacking python3-croniter (0.3.34-3) ...
PS C:\Users\olluro\OneDrive - Knowit AB\Desktop\Olli\Palvelinten-hallinta-Haaga-Helia> ==> t002: Waiting for cleanup before exiting...
^C
PS C:\Users\olluro\OneDrive - Knowit AB\Desktop\Olli\Palvelinten-hallinta-Haaga-Helia> vagrant up
Bringing machine 't001' up with 'virtualbox' provider...
Bringing machine 't002' up with 'virtualbox' provider...
Bringing machine 'tmaster' up with 'virtualbox' provider...
==> t001: Checking if box 'debian/bullseye64' version '11.20221219.1' is up to date...
==> t001: Machine already provisioned. Run `vagrant provision` or use the `--provision`
==> t001: flag to force provisioning. Provisioners marked to run always will still run.
An action 'up' was attempted on the machine 't002',
but another process is already executing an action on the machine.
Vagrant locks each machine for access by only one process at a time.
Please wait until the other Vagrant process finishes modifying this
machine, then try again.

If you believe this message is in error, please check the process
listing for any "ruby" or "vagrant" processes and kill them. Then
try again.
PS C:\Users\olluro\OneDrive - Knowit AB\Desktop\Olli\Palvelinten-hallinta-Haaga-Helia>
```

tapoin Ruby prosessit

```
Get-Process | Where-Object {$_.ProcessName -like "ruby*"} | Format-Table -AutoSize

Stop-Process -Id <process_id> -Force
```

Ajoin uudelleen vagrant up ja nyt näytti toimivan

## Hyväksytään avaimet
```
sudo salt-key -A
Y
```
testataan yhteys
```
sudo salt '*' test.ping
```
Toimii

## komennetaan orjia
tietojen keruu
```
sudo salt 't001' grains.items
sudo salt '*' grains.item localhost
```

tiedoston luonti
```
sudo salt '*' state.single file.managed '/tmp/the-unicorn-is-here'
``` 
ohjelmien asennus
```
sudo salt '*' state.single pkg.installed apache2
# tarkistus
sudo salt '*' state.single service.running apache2
#testaus
sudo apt-get -y install curl
curl -s 192.168.12.102|grep title
``` 