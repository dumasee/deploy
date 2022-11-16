

## ssh长连接  
OpenSSH基于安全的理由，如果用户连线到SSH Server后闲置一段时间，SSH Server会在超过特定时间后自动终止SSH连线。
可以在服务端或客户端进行修改。为安全起见，不推荐在服务器上修改。

- 服务端
vi /etc/ssh/sshd_config
TCPKeepAlive yes
ClientAliveCountMax 60

- 客户端
vi /etc/ssh/ssh_config  #或~/.ssh/config
TCPKeepAlive yes
ServerAliveInterval 60   #单位：秒


## 配置密码验证，禁止使用密钥登录  
允许root登录，启用密码验证，强制版本为SSH2，禁止密钥登录
vi /etc/ssh/sshd_config
```
UseDNS no
AddressFamily inet
SyslogFacility AUTHPRIV
PermitRootLogin yes     #允许root登录
PasswordAuthentication yes   #允许密码登录
Protocol 2    
PubkeyAuthentication no   #禁止密钥登录
```
说明：
SSH v2不再支持选项RSAAuthentication，如果强行配置则会有在日志里边有提示：
tail -20 /var/log/auth.log
reprocess config line 129: Deprecated option RSAAuthentication

##  ssh免密登录  
目的：client免密码ssh登录至server
说明：server不需要任何设置，开启ssh服务即可。

1. client：
ssh-keygen
ssh-copy-id  root@x.x.x.x

- 或指定文件名
ssh-keygen -f xxx
ssh-copy-id -i test1.pub root@x.x.x.x

- 或直接写入到目标节点的配置文件：
echo test1.pub >> .ssh/authorized_keys

- 指定密钥类型、文件名。
ssh-keygen -m PEM -t rsa -b 4096 -f xxx

2. 登录测试
```
ssh -i test1 root@x.x.x.x
```
3. 权限设置
若密钥是copy自另一台主机的备份，可能需单独设置权限。
权限设置不正确，会导致ssh免密登录失败。
```
chmod 600 id_rsa id_rsa.pub
```

## 问题汇总  
- 清空服务器在本地的ssh登录记录
ssh-keygen -R 192.168.12.5
&nbsp;

- ssh登录验证失败
查看sshd日志：/var/log/auth.log
&nbsp;

- ssh免密登录失败
查看日志 /var/log/auth.log
Jan  5 10:14:29 miner2_test sshd[55153]: Authentication refused: bad ownership or modes for directory /root
处理方法： chmod -R 700 /root/
&nbsp;

- SSH连接时出现Host key verification failed
vi /etc/ssh/ssh_config
```
StrictHostKeyChecking=no
```
## openssh启动失败处理 
openssh server进程启动失败
/usr/sbin/sshd -T   #运行，根据报错信息进行处理。