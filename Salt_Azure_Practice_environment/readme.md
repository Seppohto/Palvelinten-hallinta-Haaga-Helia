# This is a test and demonstration environment for Salt Project related endeavors in the cloud

made in a course: https://terokarvinen.com/2023/palvelinten-hallinta-2023-kevat/

Project is Ready
Licence: GPL2

- Creates environment in Azure using
- IaC deployment
    - allows quick set up and destruction of the setup
    - Bicep
- allows testing close to actual environment
- IaC configuration using idempotent code
- Linux Master
- Linux Minion
    - one in the same network and another in an isolated network
- Windows minion
    - one in the same network and another in an isolated network

# How to run this

Download repo

cd .\Salt_Azure_Practice_environment\

login to azure using
```
az login
```
deploy
```
start.ps1
```

## after deployment is complete 

login to the master computer and accept keys, and run state to install example features
```
sudo salt-key -A
sudo salt '*' state.apply
```

## results
### Linux should have 8 successes

used
file.managed
install_dependencies:
  pkg.installed:
    - pkgs:
      - curl
      - xclip

downloaded micro and
moved it file

### windows
should have 11 success installed packages ann server management tools