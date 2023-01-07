# gpu掉线处理步骤
## 超算&算力
1. crontab -e -ueb ，注释掉任务。
2. 算力机 需要kill掉lotus进程。
3. reboot
4. nvidia-smi检查gpu驱动，如没有驱动需要安装
```
bash NVIDIA-Linux-x86_64-460.67.run --silent
```
5. crontab -e -ueb 恢复注释掉的任务


## kill命令
- killall lotus-seal-worker-abm;killall lotus-file-server

## crontab任务
```
root@super1:~# crontab -l -ueb
#m h  dom mon dow   command
*/1 * * * *  /home/eb/check_health_C2_bak.sh
root@super1:~#

root@worker1:~# crontab -l -ueb
#m h  dom mon dow   command
*/1 * * * * /home/eb/check_health.sh
*/1 * * * * /home/eb/file_server_check.sh
root@worker1:~#

root@miner:~# crontab -l -ueb
#m h  dom mon dow   command
*/1 * * * * /bin/bash /home/eb/autopledge.sh >> autopledge.log
*/1 * * * * /home/eb/change_paid_new.sh >> /home/eb/changepaid.log

```


## 不重装驱动，只加载模块（不一定管用。）
apt install dkms
dkms install -m nvidia -v 460.56


故障现象：
```
root@super1:~# nvidia-smi
Killed

root@miner:~# ls /usr/src | grep nvidia
nvidia-455.45.01
nvidia-460.32.03
```