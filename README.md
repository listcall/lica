# ListCall Readme

ListCall (lica) - Team Alerting and Checklists

## Overview

This is a private repo - for BAMRU members only.  Do not fork or download w/o
permission.  See LICENSE.txt and CLA.txt for more info.

## Development VM Configuration

Follow these steps to set up a working development environment running on an
Ubuntu Virtual machine.

NOTE: this configuration process will install many packages and will make
changes to your user configuration, including:
- adding items to your `.bashrc`, modifying your path
- adding your UserID to `sudoers`

To preserve your settings, perform this configuration under a separate userid.

Let's get started:

1. Install VirtualBox and Vagrant on your host machine (Linux, Win, Mac OK)

2. Download the Vagrantfile 
   `wget raw.githubusercontent.com/listcall/lica/Vagrantfile`

3. Run `vagrant up` to create a virtual machine.

4. Login to your virtual machine using `vagrant ssh`

5. Clone the repo 
   `mkdir src; cd src; git clone https://github.com/listcall/lica.git`

6. CD to the repo directory `cd ~/src/lica`

## Development Environment Provisioning

On the new VM:

1. Checkout the dev branch `git checkout -b dev origin/dev`

2. Install ansible `script/dev/provision/install_ansible`

3. Install ansible roles `script/dev/provision/install_roles`

4. Provision the dev machine `script/dev/provision/localhost`

5. Check database status: `systemctl status postgresql`

6. Start a new shell: `bash` (required to load your new user configuration)

## Application Bootstrap

Follow these steps to bootstrap the app in your development environment.

1. Install ruby gems `gem install bundler; bundle install`

2. Install NPM components: `yarn install`

3. Get seed data from a partner:

| PARTNER COMMAND            | YOUR COMMAND             |
|----------------------------|--------------------------|
| `script/seed/share_env`    | `script/seed/get_env`    |
| `script/seed/share_db`     | `script/seed/get_db`     |
| `script/seed/share_sysdir` | `script/seed/get_sysdir` |

4. Import the seed db `script/seed/import_db`

5. Start the tmux development session `script/dev/session`

   A cheat-sheet for tmux navigation is in `~/.tmux.conf`.

## Host Web Access

1. Get the VM IP address `ifconfig`  

2. On your host machine, add the VM IP Address to `/etc/hosts`

3. On your host machine, browse to `http://bamru.smso.dev:3000`

## Online Collaboration

### SSH-Chat

Connect to the SSH-Chat server from the command line.
`script/util/sshchat`

### File Transfer

Sender: 
- type `wormhole send <filename>`
- note the wormhole code

Receiver:
- type `wormhole receive`
- get the wormhole code from the sender
- enter the wormhole code

### Terminal Sharing

Session host:
- start a tmate session `script/tmate/start`
- publish the session address `script/tmate/address`
  the session address is published onto SSH-Chat

Session participant:
- enter the ssh command with session address on your command line

### Desktop Sharing

Visit this url:

https://www.webrtc-experiment.com/desktop-sharing

- Install the desktop-sharing plugin on Chrome
- Share the desktop 
- Use `script/util/sshchat` to publish the connection url 

Pro Tips:

- Configure the desktop-sharing plugin with a fixed room name (like "LICA").
  This will make it possible for team members to bookmark the room, and will
  enable remote sessions to auto-reconnect if a stream is interrupted.

- Share the entire desktop, not an application window.  The reason is that the
  app-window sharing seems to resize/crop incorrectly.

- The session participant should experiment with full-screen (F11) or normal
  browser sizing to get the best image.

## TBD

- Rename the dashboard script
- Fix the wget URL for the Vagrantfile (dev branch)
- Install Firefox on VirtualBox
- Email testing
- Port configuration in Vagrant file
