python实现的钱包运行在python3环境下，可以单独运行也可以在docker镜像种运行，建议在docker镜像种运行

## 代码结构
这里列出了大部分主要代码，工具类代码并未详细列出来

## python 代码根目录
```
Dockerfile docker镜像配置文件
requirements.txt python依赖库配置
deposit_task_cmd.py 充值Job实例代码
platformserver_wsgi.py 平台遗留web服务实例代码
walletserver_wsgi.py 钱包web服务实例代码
```

### platformserver 平台遗留web服务实现目录
```
imboss_platformserver.py 平台遗留服务url mapping代码
config.py redis和数据库配置代码
resources url对应的逻辑实现存放目录
ad_notice.py 广告通知代码
banner.py banner图查询代码
country.py 国家列表查询代码
ex_app_system.py app配置代码
firstpage_message.py 首页消息代码
models 数据库操作代码目录
ad_notice.py 广告通知数据库操作类
banner.py banner图数据库操作类
ex_app_system.py app信息数据库操作类
message.py 首页消息数据库操作类
```

### walletserver
```
imboss_walletserver.py 钱包web服务url mapping代码
celery_beat.py job框架实例配置类
tasks.py 充值任务实现类（包括归集任务）
conf 配置代码目录
coin_config.py/coin_config_debug.py 钱包币种rpc节点配置代码，目前一直在debug模式下运行，所以实际启用的是coin_config_debug.py
config.py 数据库、redis、kafka配置代码
erc20_series.py 智能合约币配置代码
exjrpc 钱包rpc调用客户端代码目录
adaptor.py 客户端适配器类
authproxy.py rpc网络调用实现类
baserpc.py rpc调用接口定义类
btcrpc2.py 比特币系rpc客户端实现类
ethrpc2.py 以太坊系rpc客户端实现类
usdt_rpc.py USDT（omnicore）rpc客户端实现类
mail_msg 遗留邮件功能实现代码目录，已被弃用
migrations 数据库模型生成python类的代码目录
models 数据库操作代码目录，具体代码列表见运行目录或svn
resources url对应业务逻辑实现代码目录
wallet.py 钱包地址生成，提现逻辑实现类
asset_balance.py 钱包余额查询实现类
user_frozen.py 用户冻结类
user_deposit.py 充值信息查询类
inspire.py 钱包状态和交易详情查询类
sms_center.py 短信操作类（已废弃）
util 工具类目录
client_util.py rpc客户端一些常用判断方法工具类，包括以太坊的abi获取方法，原实现要调用etherscan，已改为直接获取配置数据，配置数据在erc20_series.py中
```