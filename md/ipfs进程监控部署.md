## 部署监控
### raid监控
- megacli  (for storage)
```
*/1 * * * * mkdir -p /tmp/textcollector && bash /opt/deploy/megacli.sh | sponge /tmp/textcollector/megacli.prom
```

### 进程监控，docker监控
- process monitor (for worker, super, miner etc..)
```
*/1 * * * * mkdir -p /tmp/textcollector && bash /opt/process_monitor.sh | sponge /tmp/textcollector/processmonitor.prom
```

- for promethues, alertmanager
```
*/1 * * * * ps aux|grep prometheus|grep -v grep || (cd /opt/prometheus-*/ && nohup ./prometheus &)
*/1 * * * * ps aux|grep alertmanager|grep -v grep || (cd /opt/alertmanager-*/ && nohup ./alertmanager &)
```
## 命令查询
- 查看进程 cpu 内存占用
```
#!/bin/bash
PID=$1
cpu=`ps --no-heading --pid=$PID -o pcpu`
mem=`ps --no-heading --pid=$PID -o pmem`
echo -n `date +'%Y-%m-%d %H:%M:%S'`
echo -e "\t$cpu\t$mem"
```
- 查看容器占用率
```
docker stats --no-stream
docker stats yapi --no-stream
```



