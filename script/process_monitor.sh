#!/bin/bash

#     
#     process_monitor.sh @ Version 0.5
#     date: 2022.11.29

NAMESPACE="textcollector"
hostname=$(hostname)

printProcessStat(){
    local cmdline="$1"
    if [ -z "$2" ]; then
        desc=$cmdline
    else
        local desc="$2"
    fi
    local value=$(ps -ef | grep "$cmdline" | grep -v grep | wc -l)
    echo "${NAMESPACE}_process_state{hostname=\"${hostname}\",cmdline=\"${cmdline}\",desc=\"${desc}\"} ${value}"
}

printNvidiaStat(){
    desc='NvidiaStat'
    nvidia-smi > /dev/null
    if [ $? == 0 ];then
        #echo GPU online
        local value=1
    else
        #echo GPU is lost
        local value=0
    fi
    echo "${NAMESPACE}_nvidia_stat{hostname=\"${hostname}\",desc=\"${desc}\"} ${value}"
}

#for IPFS project
#miner
printProcessStat "lotus daemon" lotus_daemon
printProcessStat "lotus-miner" lotus_miner

printNvidiaStat




#  add to crontab
#*/1 * * * * mkdir -p /tmp/textcollector && bash /opt/process_monitor.sh | sponge /tmp/textcollector/processmonitor.prom