## samba 
1. 安装samba
```
apt-get install samba
```

2. 编辑配置文件
vi /etc/samba/smb.conf
```
[shared]
   comment = Share for work
   path = /home/smbdir
#   guest ok = yes
   public = yes
   browseable = yes
   valid users = smbuser1

   read only = yes
   create mask = 0775
   directory mask = 0775
```

3. 创建smb共享目录
```
mkdir /home/smbdir
```

4. 新建smb用户帐号，设置密码
```
useradd -d /home/smbdir -s /bin/false smbuser1
smbpasswd -a smbuser1   (密码123456)
```
 
5. 重启进程
```
/etc/init.d/samba restart
```
说明：debian9下测试正常！
