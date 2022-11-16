## 要点
- 脚本文件中记得使用绝对路径
- 修改时区后需要重启两个服务
```
service cron restart
service rsyslog restart
```
- crontab 每个用户对应一个文件，就是在 /var/spool/cron/crontabs/ 里面

- 系统级任务 直接编辑对应文件：/etc/crontab
