#!/bin/bash
#
#     addGoodPeers.sh @ Version 0.9
#     date: 2022.07.21


PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
export PATH
source /etc/profile

#太原
lotus net connect /ip4/223.15.237.2/tcp/33687/p2p/12D3KooWR5JskJN67qVfYkJmUbJwvDC9tkEsiYK6jCXidSDyaHit
#成都
lotus net connect /ip4/101.206.243.29/tcp/49939/p2p/12D3KooWGEXPwxr8fJvWKVmn1w78uNnKFZuY1xHjZ1ojnbtb8P1Z
#鞍山1-5.31
lotus net connect /ip4/36.129.163.99/tcp/46309/p2p/12D3KooWPdBL8xmQkMYGzY2Qy3LCcT3SuGVPKMTtwzvgcjhsK2Ge
#鞍山2-5.32
lotus net connect /ip4/36.129.163.99/tcp/37239/p2p/12D3KooWSP2oTrvCWLwxead3foXKNexJdPyUqiCJrxULPz1vmsdR

#ipfs7-德清
lotus net connect /ip4/39.171.60.98/tcp/40905/p2p/12D3KooWG3EZbVNR6QTo2JEcuCDEzJkZSSqbehBYeP1cVXoV3bDS
#云联储
lotus net connect /ip4/39.171.60.98/tcp/40901/p2p/12D3KooWAqRBTuAY6VCGqYzMJA2KvwabNvh3jVbfC5U7Muo3MxRW
#qfil
lotus net connect /ip4/39.171.60.98/tcp/40657/p2p/12D3KooWHTHZhvDDN2M1aat2JejxhgUFePywCgHNvwHmLTqNpEhY
#郁康
lotus net connect /ip4/39.171.60.98/tcp/40906/p2p/12D3KooWQGoNGnVqSSRTeyGCA4mHrbiaX3Qs8i8YNkZ9jbKhx2Ld


#ipfs1-自建
lotus net connect /ip4/183.129.161.12/tcp/40909/p2p/12D3KooWQNRAFomSK4VFD1ngih5ufwn1c9ujh6w6757LmZdZXw9k
#北京1
lotus net connect /ip4/115.236.19.69/tcp/38681/p2p/12D3KooWQGoNGnVqSSRTeyGCA4mHrbiaX3Qs8i8YNkZ9jbKhx2Ld
#北京2
lotus net connect /ip4/183.129.161.12/tcp/40907/p2p/12D3KooWJLVsis98JfhNBEhPFNB4C2nucwex3GTRgSRtzjEt5Hqb
#杭州-王总
lotus net connect /ip4/183.129.161.12/tcp/40908/p2p/12D3KooWMckFz5J2P6xpBhmP7arkYFXQC5SgKG7UeFpRaZCZkzNf



lotus net connect /dns4/bootstrap-0.mainnet.filops.net/tcp/1347/p2p/12D3KooWCVe8MmsEMes2FzgTpt9fXtmCY7wrq91GRiaC8PHSCCBj
lotus net connect /dns4/bootstrap-1.mainnet.filops.net/tcp/1347/p2p/12D3KooWCwevHg1yLCvktf2nvLu7L9894mcrJR4MsBCcm4syShVc
lotus net connect /dns4/bootstrap-2.mainnet.filops.net/tcp/1347/p2p/12D3KooWEWVwHGn2yR36gKLozmb4YjDJGerotAPGxmdWZx2nxMC4
lotus net connect /dns4/bootstrap-3.mainnet.filops.net/tcp/1347/p2p/12D3KooWKhgq8c7NQ9iGjbyK7v7phXvG6492HQfiDaGHLHLQjk7R
lotus net connect /dns4/bootstrap-4.mainnet.filops.net/tcp/1347/p2p/12D3KooWL6PsFNPhYftrJzGgF5U18hFoaVhfGk7xwzD8yVrHJ3Uc
lotus net connect /dns4/bootstrap-5.mainnet.filops.net/tcp/1347/p2p/12D3KooWLFynvDQiUpXoHroV1YxKHhPJgysQGH2k3ZGwtWzR4dFH
lotus net connect /dns4/bootstrap-6.mainnet.filops.net/tcp/1347/p2p/12D3KooWP5MwCiqdMETF9ub1P3MbCvQCcfconnYHbWg6sUJcDRQQ
lotus net connect /dns4/bootstrap-7.mainnet.filops.net/tcp/1347/p2p/12D3KooWRs3aY1p3juFjPy8gPN95PEQChm2QKGUCAdcDCC4EBMKf
lotus net connect /dns4/bootstrap-8.mainnet.filops.net/tcp/1347/p2p/12D3KooWScFR7385LTyR4zU1bYdzSiiAb5rnNABfVahPvVSzyTkR
lotus net connect /dns4/lotus-bootstrap.ipfsforce.com/tcp/41778/p2p/12D3KooWGhufNmZHF3sv48aQeS13ng5XVJZ9E6qy2Ms4VzqeUsHk
lotus net connect /dns4/bootstrap-0.starpool.in/tcp/12757/p2p/12D3KooWGHpBMeZbestVEWkfdnC9u7p6uFHXL1n7m1ZBqsEmiUzz
lotus net connect /dns4/bootstrap-1.starpool.in/tcp/12757/p2p/12D3KooWQZrGH1PxSNZPum99M1zNvjNFM33d1AAu5DcvdHptuU7u
lotus net connect /dns4/node.glif.io/tcp/1235/p2p/12D3KooWBF8cpp65hp2u9LK5mh19x67ftAam84z9LsfaquTDSBpt
lotus net connect /dns4/bootstrap-0.ipfsmain.cn/tcp/34721/p2p/12D3KooWQnwEGNqcM2nAcPtRR9rAX8Hrg4k9kJLCHoTR5chJfz6d
lotus net connect /dns4/bootstrap-1.ipfsmain.cn/tcp/34723/p2p/12D3KooWMKxMkD5DMpSWsW7dBddKxKT7L2GgbNuckz9otxvkvByP
date
lotus net scores | grep 2500 | grep -v -
echo 
echo
echo




#  */30 * * * * /bin/bash /root/addGoodPeers.sh  >> /root/AddGoodPeers.log 2>&1