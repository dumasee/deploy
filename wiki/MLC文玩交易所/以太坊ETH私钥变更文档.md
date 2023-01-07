以太坊ETH私钥变更文档

一、以太坊删除节点服务器上的私钥文件：

1、进入以太坊数据存储目录下的keystore目录,
```
cd go-ethereum/chain/keystore
```
2、删除对应地址的文件:
```
# ll
total 12
drwx------ 2 root root 261 Sep 4 18:34 ./
drwx------ 4 root root 67 Sep 4 15:17 ../
-rw------- 1 root root 491 Aug 29 14:56 UTC--2019-08-29T06-55-59.737039579Z--5ab084990c58c41b0fc519aaba04a64dc182d5e1
-rw------- 1 root root 491 Aug 30 11:08 UTC--2019-08-30T03-08-49.751518315Z--d4c9d092db8d4fb47d286ec83e1b214af5aa86b3
-rw------- 1 root root 491 Sep 4 18:34 UTC--2019-09-04T10-34-00.066173137Z--8e9643dbeca9d461168133c0cda1a25bbdaffb97

rm UTC--2019-09-04T10-34-00.066173137Z--8e9643dbeca9d461168133c0cda1a25bbdaffb97
```
二、 通过私钥、密码导入自己的以太坊账号:

1、通过RPC连接上以太坊节点
```
# geth attach ipc:geth.ipc
```
2、调用RPC函数personal.importRawKey
```
> personal.importRawKey("8a2bb4b99375048c61e78d43fadcd2a3f07d74ff690ceaebd9yourprivatekey","password")

"0x8c574a86a3e080fcd28cdc6da4a7680eba86277b"
```
3、成功后从keystore目录下可以看到对应地址的文件了。
```
~/go-ethereum/chain/keystore# ll
total 12
drwx------ 2 root root 261 Sep 23 13:56 ./
drwx------ 4 root root 67 Sep 4 15:17 ../
-rw------- 1 root root 491 Aug 29 14:56 UTC--2019-08-29T06-55-59.737039579Z--5ab084990c58c41b0fc519aaba04a64dc182d5e1
-rw------- 1 root root 491 Aug 30 11:08 UTC--2019-08-30T03-08-49.751518315Z--d4c9d092db8d4fb47d286ec83e1b214af5aa86b3
-rw------- 1 root root 491 Sep 23 13:55 UTC--2019-09-23T05-54-51.678189195Z--8c574a86a3e080fcd28cdc6da4a7680eba86277b
```
因为python钱包里eth需要配置地址和私钥用于提现，所以eth这里需要在其他工具里创建私钥和地址后导入，如果直接在节点上创建地址，很难找到对应的私钥（方法繁琐）。
私钥和地址导入成功后，需要修改python钱包里对应的walletserver/coin_config.py/coin_config_debug.py文件里的eth的私钥和地址的配置，另外需要修改walletserver/exjrpc/adaptor.py中创建eth rpc客户端时的密码。