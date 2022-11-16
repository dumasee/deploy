
## 安装megacli
- 添加安装源
echo "deb http://hwraid.le-vert.net/ubuntu bionic main" >> /etc/apt/sources.list

- 安装
apt-get update && apt-get install megacli megactl megaraid-status

- 添加GPG证书
如果执行提示 GPG 错误，需要执行如下命令添加证书：
wget -O - http://hwraid.le-vert.net/debian/hwraid.le-vert.net.gpg.key | sudo apt-key add -


## megacli命令
- 查看虚拟驱动器的信息，包括raid级别
megacli -LDInfo -Lall -aALL

- 查看物理磁盘信息
megacli -PDList -aALL

- raid卡信息
megacli -AdpAllInfo -aALL

root@storage1:~# lspci |grep -i raid
02:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS-3 3108 [Invader] (rev 02)

megacli -FwTermLog -Dsply -aALL |grep -i "error"

megacli -PDList -aALL |grep "Firmware state" |wc
megacli -PDList -aALL |grep "Error Count" |wc

root@storage3:~# megacli -AdpAllInfo -aALL|grep Product
Product Name    : AVAGO MegaRAID SAS 9361-8i
Product Name    : AVAGO MegaRAID SAS 9361-8i

- 查看raid控制器数量
megacli -adpCount

- 查看阵列组信息
megacli -LDInfo -Lall -aALL

- 查看阵列卡信息
megacli -AdpAllInfo -aALL|grep Product

- 查看bus id
megacli -AdpGetPciInfo -aall -NoLog

megacli -LdPdInfo -a0 -NoLog

- 查看每块盘状态
megacli -PDList -aAll -NoLog | grep 'Firmware state'

- 查看磁盘Enclosure Device ID，Slot Number
megacli -PDList -aAll -NoLog | grep -A2 "Enclosure Device ID"

- 磁盘序列号
megacli -PDList -aALL | grep 'Inquiry Data:'

- 显示raid组及对应的磁盘
megacli -cfgdsply –aALL | grep -E "DISK\ GROUP|Slot\ Number"



## 故障磁盘更换
- 让硬盘LED灯闪烁，以定位故障盘位置。硬盘编号顺序：从左至右，从上至下。
megacli -PdLocate -start –physdrv[36:8] -a0

- 停掉硬盘LED灯
megacli -PdLocate -stop –physdrv[36:8] -a0

- 更换故障硬盘
取下故障盘，更换硬盘，装上新硬盘后会自动rebuild。

- 查看`重建进度`
megacli -PDRbld -ShowProg  -PhysDrv [36:8] -a0

## Unconfigured Bad处理
- Make Unconf Good
megacli -PDMakeGood -PhysDrv[36:8] -a0 -NoLog

-扫描外来配置
megacli -cfgforeign -scan -a0

- Clear Foreign Configuration
megacli -CfgForeign -Clear -aALL -NoLog

- 配置导入
megacli -CfgForeign -Import -aall


## 其它命令
- 磁盘下线（硬盘下线一般不需执行此命令）
megacli -PDOffline -PhysDrv[36:8] -a0

- 磁盘上线（一般不需执行此命令）
megacli -PDOnline -PhysDrv[36:8] -a0

- 强制rebuild
megacli -PDRbld -Start -PhysDrv[36:8] -a0


- 查看丢失的物理设备信息
megacli -PdGetMissing -a0

- 清除单个磁盘
megacli -pdclear -start -physdrv[25:1] -a0

- 将RAID卡`配置信息`保存为一个文件
megacli -CfgSave -f a0.cfg -a0
megacli -CfgSave -f a1.cfg -a1

- 以文本进度条样式显示 Rebuild 进度
megacli -pdrbld -progdsply -physdrv[36:1] -aALL