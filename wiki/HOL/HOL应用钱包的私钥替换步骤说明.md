1. 先进入/fenCore2目录下，关闭节点 ./fen-cli.sh stop
2. 进入/.fen目录
3. 删除wallet文件 walley.dat
4. 进入/fenCore2
5. 重新启动节点 ./fend.sh -daemon
6. ./fen-cli.sh help可以看到比特币节点上所有的RPC接口
7. ./fen-cli.sh getnewaddress这个是获取新的地址的接口
8. 导出原来钱包地址私钥的接口./fen-cli.sh dumpprivkey + Hol地址（必须项。Hol的地址），用作备份钱包地址
9. 如果你需要导入自己的钱包私钥，可以调用rpc接口导入私钥  ./fen-cli.sh importprivkey "privkey" ( "label" ) ( rescan )   
  例如：root@btc:/fenCore2# ./fen-cli.sh importprivkey Hol地址  "" false
  注意： 如果已经有Hol私钥可以直接调用该功能进行导入，不用进行7,8两步的操作
10. 这样私钥就更换完毕了