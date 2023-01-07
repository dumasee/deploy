#!/bin/bash
#     
#     
#     check_all.sh @ Version 0.3
#     date: 2022.03.02

echo
deadline=$(lotus-miner proving deadlines|grep -v Miner|grep -v deadline |awk '{if($2>0) print $1}')
for i in $deadline
do
  echo $i
  date +%Y.%m.%d_%H:%M:%S
  lotus-miner proving check --slow $i | grep -v good
  echo
done

