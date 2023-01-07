

## 查看节点余额
lotus-miner info
```
Miner Balance:    25053.238 FIL
      PreCommit:  0
      Pledge:     20029.174 FIL
      Vesting:    4478.547 FIL
      Available:  545.516 FIL
```


## 提现到owner
```
lotus-miner actor withdraw
```

## 转帐到worker地址
命令： lotus send --from src-address dst-address amount
```
eb@miner2231:~/lotus-amd-eb/script$ lotus send --from f3uci7elabavnvdlc6dgxkshvjodcw5wthnzfza6dhaj44ztpbrqws6gd5jqemhvjjqtujeqsaonmb4vryhe4a f3utmt7kqfv3zjt5ux5cv7gth6u5embjqsifjk5xjekfh6rfazq627uxw7qpnaxs2z4uw6qusiulxw5mwq6vfa 545
```

## 开始封装