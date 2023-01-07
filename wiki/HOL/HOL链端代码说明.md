```
build-aux：里面只有一个m4文件夹，但是m4的文件夹中有很多的m4文件

contrib：里面的文件很多，依此介绍如下：

 /contrib/debian  用于基于debian的linux的系统。
 /contrib/devtools  是针对此存储库的开发人员的特定工具，想要了解可以阅读readme.md文件。
 /contrib/gitian-descriptors  这是gitian在构建过程中所需要的文件，入药深入研究，
 /contrib/gitian-keys  这上面签署了开发核心程序的开发者，具体readme也有。
 /contrib/init 用于文件部署的初始化，具体的readme也会有。
 /contrib/linearize 用于构建区块链的线性，无叉，最佳版本，具体的readme也有。
 /contrib/macdeploy 适用于mac的脚本和笔记。具体readme也有。
 /contrib/qos  这是一个linux bash的脚本，他会限制连接到比特币网络的传输宽带。readme会有详细说明
 /contrib/ rpm 这是运行在centos上的给予RPM的发行版构建比特币核心。具体在readme内有说明
 /contrib/seeds 用于生成编译到客户端的使用程序，具体readme有说明。
 /contrib/testgen  为数据驱动的比特币测试生成测试向量，readme（懒得写了）
 /contrib/verify-commits 使用脚本来验证开发人员是否签署了每个合并提交的工具，readme
 /contrib/windeploy 适用于windows下的脚本部署
 /contrib/zmq   py脚本文件

depends：主要讲对不同系统的依赖性，和交叉编译。
doc：这主要讲了链端核心建立和运行的一些部署和建议
share：内部的前两个主要是图形有关的东西，最后一个主要讲为用户创建登录凭据
src：核心代码
 src/bench  其中有base58编码，有checkqueue等，主要是添加一个块和块中运算的一些基本标准。
 src/compact 处理文件兼容性相关的细节，跨平台，系统适配等。
 src/config  配置文件。
 src/consensus  交易/块的验证，里面有共识参数和认定方法，和merkle tree。
 src/cpp-ethereum 以太坊虚拟机代码
 src/crypto  里面有加密函数hash，SHA256，RIPEMD160等。
 src/leveldb  LevelDB is a fast key-value storage library written at Google that provides an ordered mapping from string keys to string values.具体内容见readme。
 src/obj  目标文件
 src/obj-test 目标文件
 src/secp256k1 椭圆曲线算法
 src/policy  用户可以根据自身需求而定义不同的policy。
 src/primitives  区块构建和验证交易
 src/qt  qt GUI库
 src/rpc  RPC框架是用于调用远程代码的一套工具
 src/script 交易溯源，秘钥验证，交易脚本，签名。
 src/support  内存控制，将未验证的区块放在内存里面
 src/test  各种测试
 src/univalue  UniValue iUniValue是一种抽象的数据类型，可以是null、boolean、string、number、数组容器或键/值字典容器，嵌套到任意深度，具体在readme里会有
 src/wallet  你的钱包，记录用户的信息，以及完成交易等信息
 src/zmq  是一个高性能的异步信息库

test：测试目录，主要包含测试fend及其集成测试。
```