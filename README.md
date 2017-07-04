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
   `wget raw.githubusercontent.com/listcall/lica/script/dev/Vagrantfile`

3. Run `vagrant up` to create a virtual machine.

4. Login to your virtual machine using `vagrant ssh`

5. Write down the VM IP address `ifconfig`  

## Development Environment Provisioning

On the new VM:

1. Clone the repo `mkdir src; cd src; git clone https://github.com/listcall/lica.git`

2. CD to the repo directory `cd ~/lr/lica`

3. Create a dev branch `git checkout -B dev`

3. Pull the dev branch `git pull origin dev`

3. Install ansible `script/dev/provision/install_ansible`

4. Install ansible roles `script/dev/provision/install_roles`

5. Provision the dev machine `script/dev/provision/localhost`

6. Check database status: `systemctl status postgresql`


## Application Bootstrap

Follow these steps to bootstrap the app in your development environment.

1. Install the ruby gems `bash; gem install bundler; bundle install`

STEPS 2,3,4 ARE UNDER CONSTRUCTION.  CONTACT ANDY.  1 Jul 2017

    2. Download the seed data `script/seed/download_data` 

    3. Download the seed files `script/seed/download_files` 

    4. Import the seed data `script/seed/import` 

5. Start the development dashboard `script/dev/dashboard`

## Host Web Access

1. On your host machine, add the VM IP Address to `/etc/hosts`

2. On your host machine, browse to `http://bamru.smso.dev:3000`

## Online Collaboration

### SSH-Chat

Connect to the SSH-Chat server from the command line.
`script/util/sshchat`

### Remote Pairing

Session host:
- start a tmate session `script/tmate/start`
- publish the session address `script/tmate/address`
  the session address is published onto SSH-Chat

Session participant:
- enter the ssh command with session address on your command line

### File Transfer

Sender: 
- type `wormhole send <filename>`
- note the wormhole code

Receiver:
- get the wormhole code from the sender
- type `wormhole receive`
- enter the wormhole code
