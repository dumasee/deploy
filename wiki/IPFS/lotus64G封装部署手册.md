1. 下载proof证明参数
```
lotus-miner fetch-params 64GiB
```

2. 创建64G miner矿工
```
./lotus-miner -miner-repo=64GiB_Miner路径 init -owner=ownerAddress -worker=workerAddress -sector-size=64GiB
```

3. 启动miner
```
./lotus-miner -miner-repo=64GiB_Miner路径 run
```

4. worker的的部署步骤和32G的一样