## 修改配置
```
walletserver/conf/config.py (redis/kafka/mysqldb)
walletserver/conf/coin_config_debug.py (rpc的钱包节点url)
walletserver/conf/erc20_series.py (合约币数据)
walletserver/exjrpc/adaptor.py (币种和rpc客户端实例关系)
platformserver/config.py (redis/mysqldb)
deposit_task_cmd.py (充值任务实例)
```
## 初始化
```
python3 manage.py db init
python3 manage.py db migrate -m "initial migration"  
python3 manage.py db upgrade

pip3 install -I --no-deps -r requirements.txt \
    && rm -rf /.cache/pip/* \
    && find /usr/local -depth \
                \( \
                        \( -type d -a \( -name test -o -name tests \) \) \
                        -o \
                        \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
                \) -exec rm -rf '{}' +

apt-get update \
    && apt-get install -y --no-install-recommends build-essential libssl-dev python-dev  default-libmysqlclient-dev curl \
        && rm -rf /var/lib/apt/lists/*
```

## 创建docker镜像
必须在python目录下执行：
```
docker build -t test:python /root/python/（创建镜像）
```

## 非Docker方式启动
```
nohup python3 deposit_task_cmd.py start_all &

nohup gunicorn -k geventwebsocket.gunicorn.workers.GeventWebSocketWorker   --bind 0.0.0.0:8000 \-\-chdir /root/python -w 1 walletserver_wsgi:app > gunicorn.log &

nohup celery -A walletserver.tasks worker --workdir /root/python --loglevel=INFO -f logs/celery.logs -n worker.%h > celery.log &

nohup gunicorn -c /root/python/gun.conf  --bind 0.0.0.0:5000 --chdir /root/python  -w 1  platformserver_wsgi:app 2>1 > /root/python/platformserver/logs/console.log &
```
## Docker方式启动
```
docker stop $(docker ps -a -q)
docker  rm $(docker ps -a -q)
必须在python目录下执行：
python3 service.py start
```
## 增加ETH合约币
修改walletserver/conf/erc20_series.py文件（以PIC为示例）:
1. 增加合约地址的常量定义：
```
PIC_CONTRACT_ADDRESS = "0x3a002114e22edd686981e17dbe787f9efce27338"
```
2. 增加合约币的ABI数据配置：
```
PIC_CONTRACT_ABI = "[{\"constant\":true,\"inputs\":[],\"name\":\"name\",\"outputs\":[{\"name\":\"\",\"type\":\"string\"}],\"payabl...(数据太长，这里省略了)
```
3. 在COIN_CONTRACT_ADDRESS增加PIC的配置，增加后如下：
```
COIN_CONTRACT_ADDRESS = {"eth": None,
                         "mlc": MLC_CONTRACT_ADDRESS,
                         "pic": PIC_CONTRACT_ADDRESS,
                         }
```
4. 在COIN_CONTRACT_ABI增加PIC的配置，增加后如下：
```
COIN_CONTRACT_ABI = {"mlc": MLC_CONTRACT_ABI,
                         MLC_CONTRACT_ADDRESS: MLC_CONTRACT_ABI,
                         "pic": PIC_CONTRACT_ABI,
                         PIC_CONTRACT_ADDRESS: PIC_CONTRACT_ABI,
                         }
```
5，ERC_20里增加PIC的coin code，增加后如下：
```
ERC_20 = ['eth', 'mlc', 'pic']
```
6，在COIN_NAMES里增加pic的配置，增加后如下：
```
COIN_NAMES = ['btc','usdt', 'eth', ['mlc', 'pic']]
```
7，在ERC20_SERIES_PRECISION里增加PIC的精度配置，增加后如下：
ERC20_SERIES_PRECISION = {
    'mlc': 6,
    'pic': 6,
}

