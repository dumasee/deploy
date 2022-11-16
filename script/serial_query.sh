#!/bin/bash
#
#     serial_query.sh @ Version 0.13
#     date: 2021.9.5


#厂商，型号，主机序列号
dmidecode | grep 'System Information' -A9 | egrep 'Manufacturer|Product|Serial'

#主板序列号
#dmidecode -t 2 | grep Serial


