- 递归查找
```
root@debian:~# grep -rEn cacti /etc/apache2/     
/etc/apache2/conf.d/cacti.conf:1:Alias /cacti /usr/share/cacti/site
/etc/apache2/conf.d/cacti.conf:3:<Directory /usr/share/cacti/site>
```



- 递归查找结果再grep
```
root@monitor2209:~/202112# grep -rEn server255 ./*.log | grep  hwinfo
./47.99.129.32-20211209-182132.log:824:root@server2553:~# bash deploy.sh hwinfo
./47.99.129.32-20211224-175853.log:2004:root@server2553:~# bash deploy.sh hwinfo
./47.99.129.32-20211224-175853.log:2029:rz waiting to receive.root@server2553:~# bash deploy.sh hwinfo
./47.99.129.32-20211224-175853.log:2063:root@server2553:~# bash deploy.sh hwinfo
./47.99.129.32-20211228-135018.log:1669:root@server2550:~# bash deploy.sh hwinfo
./47.99.129.32-20211228-135018.log:1736:root@server2550:~# bash deploy.sh hwinfo
```