
##  改limit
/etc/security/limits.conf  
```
* soft nofile 65535
* hard nofile 65535
```

## 改limit（重启失效）
命令  
```
ulimit -n65535
```

查看  
```
ulimit -a |grep open
```

# 设置max_connections（重启失效）
命令  
```
set GLOBAL max_connections=10000;
```

查看  
```
show variables like "%connections%";
```

# 其它命令
```
show global variables like '%open_files_limit%';
show global status like '%connections%';
show status like 'Threads_connected';    #当前客户端已连接的数量
show processlist;   #以表格的形式显示已连接线程信息
show status like 'Threads_running';  #如果数据库超负荷了，你将会得到一个正在（查询的语句持续）增长的数值。
show status like 'Aborted_clients';    #客户端被异常中断的数值
```

