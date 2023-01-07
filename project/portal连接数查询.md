## 端口连接数
查询到本机端口的连接数：  
```
ss -nt|grep ESTAB |awk {'print $4}' |grep :8081 |wc
```
查询由本机发出到指定端口的连接数：  
```
ss -nt|grep ESTAB |awk {'print $5}' |egrep ':808[1-6]' |wc
```