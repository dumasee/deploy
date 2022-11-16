##  debian安装 svn
```
apt-get install subversion
svnadmin create  web
```

权限具备继承性，子目录会自动拥有父目录的权限。  
```
* =`` 这一句的目的，就是割断权限继承性，使得管理员可以定制某个目录及其子目录的权限，从而完全避开其父目录权限设置的影响。
```

##  svn 备份/恢复 
- svn全量备份/恢复
```
svnadmin dump /var/opt/svn/repo > /var/opt/svn/repo.dump
```

恢复：
```
svnadmin create /var/opt/svn/repo
svnadmin load /var/opt/svn/repo < repo.dump
```

- 查询svn的uuid
```
svnlook uuid repo
```

- 更改svn的uuid，通常发生在本地库uuid与服务端不一致的时候。
```
svnadmin setuuid repo u-u-i-d
```
也可以直接备份/var/opt/svn目录，恢复时直接重装svn即可，不需要再重新配置！


##  svn 存储目录迁移 <实战> 6666
```
root@TEST:[/root]ps aux | grep svn
root      4874  0.0  0.0 187204  1260 ?        Ss   Jan28   0:00 svnserve -d -r /usr/local/svn/svnrepos --listen-port 9999
root     18909  0.0  0.0 112716   984 pts/1    S+   19:35   0:00 grep --color=auto svn
root     29506  0.0  0.0 187204  1256 ?        Ss    2018   0:16 svnserve -d -r /home/svn/project --listen-port 6666
```

路径：svn://47.93.220.40:6666/svnrepos

1. 备份svn目录
```
rsync -av --progress --delete  /home/svn/project/ /mnt/svn/project/
```
2. 停掉svn进程，再次执行rsync确保完全同步。

3. 重新启动svn进程，指定新目录路径  
svnserve -d -r /mnt/svn/project --listen-port 6666


## 项目数量
目前有72个项目。

## svn命令
```
svn checkout  svn://47.93.220.40:9999/项目列表/四海一家 --username=yank
svn update
svn log|more
```