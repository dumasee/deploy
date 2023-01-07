#!/bin/bash
#
#     add_ubuntu.sh @ Version 0.1
#     date: 2022.02.27


userdel -r ubuntu

useradd -d /home/ubuntu -s /bin/bash  -m ubuntu
echo "ubuntu:Ubuntu123!" | chpasswd
gpasswd -a ubuntu  adm
gpasswd -a ubuntu  sudo

echo finished.