## 磁盘io

iostat -d -m 3 10 |egrep 'sdaj|Device'
iostat -d -m -x 1 5 |egrep 'sdaj|Device'

iostat -d -m 3 5 sdy

iotop  -o



## 网卡io
iftop -i bond0 -n -P
vnstat -l