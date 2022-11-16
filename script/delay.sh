#!/bin/bash

#     
#     delay.sh @ Version 0.5
#     date: 2022.07.19


cd /home/eb/lotus-amd-eb/log/
echo "scale=4;$(grep "completed mineOne" miner.log*|grep -v '"nullRounds": 0'|wc -l)/$(grep "completed mineOne" miner.log*|wc -l)"|bc
