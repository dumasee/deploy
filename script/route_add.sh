#!/bin/bash
#
#     set route for IPFS miner
#     route_add.sh @ Version 0.25
#     date: 2021.8.20
#     


#add route
ip route add 192.168.0.0/16 via 192.168.22.1 dev bond0

#change default route
ip route replace default via 192.168.22.2 dev bond0


#add eb route
# ip route add 111.0.121.226/32 via 192.168.22.2 dev bond0
