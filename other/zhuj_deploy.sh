#!/bin/bash
#     
#     Zhuj Deploy Tools
#     zhuj_deploy.sh @ Version 0.13
#     date: 2021.9.14

#fonts color
yellow(){
    echo -e "\033[33m\033[01m$1\033[0m"
}
green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}

comment(){
steps：
1. modify ip
2. create ubuntu account，specify sudo right.
3. run addpkey.sh
4. REM crontab
5. reboot
}

run(){
    cp /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.yaml.bak
    cp 00-installer-config.yaml /etc/netplan/00-installer-config.yaml
    
    useradd -d /home/ubuntu -s /bin/bash  -m ubuntu
    echo "ubuntu:Ubuntu123!" | chpasswd
    gpasswd -a ubuntu  adm
    gpasswd -a ubuntu  sudo
    
    cd ../
    bash addpkey.sh
    
    green "finished..."
    red "You need："
    red "1. modify ip using vi '/etc/netplan/00-installer-config.yaml'"
    red "2. run: netplan apply"
    red "3. REM crontab"
    red "4. reboot"
}

run

