一、修改总发行量 <br>

修改amount.h 的 MAX_MONEY 修改成你想要发行的最大数量
 2. 修改validation.cpp 的if(pindex->nMoneySupply > (uint64_t)(总发行量 + ((pindex->nHeight - 5000) * 指定的区块之后每次的奖励)) * COIN) <br>
二、修改前N个块每个块奖励多少<br>

修改validation.cpp的GetBlockSubsidy 的 m * COIN (m 就是 前N个块需要奖励的数量，也就是你期望前N个块出多少币就是在这里修改)<br>
三、修改P2P端口以及RPC端口<br>

修改chainparamsbase.cpp 的 nRPCPort就是rpc端口
 2. 修改chainparams.cpp的nDefaultPort就是P2P端口<br>
四、创世块的hash值的修改<br>

位置在chainparams.cpp
 assert(consensus.hashGenesisBlock == uint256S("需要改成新链的hash"));
 assert(genesis.hashMerkleRoot == uint256S("需要改成新链的Merkle树的根哈希值"));<br>
五、修改最新节点的默认地址<br>

位置在chainparams.cpp
 vSeeds.emplace_back("新的节点地址", false); mainnet  <br>
六、修改新链的地址头前缀<br>

位置在chainparams.cpp
 base58Prefixes[PUBKEY_ADDRESS] = std::vector<unsigned char>((1,41);(41是base58的值，为H)  <br>
七、是否挖矿<br>

位置在chainparams.h
 #define ALLOWSTAKE 0 改成 1 (1是挖矿，启动时需要加-staking=1，0是不挖矿)  <br>
八、logo的修改<br>

位置在src\qt\res\icons下
 把新的图标在文件夹中找到合适的替换即可  <br>
九、如何挖5000个块或者前N个块<br>
调用客户端的generate blocks，手动生成区块，500个块之后会挖矿，generate不能太频繁，需要间隔一段时间出一下 <br>

十、如何把各个挖矿节点的资产转移到一个地址<br>
调用客户端的sendtoaddress,大额转账需要等出块后再转第二次，可以多个节点同时出块，同时转账，切记不能把节点的钱一下子都转走，会导致难度降低，挖不出块来，可以写个脚本，每20分钟转一笔，这样应该会转的没问题，但是时间会长一点。