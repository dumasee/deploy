#!/bin/bash
#
#     hwinfo.sh @ Version 0.29
#     date: 2022.04.22


function hwinfo(){
    model=$(cat /proc/cpuinfo |grep "model name"|head -1|awk -F: '{print $2}')
    cpus=$(grep 'physical id' /proc/cpuinfo | sort -u | wc -l)
    cores=$(grep 'core id' /proc/cpuinfo | sort -u | wc -l)
    threads=$(grep 'processor' /proc/cpuinfo | sort -u | wc -l)
    echo
    echo 'CPU类型:' $model 
    echo 'cpu数量/每cpu核心数/总线程数: '$cpus'/'$cores'/'$threads
    mem=$(free -h |grep Mem|awk '{print $2}')
    echo 'Mem: ' $mem
    echo && echo 'Disk:' && fdisk -l|grep Disk|grep dev|grep -v loop
    echo && echo "Ethernet:" && lspci|grep -i net
    echo && echo 'VGA:' && lspci |grep -i vga
    echo && echo 'Raid:' && lspci |grep -i raid
    return 0
}
hwinfo

# 阵列卡 数量，型号
echo
echo storcli:
storcli show|egrep '^ *[0-9]'


# dmidecode：厂商，型号，主机序列号，主板序列号
echo
echo Manufacturer/Type/DeviceSerial/BoardSerial:
dmidecode | grep 'System Information' -A9 | egrep 'Manufacturer|Product|Serial'
dmidecode -t 2 | grep Serial

