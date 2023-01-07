## vsftpd 安装 
#安装vsftpd
```
apt-get install vsftpd
```

## vsftpd 更改配置文件 
#更改配置文件
vi /etc/vsftpd.conf
```
listen=NO
ssl_enable=YES      #若ftp客户端不支持ssl，可以关闭
anonymous_enable=NO
local_enable=YES
write_enable=YES
chroot_local_user=YES   #用户不能切换目录
pam_service_name=ftp    
utf8_filesystem=YES
```

## vsftpd 配置目录及权限 
#创建ftp根目录并更改目录权限
mkdir /home/ftpdir
chmod 555 /home/ftpdir

## 创建子目录用于文件上传，并设置权限
mkdir /home/ftpdir/test1
chmod 777 test1

## vsftpd 添加用户 
#创建ftp用户并指定主目录，（若该目录不存在，可以加参数-m）
useradd -d /home/ftpdir -s /bin/false user1

#设置用户密码
passwd user1

#查看用户主目录及shell，如有必要可以更改
cat /etc/passwd | grep user1
user1:x:1002:1002::/home/ftpdir:/bin/false


## vsftpd 重启进程 
#重启
service vsftp restart

#查看进程
ps aux | grep vsftpd
root      1481  3.0  0.9  28556  4664 ?        Ss   14:41   0:00 /usr/sbin/vsftpd /etc/vsftpd.conf
root      1483  0.0  0.1  12784   972 pts/0    S+   14:41   0:00 grep vsftpd


说明：debian9下测试正常！
