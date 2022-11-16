
<!-- 更新日期：2022.11.08 -->

## 完整流程
```
Checked sectors  -> running window post  -> computing window post -> Submitted window post -> Window post submission successful
```

## 命令
先切换至log目录下，`cd /home/eb/lotus-amd-eb/log` 
```
cat miner.log|egrep -a 'Checked sectors|running window post|computing window post|Submitted window post|Window post submission successful'
```

## 输出日志
```
2022-07-13T18:33:42.865+0800    WARN    storageminer    storage/wdpost_run.go:237       Checked sectors {"checked": 2349, "good": 2349}
2022-07-13T18:33:42.924+0800    WARN    storageminer    storage/wdpost_run.go:237       Checked sectors {"checked": 90, "good": 90}
2022-07-13T18:33:42.945+0800    INFO    storageminer    storage/wdpost_run.go:649       running window post     {"chain-random": "mN1HWeuq6Nxuw0iWR6vr0FoZxBr2PN1tvkubGYNnEUQ=", "deadline": {"CurrentEpoch":1980065,"PeriodStart":1979964,"Index":2,"Open":1980084,"Close":1980144,"Challenge":1980064,"FaultCutoff":1980014,"WPoStPeriodDeadlines":48,"WPoStProvingPeriod":2880,"WPoStChallengeWindow":60,"WPoStChallengeLookback":20,"FaultDeclarationCutoff":70}, "height": "1980065", "skipped": 0}
2022-07-13T18:33:43.506+0800    WARN    storageminer    storage/wdpost_run.go:342       declare faults recovered Message CID    {"cid": "bafy2bzaceaujhi7ldfs7dlqsoxcg7tlxnrt4vvq4yn34wsbllnooxyxzfwtno"}
2022-07-13T18:36:59.756+0800    INFO    storageminer    storage/wdpost_run.go:664       computing window post   {"batch": 0, "elapsed": 196.81121952, "skip": 0, "err": null}
2022-07-13T18:44:01.062+0800    INFO    storageminer    storage/wdpost_run.go:873       Submitted window post: bafy2bzacecreddow4r2tdvkphbglyhslba7kl3yqmn7eisjyzksrd6zs3vu66 (deadline 2)
2022-07-13T18:47:30.323+0800    INFO    storageminer    storage/wdpost_run.go:883       Window post submission successful       {"cid": "bafy2bzacecreddow4r2tdvkphbglyhslba7kl3yqmn7eisjyzksrd6zs3vu66", "deadline": 2, "epoch": "1980090", "ts": [{"/":"bafy2bzaceapc2pgyfyjnnptu23gbf56um5hdvy652fpz2noclgdsvtq2ekjnc"},{"/":"bafy2bzacecttxoqviehxfjte2q7uiqo4xkj7wm2rwttodl2emgbkaylp2il66"}]}
eb@miner3-2683:~/lotus-amd-eb/log$ 
```