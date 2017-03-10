# ListCall Readme

ListCall - Team Alerting and Checklists

## Overview

This is a private repo - for BAMRU members only.  Do not fork or download w/o
permission.  See LICENSE.txt and CLA.txt for more info.

## VM Configuration

Follow these steps to set up a working development environment running on an
Ubuntu Virtual machine.

1. Install VirtualBox and Vagrant on your host machine (Linux, Win, Mac OK)

2. Run `vagrant init` to create a vagrant file

3. Edit `Vagrantfile` - change `base` box to `ubuntu/wily64`.

4. Run `vagrant up` to create a virtual machine.

5. On your host machine, set the `/etc/hosts` VM IP to `bamru.smso.vbox`.

6. Login to your virtual machine using `vagrant ssh`

7. Clone the repo `mkdir lr; cd lr; git clone https://github.com/andyl/Lica.git`

8. CD to the repo directory `cd ~/lr/Lica`

9. Install ansible `script/provision/install_ansible`

10. Install ansible roles `script/provision/install_roles`

11. Provision the dev machine `script/provision/localhost`

12. Check process status: `systemctl status postgresql redis-server memcached`

## Shared Server

For data sharing, SSH forwarding and pair programming, we use a shared server.
The IP address is defined in the file `script/pair/proxy_ip`.  See Andy for the
SSH password.

1. Copy your SSH public key `script/pair/keycopy` 

## Application Bootstrap

Follow these steps to bootstrap the app in your development environment.

1. Install the ruby gems `bash; gem install bundler; bundle install`

2. Download the seed data `script/seed/download` 

3. Import the seed data `script/seed/import` 

4. Start the development console `script/run/console`

5. On your host machine, browse to `http://bamru.smso.vbox:3000`

## Pair Programming

Remote collaboration is done using the shared server with SSH port forwarding
and Tmux/Wemux.

SSH Port Forwarding

- to enable: `script/pair/portfwd 2222 22`
- remote ssh access (from the command line): 
    `ssh vagrant@<PROXY>`
    `ssh -p 2222 <username>@localhost`

HTML Remote Access

- to enable: `script/pair/portfwd 3000 3000`
- remote access (from the browser): `http://<PROXY>:3000`

Shared TMUX Session

- starting a session: `wemux`
- remote access:
    > ssh to to virtual machine
    > type `wemux`

