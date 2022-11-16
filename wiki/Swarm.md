swarm部署文档(先登陆xdai节点-112.13.70.198)(第5步成功后节点就可以成功运行了)
1. 脚本目录/root/work/mainnet/
2. 执行修改密码脚本 ./recchgpasswd-ub.sh host
3. 执行脚本推送 ./batchInstall.sh host
4. 执行获取地址 ./batchGetAddress.sh host
5. 转账xdai(创建节点合约)：目前是用java代码手动批量操作(因安全性考虑，不方便开发这个接口)，也可以用小狐狸
6. 转账XBZZ：java代码手动批量
7. 执行充值接口(这一步暂时不方便用脚本执行，后续可能还是用java批量去执行)