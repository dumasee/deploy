## 调用远程C2
- 防火墙/网络
本地miner机对应防火墙开放端口(2345)给远程C2(119.45.11.88)
```
acl advanced 3000
 rule 12 permit tcp source 192.168.21.31 0 destination 119.45.11.88 0 source-port eq 2345
```
```
interface GigabitEthernet1/0/0
nat server protocol tcp global 183.129.178.200 2345 inside 192.168.26.83 2345

acl advanced 3000
 rule 12 permit tcp source 192.168.26.83 0 destination 119.45.11.88 0 source-port eq 2345
```
远端C2机器对应防火墙开放端口(19253)给本地miner(183.129.161.7)

本地miner机配置
```
lxl@miner2131:~$ cat /etc/hosts
……
119.45.11.88 remoteSuper
```

远程C2
```
root@VM-0-5-ubuntu:~# cat /etc/hosts
10.206.0.5 remoteSuper
```

- 安装依赖
centos
```
yum install ocl-icd gcc git jq pkg-config curl clang hwloc hwloc-devel
yum provides libOpenCL*  #查询程序属于哪个包
```
ubuntu
```
apt install -y mesa-opencl-icd ocl-icd-opencl-dev gcc git bzr jq pkg-config curl clang build-essential hwloc libhwloc-dev wget
apt upgrade -y
```

- 部署lotus-worker
运行(找本地super机copy程序目录)，做软链接
```
cp lotus-worker-intel-1.11.1 /usr/local/bin/
lrwxrwxrwx 1 root root   25 Oct 27 19:27 lotus-worker -> lotus-worker-intel-1.11.1
[eb@VM-0-8-centos script]$ cat runworkerC2.sh |more
……
hostname="remoteSuper"
for port_two in {19253..19253}
                nohup lotus-worker --worker-repo=$lotusworkerpath1/$port_two/ run --workername=$hostname:$port_two:C2 --ability=AP:0,P
C1:0,PC2:0,C1:0,C2:1,FIN:0,GET:0,UNS:0,RD:0 --commit2=true --listen=$hostname:$port_two >> $lotushome/log/$port_two.log 2>&1 &
……
```

- 拷贝miner的lotus文件并复制到bin目录下
```
cp lotus-1.13.0-new /usr/local/bin/
cp lotus-worker-intel-1.11.1 /usr/local/bin/
cd /usr/local/bin/
ln -s lotus-1.13.0-new lotus
ln -s lotus-worker-intel-1.11.1 lotus-worker
```

- 配置环境变量
下载参数文件并解压，大约102G
```
rsync -av --progress --delete -e 'ssh -p 2231'  jumper@183.129.161.7:/data1ssd/filecoin-proof-parameters/ /mnt/data1/filecoin-proof-parameters/
lotus  fetch-params 32GiB  #直接从网络下载，如果网速可以！
```

添加环境变量
```
vi /etc/profile
export FIL_PROOFS_PARAMETER_CACHE=/mnt/data1/filecoin-proof-parameters
```


## super机器问题处理
### 报错日志



- 问题2
```
[eb@VM-0-8-centos ~/lotus-amd-eb/script]$ tail -f ../log/19253.log 
lotus-worker: /lib64/libm.so.6: version `GLIBC_2.27' not found (required by lotus-worker)
lotus-worker: /lib64/libc.so.6: version `GLIBC_2.18' not found (required by lotus-worker)
```

wget http://ftp.gnu.org/gnu/glibc/glibc-2.27.tar.gz



## Tesla T4安装驱动
- 查看显卡
```
root@VM-0-5-ubuntu:~# lspci |grep -i nvidia
0b:01.0 3D controller: NVIDIA Corporation TU104GL [Tesla T4] (rev a1)
0b:02.0 3D controller: NVIDIA Corporation TU104GL [Tesla T4] (rev a1)
41:01.0 3D controller: NVIDIA Corporation TU104GL [Tesla T4] (rev a1)
41:02.0 3D controller: NVIDIA Corporation TU104GL [Tesla T4] (rev a1)
```
- 安装依赖  
centos:
```
yum -y install gcc kernel-devel kernel-headers
yum update
```
ubuntu:
```
apt-get install -y gcc build-essential
```

- 禁用nuoveau
```
blist=/etc/modprobe.d/blacklist.conf
echo blacklist nouveau >> $blist
echo options nouveau modeset=0 >> $blist

更新initramfs
update-initramfs -u

重启系统
reboot

查询结果
lsmod | grep nouveau
```
- 下载&安装gpu
```
wget -c https://us.download.nvidia.com/tesla/470.57.02/NVIDIA-Linux-x86_64-470.57.02.run
bash NVIDIA-Linux-x86_64-470.57.02.run --silent
```
- 运行
runworkerC2.sh添加环境变量：
```
export BELLMAN_SUPPORT_GPUS="Tesla T4:2560"
```