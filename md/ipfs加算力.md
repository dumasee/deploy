
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [worker机操作](#worker机操作)
- [super机操作](#super机操作)
- [miner](#miner)

<!-- /code_chunk_output -->


## worker机操作
1. nfs挂载。
此操作可参照文档完成。

2. 切换脚本
su - eb
rm runworker.sh
重做软链接，指向需要需要加算力的miner机。

3. 重启进程
killall lotus-worker
crontab里将runworker.sh任务前的注释删除。


## super机操作
1. 切换脚本
rm runworkerC2.sh
重做软链接，指向需要需要加算力的miner机。

2. 重启进程
killall lotus-worker
crontab里将runworkerC2.sh任务前的注释删除。

## miner
1. 更改任务数参数
计算任务数：26*9=234 ，
其中9为9套封装机。然后更改脚本 autopledge.sh 参数。
```
su - eb
cd lotus-amd-eb/script
vi autopledge.sh
target=234  
```

2. 查看当前任务数
```
eb@miner2231:~/lotus-amd-eb/script$ ./sectormap.sh |wc -l
233
```