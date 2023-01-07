#!/bin/bash
#
#     disk4chia.sh @ Version 0.27
#     date: 2021.9.15

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

#sysdisk=/dev/sda
sysdisk=$(df -hT|grep /$ |awk '{print $1}' |egrep -o /dev/[a-zA-Z]+)

#gdisk
function part(){
    fdisk -l|grep Disk|grep dev|grep -v loop |egrep -v nvme |egrep -v $sysdisk: |grep TiB |awk -F: '{print $1}' |awk '{print "gdisk",$2,"< autokey4gdisk.txt"}'
}

#mkfs
function format(){
    fdisk -l|grep Disk|grep dev|grep -v loop |egrep -v nvme |egrep -v $sysdisk: |grep TiB |awk -F: '{print $1}' |awk '{print "mkfs.xfs -f",$2"1"}' 
}

#mkdir
function mkdirs(){
    max=$(cat format.sh |wc -l)
    for (( i = 1; i <= $max; i++ ))
    do
    echo mkdir -p /mnt/data${i}
    done
}



#mount
function mount_part1(){
    disk=$(fdisk -l|grep Disk|grep dev|grep -v loop |egrep -v nvme |egrep -v $sysdisk: |grep TiB |awk -F: '{print $1}' |awk '{print $2}')
    local n=1
    for p in $disk
    do
    echo mount $p"1" /mnt/data${n} 
    n=$((n+1))
    done
}


#mount
function mount_disk(){
    disk=$(fdisk -l|grep Disk|grep dev|grep -v loop |egrep -v nvme |egrep -v $sysdisk: |grep TiB |awk -F: '{print $1}' |awk '{print $2}')
    local n=1
    for p in $disk
    do
    echo mount -t xfs $p /mnt/data${n} 
    n=$((n+1))
    done
}

function autokey4gdisk(){
    echo o
    echo y
    echo n
    echo
    echo
    echo
    echo
    echo p
    echo w
    echo y
    echo 
}


#nfs exports
function write_to_export(){
    max=$(cat format.sh |wc -l)
    for (( i = 1; i <= $max; i++ ))
    do
    echo "/mnt/data${i}/ *(rw,async,no_root_squash,no_subtree_check)"  
    done
}

function run(){
    echo "echo You should run this script carefully and know exactly what you are doing. "
	echo "echo If you do not want to run it, interrupt the script immediately ..."
    echo "sleep 5s"
    echo "bash part.sh; bash format.sh; bash mkdirs.sh; bash mount_part1.sh; cat exports.txt > /etc/exports;lsblk -f > lsblk.log"
}


part > part.sh
format > format.sh
mkdirs > mkdirs.sh
mount_part1 > mount_part1.sh
mount_disk > mount_disk.sh
write_to_export > exports.txt
autokey4gdisk > autokey4gdisk.txt
#run > run.sh


echo finished: scripts been generated from disk4chia.sh for this host.
echo
