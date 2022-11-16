1. 首先确保miner已经启动成功
2. 启动多个worker，不同的worker 设置worker-repo的路径一定要不同，listen的端口也要不一样
```
lotus-worker --worker-repo=/mnt/nfs3/lotus-worker-data/ run -listen=127.0.0.1:2346
lotus-worker --worker-repo=/mnt/nfs3/lotus-worker-data2/ run -listen=127.0.0.1:2347
```
3. 这样就可以启动多个worker开始封装