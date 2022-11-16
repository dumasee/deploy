<!--
2022-09-28
-->

## docker安装
```
docker pull mysql:5.7-debian

docker run -d -p 13306:3306 --name mysql57 \
  -v /opt/mysql/data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=xxxxx \
  -e TZ=Asia/Shanghai \
  mysql:5.7-debian \
  --character-set-server=utf8 \
  --collation-server=utf8_bin \
  --explicit-defaults-for-timestamp=1
```
  
## 命令行登录
```
docker exec -it mysql57 /bin/sh
mysql -u root -p
```

## 创建表
```
CREATE TABLE IF NOT EXISTS filaccount (
	account varchar (10) NOT NULL,
	name varchar (20) NOT NULL,
	owner varchar (100) NOT NULL,
	worker varchar (100) NOT NULL,
	PRIMARY KEY (account)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='filcoin客户帐号';
```



## 更改连接数
```
show variables like "%max_connections%";
```
Mysql5.5 mysql5.6  mysql5.7：默认的最大连接数都是151，上限为：100000

- 临时更改
```
set global max_connections = 1000;
```

- 更改配置文件
```
/etc/mysql/mysql.conf.d/mysqld.cnf
```

#mysql删除用户
```
mysql> drop user 'root'@'localhost';
mysql> flush privileges;      <---即刻生效。
mysql> select user,password,host from mysql.user;
```

#开放用户远程连接到数据库
```
mysql> grant all privileges on *.* to root@'%' identified by 'xxxxx';
mysql> flush privileges;      <---即刻生效。
mysql> select user,host,password from mysql.user;     #mysql5.5

mysql> select user,host,authentication_string from mysql.user;     #mysql5.7
```

#清除防火墙规则(debian系默认全放开)
```
iptables -F
iptables -X
```

#centos7默认使用firewalld，删除之。
```
yum -y remove firewalld
yum -y install iptables
service iptables restart
service iptables save
```

###定时执行
#crontab -l
0 23 * * * /home/backup_mysql.sh

-------------------  mysql备份&恢复  -------------------
#备份全部数据库
```
mysqldump -u test123 -p'123(' --all-databases > mysql_20171022.sql
```

#从备份恢复所有数据库
```
mysql -u root -p < mysql_20171022.sql
```

#备份多个/单个数据库
```
mysqldump -u root -p --databases starfly  > Backup_1DB-starfly.sql
```

#从备份恢复单个数据库
首先用命令备份单个数据库。
```
CREATE DATABASE tang DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
mysql -h rm-uf66z96nucr1j0s20do.mysql.rds.aliyuncs.com -u tang_4268147 -p tang --one-database < Backup_1DB-starfly.sql

update users_user set password=password('admin') where username='admin';
```


##  mysql5.7 改密码
```
ALTER USER root IDENTIFIED BY '123456';
```

## 命令登录
```
mysql -h x.x.x.x -uroot -p 
```
