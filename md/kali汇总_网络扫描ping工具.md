## nmap
扫描（包括二层和三层和四层扫描技术）
说明：禁ping的主机用nmap可以检测到！
```
nmap -A -v 47.243.116.4   #显示端口、应用版本号等
nmap  -Pn 47.243.116.4   #主机禁止扫描，可加此参数
nmap 144.202.92.204  #进行端口扫描
nmap -sn 192.168.11.*   #不进行端口扫描，显示主机是否在线
nmap -iL pc.ip  #指定主机清单文件作为参数
```


## netdiscover
二层网段扫描，显示ip、MAC及Vender
```
netdiscover	-p  #被动扫描侦听
netdiscover -r 192.168.11.0/24
```

## fping
判断主机是否活动
```
fping 172.16.36.135  #ping单个ip
fping -g 192.168.11.1 192.168.11.10  #ping一个序列ip .1~.10
fping -g 192.168.101.0/24
```