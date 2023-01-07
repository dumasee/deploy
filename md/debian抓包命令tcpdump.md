
1. tcpdump -D 获取网络适配器列表：
```
root@debian:~# tcpdump -D
1.eth0
2.nflog (Linux netfilter log (NFLOG) interface)
3.any (Pseudo-device that captures on all interfaces)
4.lo
```

2. tcpdump -i <需要监控的网络适配器编号>
```
tcpdump -i any udp port 1812 -X
-i:定义监控的网卡号，默认使用列表中的第一个。
-X:显示数据包详细
-w:写入抓包文件
```

3. 将捕获的数据内容记录到文件里，需要使用-w参数：
```
tcpdump  -w radius.pcap -i any udp port 1812
tcpdump -w radius-test-4.pcap -i any udp
```

4、捕获指定ip收到和发送的数据包
```
tcpdump -i any host 211.140.152.10 -X
tcpdump -w smtp465.pcap -i any host 192.168.11.5
```