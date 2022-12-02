## 查看某个进程启动时间、运行时长
ps -A -opid,stime,etime,args |grep sshd |grep -v grep |grep -v root

## ls显示完整年月日
ls -lh --time-style=long-iso 

## 判断主机网络状态
```
ping -c1 -w1 -t5 192.168.11.6 >/dev/null 2>&1 && echo ok|| echo down
```

## ss 
```
ss -s 查看机器的网络连接数
ss -ntl  查看监听的tcp端口
ss -nt  查看已建立的tcp连接
ss -nt  src :22  #加过滤条件
ss -nt  dst 100.100.30.25
```

## 查看监听的tcp端口号（非本地监听），已去重！
```
ss -ntl|awk '{print $4}'|grep -E '\*:|0.0.0.0:|:::'|sed 's/\*://'|sed 's/0.0.0.0://'|sed 's/::://'|sort|uniq
```

## 检测主机 端口状态
nc -zv -w5 47.93.220.40 9999

## 查看磁盘信息
```
lsscsi
lsblk
lsblk -d -o name,rota   #ROTA是1的表示可以旋转，反之则不能旋转。
```

## 查询硬盘型号，根据型号确定是否sas或sata
cat /proc/scsi/scsi|grep Model


##  文件权限  
```
chown -R mysql:mysql /data/mysql    #设置文件属主、属组 
chmod -R 755 file/   #设置文件夹权限
```

##  添加/删除帐号
```
useradd -d /home/eb -s /bin/bash  -m eb  #新建帐号
gpasswd -a eb  root   #添加用户到某个组，并保留之前的属组信息
passwd -S root     #查看某个帐号的创建时间
userdel -r user1   #删除用户
```

##  清除痕迹历史记录 
```
echo > /var/log/wtmp
echo > /var/log/btmp
echo > ~/.bash_history 
history -c
```

## 关闭、禁用服务
```
systemctl list-unit-files --type=service | grep enabled

systemctl stop xxx.service
systemctl disable xxx.service

systemctl status xxx.service
```
## 监控流量
```
iftop -i eth0 -nNP  #实时查看端口流量速率
nethogs eth0 -d 5   #实时显示进程流量速率
iptraf     #实时统计网络端口收发包数量、大小。
```
## 其它
```
select-editor    #指定默认编辑器
last -i   #查看登录日志
df -hT   #查看各分区磁盘占用
vmstat 2 1   #查看内存、cpu负载
jps -l   #列出所有java进程
killall java   #kill掉所有java进程
pkill -kill -t <tty值>   #强制某登录用户退出
last -i   #查看登录日志
fdisk  #针对mbr分区
gdisk  #针对gpt分区
```