#!/bin/bash

#     
#     check_ver_for_lotus.sh @ Version 0.1
#     date: 2022.11.21

ps -ef|grep lotus|grep -v grep
lotus -v
lotus-miner -v
lotus-worker -v