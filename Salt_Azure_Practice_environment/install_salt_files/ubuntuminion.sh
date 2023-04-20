#Run the following commands to import the Salt Project repository key, and to create the apt sources list file:
sudo mkdir /etc/apt/keyrings

sudo curl -fsSL -o /etc/apt/keyrings/salt-archive-keyring.gpg https://repo.saltproject.io/salt/py3/ubuntu/20.04/amd64/SALT-PROJECT-GPG-PUBKEY-2023.gpg
echo "deb [signed-by=/etc/apt/keyrings/salt-archive-keyring.gpg arch=amd64] https://repo.saltproject.io/salt/py3/ubuntu/20.04/amd64/latest focal main" | sudo tee /etc/apt/sources.list.d/salt.list
#Run sudo apt-get update to update your packages.
sudo apt-get update
#Install the salt-minion, salt-master, or other Salt components:
# sudo apt-get install salt-master
sudo apt-get install salt-minion -y
# sudo apt-get install salt-ssh
# sudo apt-get install salt-syndic
# sudo apt-get install salt-cloud
# sudo apt-get install salt-api
#Enable and start the services for salt-minion, salt-master, or other Salt components:
# sudo systemctl enable salt-master && sudo systemctl start salt-master
sudo systemctl enable salt-minion && sudo systemctl start salt-minion
# sudo systemctl enable salt-syndic && sudo systemctl start salt-syndic
# sudo systemctl enable salt-api && sudo systemctl start salt-api

sudo sh -c 'echo "master:
  - winmaster.swedencentral.cloudapp.azure.com
  - ubuntumaster.swedencentral.cloudapp.azure.com">/etc/salt/minion'
sudo service salt-minion restart


# sudo echo "
# master:
#   - winmaster.swedencentral.cloudapp.azure.com
#   - ubuntumaster.swedencentral.cloudapp.azure.com">/etc/salt/minion
# sudo service salt-minion restart