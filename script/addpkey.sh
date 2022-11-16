#!/bin/bash
#
#     addpkey/config sshd
#     addpkey.sh @ Version 0.15
#     date: 2021.11.4


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


pk="
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHCVvImg+2R0oPqz7st1osrKrqfDstX/ZckwP9WlayVqwvnccH60z1SypFgaIeVnp34pCVLfM4LgLD9uI1LeMU90xE74HoZMwaG6hDBEyWuTWPCfVMArRRWhKbAfqx8reo6D0UWM7M5UO20IStGnm0qZqWN0/TLR+e+0T8M4pYkhTnN8GrCnHLvpSnTAlpDah3N5+6b8YzjyXQvI06UayMBVtHk1oXcXBZbSxIYnB5bApQA+wXM/O43OdRi7uuRSoT2YwCNzqmI+bhwKtnNok7M9gcm96OoDhiSisFAQcuAia9qFEp+X2MiiINFB9TpZOJD3Kg3SFB6LjUqNEIFY9X root@jms"
f=/root/.ssh/authorized_keys


function add_pkey(){
    echo $pk >> $f
    green "finished: add pkey."
}

function config_sshd(){
    local cfg=/etc/ssh/sshd_config
    sed -i '/^PermitRootLogin/c\PermitRootLogin yes' $cfg
    grep -q ^PermitRootLogin $cfg || sed -i '/^#PermitRootLogin/c\PermitRootLogin yes' $cfg
    sed -i '/^PasswordAuthentication/c\PasswordAuthentication yes' $cfg
    service ssh restart && green "finished: settings for sshd." && return 0
}


[ -d /root/.ssh ] || mkdir -p /root/.ssh
grep root@jms  $f  || add_pkey
config_sshd
