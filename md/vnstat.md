## 报错1：Database load failed even when using backup
http://www.torrycrass.com/2011/06/19/vnstat-database-load-failed-even-when-using-backup/
处理方法
```
rm /var/lib/vnstat/bond0 
vnstat -u -i bond0
vnstat -u
vnstat -d
```

## 报错2：Interface "bond0" not found in database.
处理方法
```
vnstat --add -i bond0
/etc/init.d/vnstat restart
```


## 显示 网卡实时流量
```
vnstat -l -i bond0
```