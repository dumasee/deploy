比特币和USDT私钥更换流程

## 比特币私钥导入流程
drwx

1. 进入bitcoin目录下的src
2. 关闭节点 ./bitcoin-cli stop
3. 进入~/.bitcoin目录 
4. 删除wallet文件 wallet.dat
5. 重新启动节点 ./bitcoind -daemon
6. ./bitcoin-cli help可以看到比特币节点上所有的RPC接口
7. ./bitcoin-cli getnewaddress这个是获取新的地址的接口
8. ./bitcoin-cli dumpprivkey + 比特币地址（必须项。比特币的私钥地址）这个是导出地址私钥的接口
9. 调用rpc接口导入私钥  `./bitcoin-cli importprivkey "privkey" ( "label" ) ( rescan )`
将私钥(dumpprivkey返回)添加到钱包中。需要一个新的钱包备份。
参数：
```
1. "privkey"：字符串，必须项。私钥（dumpprivkey的输出）
2. "label"：字符串，可选项，默认为空。可选标签。
3.  rescan：布尔值，可选项，默认为true。重新扫描钱包的交易。
```
例如：
root@btc:~/bitcoin/src# ./bitcoin-cli importprivkey L28YknuQ8TqGRevCewJCJHCCtMtfEjWgNVDuJSWssrXp57vPHLX7  "" false
注意： 如果已经有比特币私钥可以直接调用该功能进行导入，不用进行7,8两步的操作
10. 这样私钥就更换完毕了

## USDT私钥导入流程

1. 进入omnicore目录下的src
2. 关闭节点 ./omnicore-cli stop
3. 进入~/.bitcoin目录 
4. 删除wallet文件 wallet.dat
5. 重新启动节点 ./omnicored -daemon
6. ./omnicore-cli help 可以看到USDT节点上所有的RPC接口
7. ./omnicore-cli getnewaddress这个是获取新的地址的接口
8. ./omnicore-cli dumpprivkey  + 比特币地址（必须项。比特币的私钥地址） 这个是根据地址导出私钥的接口
9. ./omnicore-cli  importprivkey +私钥 就是调用rpc接口导入私钥（具体调用方法和上面一致）
注意： 如果已经有USDT私钥可以直接调用该功能进行导入，不用进行7,8两步的操作
10. 这样私钥就更换完毕了
USDT的私钥更新完毕后，需要给python钱包设置一个新的USDT的提币地址，修改`/root/python/walletserver/conf`目录下的coin_config_debug.py 里面改一下usdt的withdraw address配置参数USDT_ADDRESS，改为新的地址。