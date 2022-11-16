
## 安装
- for ubuntu18.04
```
apt-get -y update
apt-get -y upgrade
apt-get install mysql-server
```

- for ubuntu20.04
```
mkdir -p mysql_install
cd mysql_install
wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-server_5.7.31-1ubuntu18.04_amd64.deb-bundle.tar
tar -xvf mysql-server_5.7.31-1ubuntu18.04_amd64.deb-bundle.tar
dpkg -i mysql-*.deb
#<出现第一个窗口，选8.0>
#<出现第二个窗口，选5.7>

apt --fix-broken install   #执行以修复安装，会提示输入mysql密码。
apt-get -y update
apt-get -y upgrade
```


## 配置
```
cfg=/etc/mysql/mysql.conf.d/mysqld.cnf
sed -i '/^bind-address/c\#bind-address = 127.0.0.1' $cfg

#不区分大小写
grep lower_case_table_names $cfg || sed -i '/^\[mysqld\]/a\lower_case_table_names = 1' $cfg

#默认字符集
grep character-set-server $cfg || sed -i '/^\[mysqld\]/a\character-set-server=utf8' $cfg
grep "^\[client\]" $cfg || echo "[client]" >> $cfg
grep "default-character-set" $cfg || sed -i '/^\[client\]/a\default-character-set=utf8' $cfg
```


## 运行脚本
```
mysql_secure_installation
```

## 允许远程
```
# grant all privileges on *.* to root@'%' identified by '8l4Q_0fK7wDS';  
# flush privileges;
```

## 重启进程
```
/etc/init.d/mysql restart
```