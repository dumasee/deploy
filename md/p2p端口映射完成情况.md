- p2p端口映射完成情况：  
说明  miner上执行：lotus net listen ，映射miner，如果有单独daemon则映射 daemon

id         节点     p2p端口  端口映射   改配置
—————————————————————————————————————————
f01040516  ipfs成都   49939  √   √
f0136808   ipfs太原   33687  √   √
f092887    ipfs1      40903  √
f0500685   ipfs1.miner2  40657   √      郁康
f0121810   ipfs2 北京1   38681   √
f0705136   ipfs3 云联储  40903  √
f0704940   ipfs4.miner1  40903  √   王磊
f0704966   ipfs4.miner2  40903  √  王磊
f0811662   ipfs6 刘伟夫  38537  √
f01043666  ipfs7 陈向荣  46869  √
f0110808   ipfs郑州      43581  √   / daemon /
f0728817   ipfs鞍山.miner1  46309  √
f01074227  ipfs鞍山.miner2  37239  √

nat server protocol tcp global 183.129.178.200 38537 inside 192.168.26.31 38537

nat server protocol tcp global 115.236.20.82 46869 inside 192.168.27.31 46869

nat server protocol tcp global 183.129.161.10 40903 inside 192.168.24.31 40903

nat server protocol tcp global 183.129.207.53 40903 inside 192.168.24.32 40903

nat server protocol tcp global 183.129.161.8 40903 inside 192.168.23.31 40903

nat server protocol tcp global 115.236.19.69 38681 inside 192.168.22.31 38681

nat server protocol tcp global 183.129.161.7 40903 inside 192.168.21.31 40903

nat server protocol tcp global 183.129.161.12 40657 inside 192.168.21.32 40657

nat server protocol tcp global 101.206.243.19 49939 inside 10.80.1.31 49939

nat server protocol tcp global 223.15.237.2 33687 inside 192.168.3.31 33687



- 改配置
vi $LOTUS_PATH/config.toml

#ipfs太原
[Libp2p]
  ListenAddresses = ["/ip4/0.0.0.0/tcp/33687", "/ip6/::/tcp/33687"]
  AnnounceAddresses = ["/ip4/223.15.237.2/tcp/33687", "/ip4/127.0.0.1/tcp/33687"]
  
  
#ipfs成都
[Libp2p]
  ListenAddresses = ["/ip4/0.0.0.0/tcp/49939", "/ip6/::/tcp/49939"]
  AnnounceAddresses = ["/ip4/101.206.243.19/tcp/49939", "/ip4/127.0.0.1/tcp/49939"]
  

#ipfs1
[Libp2p]
  ListenAddresses = ["/ip4/0.0.0.0/tcp/40903", "/ip6/::/tcp/40903"]
  AnnounceAddresses = ["/ip4/183.129.161.7/tcp/40903", "/ip4/127.0.0.1/tcp/40903"]

- 检查
lotus net reachability