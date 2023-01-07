#!/bin/sh
ps -fe|grep tscd |grep -v grep
if [ $? -eq 0 ]
then
    echo "runing....."
else
    echo "start process....."
    /root/online1/tscd.sh -daemon
fi
