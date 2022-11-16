#!/bin/bash
#     
#     
#     snapshot_server.sh @ Version 0.21
#     date: 2022.05.27


readonly url=http://x.x.x.x:13000/server

ip=$(ip add|grep global|egrep "bond|eth|en" |awk '{print $2}' | awk -F/ '{print $1}'|head -n 1)
ip_public=$(echo $(curl -Ls icanhazip.com))
hostname=$(hostname)
manufacturer=$(echo $(dmidecode -s system-manufacturer))
product_name=$(echo $(dmidecode -s system-product-name))
serial_number=$(echo $(dmidecode -s system-serial-number))
uuid=$(echo $(dmidecode -s system-uuid))
model=$(echo $(cat /proc/cpuinfo |grep "model name"|head -1|awk -F: '{print $2}'))
threads=$(grep 'processor' /proc/cpuinfo | sort -u | wc -l)
memory=$(echo $(free -h |grep Mem|awk '{print $2}'))
disk=$(echo $(fdisk -l|grep Disk|grep dev|grep -v loop|awk -F, '{print $1}'|awk -F: '{print $2}'|sort | uniq -c|awk '{print $1"*"$2,$3}'))
disk_storcli=$(echo $(storcli /call/eall/sall show|egrep  'SATA|SAS'|awk '{print $5,$6,$7}'|sort|uniq -c))
raid_storcli=$(echo $(storcli show|egrep '^ +'[0-9]|awk '{print $1,$2,$4}'))
raid=$(echo $(lspci |grep -i raid|awk -F: '{print $3}'|sort | uniq -c))
net=$(echo $(lspci|grep -i net|awk -F: '{print $3}'|sort | uniq -c))
vga=$(echo $(lspci |grep -i vga|awk -F: '{print $3}'|sort | uniq -c))


if [[ -f /etc/redhat-release ]]; then
    release=$(echo $(cat /etc/redhat-release))
else
    release=$(echo $(lsb_release  -d|awk -F: '{print $2}'))
fi


echo ip: $ip 
echo ip_public: $ip_public 
echo hostname: $hostname 
echo release: $release
echo threads: $threads 
echo memory: $memory 
echo disk: $disk
echo model: $model  
echo manufacturer: $manufacturer 
echo product_name: $product_name 
echo serial_number: $serial_number 
echo uuid: $uuid 
echo net: $net 
echo vga: $vga


curl -Ls $url -X POST -H "Content-Type: application/json" \
    -d '{ "ip": "'$ip'", 
    "ip_public": "'$ip_public'", 
    "hostname": "'$hostname'", 
    "release": "'"$release"'",
    "manufacturer": "'"$manufacturer"'", 
    "product_name": "'"$product_name"'", 
    "serial_number": "'"$serial_number"'", 
    "uuid": "'$uuid'", 
    "model": "'"$model"'", 
    "threads": "'$threads'", 
    "memory": "'$memory'", 
    "disk": "'"$disk"'", 
    "disk_storcli": "'"$disk_storcli"'",
    "raid": "'"$raid"'",
    "raid_storcli": "'"$raid_storcli"'",
    "net": "'"$net"'", 
    "vga": "'"$vga"'"}'

