# rsync 命令
## 同步目录内容，保留所有文件属性
rsync -av --progress src/ dst/  
rsync -av --progress --delete src/ dst/   #删除dst存在但src上没有的文件  
rsync -av --progress src/xxx root@x.x.x.x:/root/    #传文件

## 非交互式rsync，免输密码
sshpass -p XXXXXX rsync -av --progress -e 'ssh -p 10022' jumper@112.17.170.150:/home/jumper/TFT_admin.zip ./
rsync -av --progress -e 'ssh -p 10022'  jumper@223.15.237.2:/home/jumper/ipfs/minimal_finality_stateroots_latest-20210831.car ./

## 同步archive
rsync -rltD --progress --delete -e 'ssh -p 22' /drives/d/archive/linux/  root@192.168.11.6:/opt/www/linux/
chmod -R 755 /opt/www/

rsync -av --progress --delete -e 'ssh -p 10022'  jumper@111.0.121.226:/opt/www/linux/ /opt/deploy/linux/

## lotus节点拷贝数据
rsync -av --progress --delete  root@192.168.26.31:/mnt/nvme1/filecoin-proof-parameters/  /mnt/nvme1/filecoin-proof-parameters/

# scp命令
SCP 协议已经过时，不灵活且不易修复，OpenSSH 官方建议使用更现代的协议进行文件传输，如 sftp 和 rsync。  
说明：scp适合小文件及少量文件复制，其它情况推荐使用rsync
## scp文件
scp -rp root@192.168.11.5:/root/docker_jumpserver-jms_all.tar ./   

## scp文件&目录  
scp -rp dir1/* root@127.0.0.1:/root/dir3/dir1/

## scp目录，目标dir3下有无目录dir1均无影响
scp -rp dir1 root@127.0.0.1:/root/dir3/dir1  
scp -rp dir1/ root@127.0.0.1:/root/dir3/dir1  
scp -rp dir1/ root@127.0.0.1:/root/dir3/dir1/  
以上命令效果相同！



# cp 命令 
## cp文件&目录
cp -rp /home/dir1/* /mnt/dir1/  
/bin/cp -rpf /home/dir1/* /mnt/dir1/   #目标文件同名，强制覆盖不提示
