一、 总体说明  <br>
   ECOT链是为物联网设备专门定制的联盟链，为企业之间物联网设备协同工作及数据存证查询提供支持。<br>
二、 功能模块<br>
   飞羿链系统提供ECOT节点、服务SDK、设备SDK和管理平台四个主要功能模块。<br>
   1、ECOT节点：提供设备SDK数据的区块链存储和转发功能，保证数据不丢失和不被篡改。每个企业成员可以搭建一台或多台服务器作为节点服务器。各节点之间通过 P2P方式传递区块和交易数据。设备SDK和服务SDK以RPC函数方式调用节点功能列表。节点将设备sdk上发的交易数据上链，并转发给服务SDK.<br>
   2、服务SDK：为企业用户提供交易数据查询功能。服务SDK启动时根据配置项中的ECOT节点地址去注册到每一个节点。注册成功后节点会实时上传交易数据给服务SDK。服务SDK将ECOT节点上传的交易数据按功能权限转发给对应的企业应用。整个系统总共提供一个工作中的服务SDK应用。<br>
   3、设备SDK：设备SDK安装在物联网设备中，设备SDK在第一次启动时自动生成一个设备地址，作为设备在链上的唯一标志。同时设备有一个归属企业，企业地址在SDK第一次启动时作为参数传入，存储在对应的配置项中。后续设备的使用数据按交易方式上传到链上保存。<br>
   4、管理平台：提供联盟成员管理、设备物理绑定、权限管理、设备SDK下载等功能，并将联盟成员和设备中部分重要数据作上链保存。<br>