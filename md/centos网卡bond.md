1. 更改网卡配置
在做bond的时候一般都是两个网卡以上的，
在/etc/sysconfig/network-scripts/中将你需要做bond的的网卡内容改为以下：
```
TYPE=Ethernet
BOOTPROTO=none
DEVICE=em1
ONBOOT=yes
MASTER=bond0
SLAVE=yes
```

2. 新建bond配置
在上述目录下新建ifcfg-bond0(这里只是新建名称，也可以新建其他名称)，在此文件内新增：
```
DEVICE=bond0
TYPE=Bond
NAME=bond0
BONDING_MASTER=yes
BOOTPROTO=static
USERCTL=no
ONBOOT=yes
IPADDR=192.168.21.3
NETMASK=255.255.255.0
GATEWAY=192.168.21.1
BONDING_OPTS="mode=4 miimon=100"
```

3. 重启network