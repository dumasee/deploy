HOL部署一个合约我们有以下几步:

1. 编译合约，安装HOL的智能合约编写，语法使用的是Solidity语法
2. 安装solc编译器:npm install solc
3. 编译合约：solc  -o . -bin -abi -hashes 合约文件名
4. 就会在当前目录下生成三种文件
5. 打开bin文件，复制bytecode二进制数据
6. 进入fen的节点，使用fen-cli进行创建合约，示例：`./fen-cli.sh ./qtum-cli createcontract bytecode+合约参数 +gas值`
7. 创建完成就会返回：
```
  {
  "txid": "交易ID",
  "sender": "创建者地址",
  "hash160": "hash值",
  "address": "合约地址"
  }
  ```
8. 判断是否创建成功
  ./fen-cli.sh getaccountinfo  合约地址
  返回数据是这样的就是成功了：
  ```
  {
    "address": "5bde092dbecb84ea1a229b4c5b25dfc9cdc674d9",
    "balance": 0,
    "storage": {
      "290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e563": {
        "0000000000000000000000000000000000000000000000000000000000000000": "0000000000000000000000000000000000000000000000000000000000000001"
      }
    },
    "code": "..."
  }
  ```
9. 调用方法见sign文件