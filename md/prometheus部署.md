## 链接
```
http://111.0.121.226:13080/linux/prometheus/node_exporter-1.4.0.linux-amd64.tar.gz
http://111.0.121.226:13080/linux/prometheus/mysqld_exporter-0.14.0.linux-amd64.tar.gz
http://111.0.121.226:13080/linux/prometheus/prometheus-2.25.0.linux-amd64.tar.gz
http://111.0.121.226:13080/linux/prometheus/alertmanager-0.21.0.linux-amd64.tar.gz
http://111.0.121.226:13080/linux/prometheus/grafana-8.3.7.linux-amd64.tar.gz
https://github.com/prometheus/node_exporter/releases/download/v1.4.0/node_exporter-1.4.0.linux-amd64.tar.gz
https://dl.grafana.com/oss/release/grafana-8.3.7.linux-amd64.tar.gz
```

## node_exporter
```
nohup ./node_exporter &
```

## prometheus
1. 配置文件  
vi /opt/prometheus-2.23.0.linux-amd64/prometheus.yml

2. 启动prometheus  
```
cd /opt/prometheus-2.23.0.linux-amd64/
nohup ./prometheus &  
```
`端口号：9090`

## alertmanager
1. 默认监听端口号  
`9093 9094` 

2. 规则文件   
vim /opt/prometheus-2.23.0.linux-amd64/rules.yml  

3. 配置  
vi /opt/alertmanager-0.21.0.linux-amd64/alertmanager.yml  

## grafana
1. 启动  
cd /opt/grafana-8.3.7/bin && nohup ./grafana-server &   

2. 访问   
http://183.129.161.7:3000   
默认登录用户名/密码为：admin/admin ,首次登录会提示修改密码。  

3. 密码重置  
grafana-cli admin reset-admin-password xxxxxx    

4. dash 
登录grafana网站找到需要的dashboard，  
https://grafana.com/grafana/dashboards  

登录grafana管理页面  
导入Prometheus仪表版，Dashboards–Manage–import  
在 Granfana.com-Dashboard中填写 11074，点击load即可。
```  
Node Exporter for Prometheus Dashboard EN 20201010: 11074
Mysql overview: 7362
```

## mysqld_exporter
1. 创建监控帐号  
```
grant select,replication client, process on *.* to 'mysql_monitor'@'localhost' identified by 'abcde234';
flush privileges;
```

2. 编辑配置  
vim /root/.my.cnf
```
[client]
user=mysql_monitor
password=abcde234
```

3. 启动  
```
nohup ./mysqld_exporter &
```
`端口号：9104`