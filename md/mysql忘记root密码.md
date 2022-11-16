1. 停止进程
```
/etc/init.d/mysql stop
```

2. 启动safe进程
```
mysqld_safe --user=mysql --skip-grant-tables --skip-networking &
```

3. 登录并更改密码
```
# mysql -u root mysql
mysql> UPDATE user SET Password=PASSWORD('newpassword') where USER='root';
mysql> FLUSH PRIVILEGES;
mysql> quit
```

4. 重启进程
```
/etc/init.d/mysql restart
```

5. 登录
```
# mysql -u root -p
Enter password: <输入新设的密码newpassword>
mysql>
```