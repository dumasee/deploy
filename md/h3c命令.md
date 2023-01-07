

## 开局命令
```
no terminal monitor    #禁止console终端日志显示
undo terminal monitor  #取消终端日志输出，太多了影响操作。
<H3C>sys    #进入配置模式
display device manuinfo chassis-only   #查序列号
dir /all    #查看设备的配置文件，文件名为h3c.cfg
backup startup-configuration to 192.168.1.2 h3c.cfg    #备份配置文件
restore startup-configuration from 192.168.1.2 h3c.cfg   #恢复配置文件
display  startup    #查看下一次启动所使用的配置
display irf   #查看堆叠成功
dis lldp neighbor-information list
reset saved-configuration
ping -vpn-instance for_poap 10.30.1.47    #vpn实例ping
ping -c 1000000 -s 1000 -a 10.30.160.101 10.30.160.102
display  transceiver interface  #查看光模块信息
dis transceiver diagnosis interface xxx  #查看收发光
screen-length disable     #禁止输出多屏显示
session log time-active 30  #会话登录超时
clock timezone BeiJing add 08:00:00   #配置时区
display counters rate inbound interface     #接口进出带宽利用率
display counters rate outbound interface  
```


## h3c防火墙启用web管理
```
ip http enable
local-user admin class manage
  service-type ssh terminal http https
```

## 开启会话的top统计
```
启用命令：
session top-statistics enable

查看：
dis session top-statistics ?
  last-1-hour    Top session statistics in last hour
  last-24-hours  Top session statistics in last 24 hours
  last-30-days   Top session statistics in last 30 days


[fw-eb5floor]dis session top-statistics last-1-hour
Counting by source addresses:
No.      Source address                               Sessions
1        192.168.11.17                                522215
2        172.17.0.3                                   2622
3        192.168.10.50                                2077
4        192.168.13.20                                1391
5        10.0.0.6                                     1059
6        192.168.102.144                              154
7        111.0.121.226                                32
8        45.146.164.198                               18
9        45.146.165.205                               17
10       163.172.194.59                               15

Counting by destination addresses:
No.      Destination address                          Sessions
1        47.91.8.75                                   65841
2        47.91.8.55                                   65667
3        47.91.8.78                                   65647
4        47.90.117.50                                 65532
5        122.254.77.98                                65532
6        122.254.77.138                               65531
7        47.57.197.41                                 65530
8        47.75.18.209                                 65528
9        118.31.245.149                               1395
               
10       223.5.5.5                                    1285
[fw-eb5floor]
```


## pc连交换机刷配置方法
方法1 先配置带外管理口ip，然后用网线连接sw与pc，使用tftp传输配置文件。
方法2 也可以用网线连接pc与sw普通口，更改接口为路由模式并设置ip。
restore startup-configuration from 192.168.1.2 h3c.cfg
dir /all    #查看设备的配置文件，文件名为h3c.cfg
reboot

## 版本升级步骤
1. asw升级（堆叠）
```
<h3c>
copy ftp://ftp:123@10.30.1.201/S6800-CMW710-R2432P05.ipe flash:/ 

boot-loader file flash:/S6800-CMW710-R2432P05.ipe slot 1 main
boot-loader file flash:/S6800-CMW710-R2432P05.ipe slot 2 main

dis boot-loader
reboot
```

2. csw升级
```
<csw>
boot-loader file flash:/S6800-CMW710-R2612.ipe all  main

dis boot-loader   #确认已ok
reboot
```



