
## centos7 yum源 
```
cd /etc/yum.repos.d/
wget http://mirrors.aliyun.com/repo/Centos-7.repo
或  curl -O http://mirrors.aliyun.com/repo/Centos-7.repo

yum clean all && yum makecache

[root@localhost ~]# grep keepcache /etc/yum.conf
keepcache=1
```

## centos 配置ip 
- 配置ip
```
vi /etc/sysconfig/network-scripts/ifcfg-eth2
TYPE="Ethernet"
BOOTPROTO="static"
DEFROUTE="yes"
PEERDNS="yes"
PEERROUTES="yes"
IPV4_FAILURE_FATAL="no"
NAME="eth0"
DEVICE="eth2"
ONBOOT="yes"
IPADDR=10.99.0.2
PREFIX=24
GATEWAY=10.99.0.1
```
- 改dns策略
```
vi /etc/NetworkManager/NetworkManager.conf
[main]
dns=no
```
- 配置dns
vi /etc/resolv.conf
```
nameserver 223.5.5.5
```
- 重启网络
```
systemctl restart NetworkManager
```

## centos 配置telnet服务
```
rpm -qa | grep -i telnet   #查询是否安装
rpm –ivh telnet-server-0.17-47.el6_3.1.i686.rpm   #安装
chkconfig --list | grep -i telnet  #查看telnet服务是否开启
chkconfig telnet on  #开启telnet服务
```