#!/bin/bash
#     
#     clean logs to avoid disk usage
#     clean_log.sh @ Version 0.23
#     date: 2021.11.9

#每小时备份一个日志，24小时循环，保留一天的日志
cleanlog(){
  [ ! -d $1 ] && echo $1: path not found! && return 0
  per=$(df | grep /$ |awk '{print $5}' | sed 's/%//g')   # / usage
  
  log=$1/daemon.log
  if [ -f $log ];then
	  cp $log "$log.bak.`date +\"%H\"`"
	  echo > $log
	  echo $log: moved
    #size=$(ls -l $log | awk '{print $5}')
    #[ $size -gt 25000000000 ] && ls -lh $log && echo > $log && echo $log: cleaned.
    #[ $per -gt 90 ] && ls -lh $log && echo > $log && echo $log: cleaned.
  fi
  
  log=$1/miner.log
  if [ -f $log ];then
	  cp $log "$log.bak.`date +\"%H\"`"
	  echo > $log
	  echo $log: moved
    #size=$(ls -l $log | awk '{print $5}')
    #[ $size -gt 25000000000 ] && ls -lh $log && echo > $log && echo $log: cleaned.
    #[ $per -gt 90 ] && ls -lh $log && echo > $log && echo $log: cleaned.
  fi
}

date +%Y-%m-%d_%H%M%S
cleanlog /home/lxl/lotus-amd-eb/log  #ipfs1自建
cleanlog /home/eb2/lotus-amd-eb/log  #ipfs5郁康，备miner进程...
cleanlog /home/eb/lotus-amd-eb/log   #ipfs2北京1 ipfs3云联储, ipfs4-miner1, ipfs6刘伟夫, ipfs7, ipfs鞍山，ipfs太原, ipfs成都
cleanlog /home/eb/lotus-1.6.0-amd-eb/log  #ipfs4miner2


#  0 */1 * * * bash /opt/clean_log.sh >> clean_log.log 2>&1
