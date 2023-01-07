#!/bin/bash
#     
#     
#     check_bad.sh @ Version 0.3
#     date: 2021.11.21

echo
deadline=$(lotus-miner proving faults|grep -v Miner|grep -v deadline |awk '{print $1}'|sort|uniq)
for i in $deadline
do
  echo $i
  date +%Y.%m.%d_%H:%M:%S
  lotus-miner proving check --slow $i | grep -v good
  echo
done


