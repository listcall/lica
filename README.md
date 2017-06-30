# ListCall Readme

ListCall (lica) - Team Alerting and Checklists

## Overview

This is a private repo - for BAMRU members only.  Do not fork or download w/o
permission.  See LICENSE.txt and CLA.txt for more info.

## Development VM Configuration

Follow these steps to set up a working development environment running on an
Ubuntu Virtual machine.

1. Install VirtualBox and Vagrant on your host machine (Linux, Win, Mac OK)

2. Download the dev-machine Vagrantfile 
   `wget raw.githubusercontent.com/listcall/lica/script/dev/vm/Vagrantfile`

3. Run `vagrant up` to create a virtual machine.

4. Login to your virtual machine using `vagrant ssh`

5. Write down the VM IP address `ifconfig`  

## Development Environment Provisioning

On the new VM:

1. Clone the repo `mkdir dev; cd dev; git clone https://github.com/listcall/lica.git`

2. CD to the repo directory `cd ~/dev/lica`

3. Get the dev branch `git checkout -B dev ; git pull origin dev`

4. Upgrade the machine `script/dev/provision/system_update`

5. Install ansible `script/dev/provision/install_ansible`

6. Install ansible roles `script/dev/provision/install_roles`

7. Install a ruby interpreter `sudo apt-get install ruby`

8. Provision the dev machine `script/dev/provision/devhost`

9. Check process status: `systemctl status postgresql redis-server memcached`

## Application Bootstrap

Follow these steps to bootstrap the app in your development environment.

1. Install the ruby gems `bash; gem install bundler; bundle install`

2. Download the seed data `script/seed/download` 

3. Import the seed data `script/seed/import` 

4. Start the development dashboard `script/dev/dashboard`

## Host Web Access

1. On your host machine, add the VM IP Address to `/etc/hosts`

2. On your host machine, browse to `http://bamru.smso.vbox:3000`

## Online Collaboration

### SSH-Chat

Connect to the SSH-Chat server from the command line.
`ssh listcall.net -p 2022`

### Remote Pairing

Session host:
- type `script/dev/tmate`
- the remote access token is published onto SSH-Chat

Session participant:
- enter the tmate command with session token on your command line

### File Transfer

Sender: 
- type `wormhole send <filename>`
- note the wormhole code

Receiver:
- get the wormhole code from the sender
- type `wormhole receive`
- enter the wormhole code
