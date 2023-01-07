
1. 配置ip、掩码、网关
```
vi /etc/network/interfaces
auto lo  
iface lo inet loopback  
  
auto eth0  
iface eth0 inet static  
  address 192.168.6.35
  netmask 255.255.255.0
  gateway 192.168.6.1
  dns-nameservers 223.5.5.5 119.29.29.29
```

2. 安装resolvconf，使/etc/network/interfaces里面的dns配置生效。
```
apt-get install resolvconf 
```

3. 重启网络
```
service networking restart
```

## 关于dns
也可以直接修改resolv.conf配置dns。配置DNS服务器的地址，最多可以使用3个DNS服务器
```
vi /etc/resolv.conf
nameserver 223.5.5.5
nameserver 223.6.6.6
```