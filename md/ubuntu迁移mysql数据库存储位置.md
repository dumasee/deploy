## 准备工作
1. 磁盘扩容  
准备好扩容的磁盘，分区格式化并挂载到/data目录

2. mysql数据备份  
略。

## mysql数据库存储位置迁移
1. 查看存储位置
```
vi /etc/mysql/mysql.conf.d/mysqld.cnf
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
```

2. 关闭mysql
```
service mysql stop
```

3. 迁移数据
```
cp -dpR /var/lib/mysql/* /data/mysql/
```
注：安全起见先使用cp命令。cp带参数保留文件权限。

4. 修改配置文件
```
vi /etc/mysql/mysql.conf.d/mysqld.cnf
datair = /data/mysql

vim /etc/apparmor.d/usr.sbin.mysqld
将下面两行注释掉，
/var/lib/mysql/ r,
/var/lib/mysql/** rwk,

添加如下：
/data/mysql/ r,
/data/mysql/** rwk,
  
vim /etc/apparmor.d/abstractions/mysql，将其中的sock地址改为
/data/mysql/mysql.sock   rw
```

5. 更改目录权限（如有必要则进行操作。若文件权限、属组有问题则运行mysql会报错！）
```
chmod 755 /data/mysql
```

6. 重启数据库
```
/etc/init.d/apparmor restart
/etc/init.d/mysql start
```

