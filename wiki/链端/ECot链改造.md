改造内容：
1. 增加RPC函数 fabricrequest,  用于向fabric 节点调用链码功能。它使用http协议向对应http服务器发送请求，服务器向fabric节点做对应请求并将结果返回给cot的rpc客户端。需要在配置文件cot.conf里配置http服务器地址fabrequesthost.
2. 一键登录rpc onelogin, 需要提供配置参数oneloginhost和oneloginport。以http协议向一键登录服务器请求。
3. 出块方式修改为轮流出块。系统启动时读取配置文件中的addnode列表，把列表中的ip地址按从小到大排序，然后组成一个串计算hash值。与其它节点发送版本号时把这个hash值带上。当收到其它节点的hash值时判断是否与本机一致。若不一致则报错退出程序。当收到所有配置节点的正确哈希值时开始出块。按IP地址从小到大开始出块，IP最小的节点出第一个块。
4. 修改区块结构增加出块节点和出块时间。修改交易结构去掉金额。去掉交易中币的概念。因为没有了币，交易的txin不能关联到上一笔txout，所以去掉了vin里的prevout.也没有了utxo的维护。
5. 交易签名修改：原先交易分为utxo的锁定脚本部分和vin中对utxo解锁的脚本。由于两者不关联，现在签名脚本只使用vin中对交易结构签名和content内容验证的脚本。具体脚本为 
   <sig> <pubk> <content> hash160 <contenthash> <checkequal> dup hash160 <pubkeyhash> checkequal checksig.