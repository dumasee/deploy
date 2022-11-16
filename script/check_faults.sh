#!/bin/bash
#     
#     
#     check_faults.sh @ Version 0.13
#     date: 2021.11.21


lotus-miner proving faults
echo

faults=$(lotus-miner proving faults|grep -v Miner|grep -v deadline |awk '{print $3}'|sort|uniq)
for i in $faults
do
  echo $i
  ./status.sh $i |grep Status
  ./storagefind.sh $i |grep Sealing
  echo
done


