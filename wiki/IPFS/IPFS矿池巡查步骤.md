矿池巡查三个步骤：

1. 网页区块链浏览器检查该矿池的消息时间，最近时间是否有新的消息上发，消息包括PreCommit/ProveCommit/Windowpost；不通矿池的消息间隔不通，太原和沈阳矿池的消息间隔都比较短，小于10分钟，郑州矿池因为算力较低，当前间隔低于20分钟以内都算正常。如果消息间隔过大，则需要登录服务器检查进程状态
矿池的浏览器地址：
```
太原矿池：https:filfox.info/zh/address/f0136808
沈阳矿池：https:filfox.info/zh/address/f0121810
郑州矿池：https:filfox.info/zh/address/f0110808
自有矿池：https:filfox.info/zh/address/f092887
```
2. 登录服务器检查进程状态。需要检查的进程包括：lotus daemon/ lotus-miner run 在miner主机（郑州的环境这两个也分开了），lotus-worker在worker主机，一般一个算力主机上有14个PC1的进程，4个PC2的进程（郑州有6个），2个C1进程。一个超算上有1个C2进程（郑州有2个C2进程）。正常除了要看进程是否存在，还要检查进程的日志是否有异常退出情况，或者不停的在重启的情况，方便的查看方法可以在日志目录执行tail *.log，查看所有日志文件的最后日志输出。
3. 矿池算力是否正常，矿池算力一般跑满算是正常，需要确认的是：1，算力机的P1进程是否在10个以上，2，sectormap（lotus-miner sealing sectors list命令输出）每个主机在26个扇区满园满员情况，3，没有进程的任务超时太多，比如P1执行超过4个半小时（太原机器太慢，P1经常执行到4个小时多），P2执行超过1个半小时，C1执行超过1分钟，C2执行超过15分钟，这些任务的执行时间可以通过（lotus-miner sealing jobs）命令来查看（主机上一般都有一个jobs.sh的脚本来执行该命令），改命令执行的结果如下。如果任务不满，则有可能是有老的扇区未删除，处理方式是查看扇区状态，根据状态确认怎么处理。任务超时，则可能是进程异常退出了，或者进程本身有问题需要重启了。
```
eb@miner:$ ./jobs.sh
ID        Sector  Worker    Hostname                               Task  State    Time
5323e655  15030   ca13b11c  worker1-192.168.22.21:19216:PC1-nvme2  PC1   running  3h24m17.9s
9bd080ce  15024   3de6a9df  worker2-192.168.22.22:19214:PC1-nvme2  PC1   running  3h18m49.8s
d16291d7  15034   f55361ba  worker3-192.168.22.23:19214:PC1-nvme2  PC1   running  3h15m50.7s
c2a94dd1  15032   d1cd32d9  worker2-192.168.22.22:19206:PC1-nvme1  PC1   running  3h0m43.7s
fce33cde  15025   be6efd97  worker2-192.168.22.22:19212:PC1-nvme2  PC1   running  2h59m37.3s
fd42f864  15036   34c5ba5c  worker1-192.168.22.21:19205:PC1-nvme1  PC1   running  2h57m27.5s
5a1d8433  15037   e4f31963  worker1-192.168.22.21:19203:PC1-nvme1  PC1   running  2h55m37.1s
dc4683ac  15033   d608b4d6  worker2-192.168.22.22:19216:PC1-nvme2  PC1   running  2h53m39.6s
0571c99f  15035   3ce45ca8  worker2-192.168.22.22:19211:PC1-nvme2  PC1   running  2h53m6.2s
5bd6b1f3  15038   4d65fa86  worker1-192.168.22.21:19214:PC1-nvme2  PC1   running  2h52m31.8s
8b089012  15039   38658259  worker2-192.168.22.22:19200:PC1-nvme1  PC1   running  2h34m59.4s
ef73d6db  15041   719f4f49  worker3-192.168.22.23:19206:PC1-nvme1  PC1   running  2h29m21.9s
897ac56b  15042   5b4b57f6  worker1-192.168.22.21:19212:PC1-nvme2  PC1   running  2h27m37.6s
c3a38ced  15043   0977e006  worker1-192.168.22.21:19200:PC1-nvme1  PC1   running  2h12m36.8s
0c323ec7  15044   4ad7f838  worker3-192.168.22.23:19203:PC1-nvme1  PC1   running  2h11m19.1s
fdd2ac6c  15045   711f07f6  worker3-192.168.22.23:19213:PC1-nvme2  PC1   running  2h11m19.1s
a5e20054  15046   7149fabf  worker2-192.168.22.22:19210:PC1-nvme2  PC1   running  2h3m34.5s
c2ea706d  15047   075257ee  worker3-192.168.22.23:19205:PC1-nvme1  PC1   running  1h58m50.8s
6948de03  15049   3c4e8d8b  worker3-192.168.22.23:19211:PC1-nvme2  PC1   running  1h46m35.7s
36274723  15040   979ce973  worker2-192.168.22.22:19201:PC1-nvme1  PC1   running  1h35m40s
e40e5781  15048   fd1795c4  worker2-192.168.22.22:19205:PC1-nvme1  PC1   running  1h34m22.6s
a82c28ab  15050   382460ef  worker3-192.168.22.23:19200:PC1-nvme1  PC1   running  1h29m3.1s
a206913a  15051   ba1cc258  worker1-192.168.22.21:19211:PC1-nvme2  PC1   running  1h28m32.8s
868b3765  15055   21349202  worker1-192.168.22.21:19210:PC1-nvme2  PC1   running  1h25m22.9s
b830ec83  15054   eb9cc1c3  worker1-192.168.22.21:19204:PC1-nvme1  PC1   running  1h25m21.5s
90115952  15056   90fce3d6  worker1-192.168.22.21:19206:PC1-nvme1  PC1   running  1h17m14.2s
9e4f84f5  15057   b8166286  worker3-192.168.22.23:19216:PC1-nvme2  PC1   running  1h13m36s
8c840619  15011   8cfaccf2  worker2-192.168.22.22:19217:PC2-nvme2  PC2   running  55m14.3s
e966cd94  15053   bf336edf  worker2-192.168.22.22:19213:PC1-nvme2  PC1   running  55m14.2s
264fe889  15060   d058aafc  worker1-192.168.22.21:19201:PC1-nvme1  PC1   running  53m32s
a0cd15f3  15052   d35745ed  worker2-192.168.22.22:19204:PC1-nvme1  PC1   running  45m5.4s
33293ecf  15013   1233fe83  worker2-192.168.22.22:19208:PC2-nvme1  PC2   running  45m5.2s
dafeb122  15022   00f8ec16  worker2-192.168.22.22:19207:PC2-nvme1  PC2   running  44m32.2s
f2b8b050  15059   030fab67  worker2-192.168.22.22:19203:PC1-nvme1  PC1   running  44m32.2s
77ebf120  15017   410f1074  worker1-192.168.22.21:19247:PC2-nvme2  PC2   running  41m52.9s
cce87374  15058   2b38d262  worker1-192.168.22.21:19215:PC1-nvme2  PC1   running  41m52.9s
02de3f88  15063   45e80af1  worker3-192.168.22.23:19215:PC1-nvme2  PC1   running  32m35.1s
c7788419  15028   3ad3c87b  worker3-192.168.22.23:19208:PC2-nvme1  PC2   running  29m21.6s
b638aae3  15026   07a12433  worker1-192.168.22.21:19218:PC2-nvme2  PC2   running  26m52.8s
23bb6428  15062   a0665e98  worker1-192.168.22.21:19213:PC1-nvme2  PC1   running  26m52.8s
0bd34694  15029   c8029664  worker3-192.168.22.23:19207:PC2-nvme1  PC2   running  23m18.5s
f0da1941  15020   16c2cf37  worker2-192.168.22.22:19218:PC2-nvme2  PC2   running  17m34.6s
9a9877de  15061   f5862a1b  worker2-192.168.22.22:19215:PC1-nvme2  PC1   running  17m34.5s
d848c6bc  15006   b7d5d033  super3-192.168.22.13:9239:C2           C2    running  6m20.7s
e9d13679  15000   7fb68fd1  super2-192.168.22.12:9239:C2           C2    running  6m20.7s
c4684041  15027   76927b08  worker2-192.168.22.22:19237:PC2-nvme1  PC2   running  6m2.4s
05649a7c  15064   0d5061e0  worker2-192.168.22.22:19202:PC1-nvme1  PC1   running  6m2.4s
9a16c6d9  15031   deeb00d3  worker3-192.168.22.23:19218:PC2-nvme2  PC2   running  5m12.4s
f286ed6b  15005   fd481fe1  super1-192.168.22.11:9239:C2           C2    running  4m44.9s
66514a0e  15067   2f44a8d1  worker1-192.168.22.21:19202:PC1-nvme1  PC1   running  1m34.1s
030f27d7  15069   170b83a5  worker2-192.168.22.22:18200:AP-nvme1   AP    running  1m16.6s
82e4ac90  15068   1c8322a5  worker3-192.168.22.23:19204:PC1-nvme1  PC1   running  36.1s

hostname  AP  PC1  PC2  C1  C2  FIN  GET  UNS  RD
worker2   1   14   5    0   0   0    0    0    0
worker3   0   10   3    0   0   0    0    0    0
super3    0   0    0    0   1   0    0    0    0
super2    0   0    0    0   1   0    0    0    0
super1    0   0    0    0   1   0    0    0    0
worker1   0   14   2    0   0   0    0    0    0
Mon Mar 15 09:23:17 CST 2021 PC1/PC2/C1/C2
```
4. 是否有扇区超时，检查sectormap（lotus-miner sealing sectors list命令输出）里的扇区是否保持连续，有跟当前扇区id差较大的扇区，需要查看扇区状态，确认是否有异常，根据异常情况进行处理，比如当前正在处理的最大扇区id是15069，sectormap里还有200号以外的扇区13033编号，就需要检查该扇区状态，根据状态进行处理
5. 是否有遗留扇区文件，有些扇区因为操作原因，造成sectormap里已经没有了，但是扇区数据可能并没有清除掉，则需要在每一台worker算力机上进行查找判断，命令为：./findsector "s-t*"，展示的所有扇区文件里，文件时间超过1天的，则需要查看该扇区状态，确认处理操作