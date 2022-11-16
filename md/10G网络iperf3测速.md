## server
```
iperf3 -s
```

## client
iperf3 -c 192.168.21.22 -b 10000M -n 20G
```
Connecting to host 192.168.21.22, port 5201
[  4] local 192.168.21.21 port 56842 connected to 192.168.21.22 port 5201
[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
[  4]   0.00-1.00   sec   951 MBytes  7.98 Gbits/sec    0    363 KBytes
[  4]   1.00-2.00   sec  1.05 GBytes  9.04 Gbits/sec    0    369 KBytes
[  4]   2.00-3.00   sec  1.06 GBytes  9.09 Gbits/sec    0    380 KBytes
[  4]   3.00-4.00   sec  1.05 GBytes  9.01 Gbits/sec    0    389 KBytes
[  4]   4.00-5.00   sec  1.06 GBytes  9.10 Gbits/sec    0    409 KBytes
[  4]   5.00-6.00   sec  1.07 GBytes  9.19 Gbits/sec    0    458 KBytes
[  4]   6.00-7.00   sec  1.08 GBytes  9.23 Gbits/sec    0    537 KBytes
[  4]   7.00-8.00   sec  1.07 GBytes  9.23 Gbits/sec    0    537 KBytes
[  4]   8.00-9.00   sec  1.07 GBytes  9.17 Gbits/sec    0    537 KBytes
[  4]   9.00-10.00  sec  1.06 GBytes  9.14 Gbits/sec    0    537 KBytes
[  4]  10.00-11.00  sec  1.06 GBytes  9.11 Gbits/sec    0    537 KBytes
[  4]  11.00-12.00  sec  1.07 GBytes  9.16 Gbits/sec    0    537 KBytes
[  4]  12.00-13.00  sec  1.07 GBytes  9.17 Gbits/sec    0    537 KBytes
[  4]  13.00-14.00  sec  1.07 GBytes  9.21 Gbits/sec    0    537 KBytes
[  4]  14.00-15.00  sec  1.07 GBytes  9.20 Gbits/sec    0    537 KBytes
[  4]  15.00-16.00  sec  1.07 GBytes  9.16 Gbits/sec    0    807 KBytes
[  4]  16.00-17.00  sec  1.06 GBytes  9.14 Gbits/sec    0    807 KBytes
[  4]  17.00-18.00  sec  1.06 GBytes  9.11 Gbits/sec    0    807 KBytes
[  4]  18.00-18.90  sec   994 MBytes  9.31 Gbits/sec    0    807 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-18.90  sec  20.0 GBytes  9.09 Gbits/sec    0             sender
[  4]   0.00-18.90  sec  20.0 GBytes  9.09 Gbits/sec                  receiver

iperf Done.
root@2221:~#
```
