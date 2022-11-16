#!/bin/bash

#     
#     gpu_diag.sh @ Version 0.21
#     date: 2022.07.21


gpu_Num=$(lspci |grep -i GeForce|wc -l)
if [ $gpu_Num == 0 ];then
   echo no GeForce found.
   exit 0
fi

now=$(date "+%Y-%m-%d %H:%M:%S")
sys_uptime=$(cat /proc/uptime|awk '{print $1}'|awk -F. '{print $1}')
nvidia-smi > /dev/null

if [ $? == 0 ];then
   echo $now GPU online
elif [ $sys_uptime -lt 600 ];then
   echo $now GPU is lost
   echo $now reinstall GPU driver
   bash /opt/deploy/NVIDIA-Linux-x86_64-460.67.run --silent
else
   echo $now GPU is lost
   echo $now reboot system
   /sbin/shutdown -r 1
fi


#*/3 * * * * bash /opt/gpu_diag.sh >> gpu_diag.log 2>&1