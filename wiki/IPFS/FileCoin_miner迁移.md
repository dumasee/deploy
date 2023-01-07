1. 备份miner的owner地址和worker地址的私钥：lotus wallet export 地址 >地址.key
2. 拷贝到目标主机上，使用导入私钥命令导入：lotus  wallet import 地址.key
3. 拷贝miner的数据目录.lotusminer到目标主机上
4. 在目标主机上设置LOTUS_MINER_PATH(miner 存储数据的目录.lotusminer)
5. 修改.lotusminer数据目录下的storage.json的StoragePaths，改成.lotusminer的路径
6. 启动miner，lotus-miner run 即可