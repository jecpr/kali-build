#Kali Linux CTF Build - Ansible Playbook

This is an ansible playbook to set-up and configure a kali machine designed for CTF's like Hack the Box and Try Hack Me. 

This is heavily based on Ippsec's Parrot build, but tailored for Kali with a handful of other useful tools thrown in for good measure. 

Instructions for installation:
1. Grab the pre-built VM image. 
3. Log in as kali:kali
4. Change root password
```bash
sudo su -
passwd root
reboot
```
4. Upon restart, login as root to change kali username
```bash
userdel -r olduser
groupdel groupname
adduser newuser
groupadd newgroup
usermod -aG adm,dialout,cdrom,floppy,sudo,audio,dip,video,plugdev,users,netdev,bluetooth,scanner,wireshark,kaboxer newuser
reboot
```
5. Upon restart, login with new user and pass
6. Update and upgrade
```bash
sudo apt update
sudo apt full-upgrade
```
7. Install dependencies and configure git (see below)
```bash
python3 -m pip install ansible
sudo apt install ansible-core
cd ~
git clone git@github.com:jecpr/kali-build.git
```
9. Run Ansible script - note you can leave the `extra-vars` part out if you don't have or use ngrok.
```bash
ansible-galaxy install -r requirements.yml
sudo whoami
ansible-playbook main.yml --extra-vars "ngrok_authtoken=INSERT_TOKEN_HERE"
```
9. Restart
10. I use syncthing to synchronise obsidian. If you want to use it, go to syncthing at 127.0.0.1:8384, make bookmark and configure.
11. Configure foxy-proxy (the burp cert is already there).
12. Enjoy :)
