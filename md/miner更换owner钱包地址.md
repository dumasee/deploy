
## 参考链接
https://uzshare.com/view/842251


## 生成新钱包
```
lotus wallet new bls
```

## 向新钱包打币
```
lotus send f3新钱包 fil数量
```

## 设置默认钱包
```
lotus wallet set-default f3新钱包
```

## 查看当前own及worker地址
```
lotus-miner actor control list --verbose
```

## 更改owner地址
```
lotus-miner actor set-owner --really-do-it <address>
lotus-miner actor set-owner --really-do-it <new address> <old address> && lotus-miner actor set-owner --really-do-it <new address> <new address>
```