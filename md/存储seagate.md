## seagate存储
描述：84盘位seagate存储 (5u84)
型号：5u84
接口：SAS SFF-8644 端口  /Mini-SAS 连接器（SFF-8644）
双端口12Gb/秒SAS

## 需要配置的服务器
HBA卡：LSI 9480-8e SAS3516/外部接口 SFF8644 x 2 
      (LSI SAS3516双核心Raid芯片 Lenovo 930-8e)  


## sas连接线种类
MiniSAS HD SFF-8644 to SFF-8644 (线缆两端的接头一样，方形)
SFF-8088 to SFF-8088 SAS (线缆两端的接头一样，扁的)
SFF8087 MiniSAS to 4*SATA,6Gbps 

##配置清单
- 管控服务器1台  Dell PowerEdge R620
- HBA卡一块(LSI 9480-8e SAS3516/外部接口 SFF8644 x 2)  1120元   (RAID 930-8e 4GB Flash)
- SAS线缆两条(MiniSAS SFF-8644 to SFF-8644)  100元*2=200元
- 10A转16A插头  15.8*2=31.6      共 1351.6元


## 功率
5u84 功率(装了84盘，只识别64盘)，测出来是1100w （双路电源，单路550w）

14
4


332



## 定位盘位
```
root@seagate3284-1:~# storcli /call show|grep UGUnsp
86:2    107 UGUnsp -  14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
86:3    104 UGUnsp -  14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
86:4    108 UGUnsp -  14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
86:5    111 UGUnsp -  14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
86:6    105 UGUnsp -  14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
86:7    106 UGUnsp -  14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
86:8    103 UGUnsp -  14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
86:9    110 UGUnsp -  14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
86:10   109 UGUnsp -  14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
86:47    94 UGUnsp -  14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
86:48    98 UGUnsp -  14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
86:50   101 UGUnsp -  14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
86:52   100 UGUnsp -  14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
86:59    92 UGUnsp -  14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
86:73    97 UGUnsp -  14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
86:74    93 UGUnsp -  14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
86:77    91 UGUnsp -  14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
86:78    95 UGUnsp -  14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
86:82    96 UGUnsp -  14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
 :99     99 UGUnsp -  14.551 TB SAS  HDD N   N  512B ST16000NM002G    U  -    
UGUnsp=UGood Unsupported|UGShld=UGood shielded|HSPShld=Hotspare shielded
```



## dell服务器配置
```
root@node5:~# bash deploy.sh hwinfo
CPU:  Intel(R) Xeon(R) CPU E5-2620 v2 @ 2.10GHz * 24 cores
Mem:  31Gi

Disk:
Disk /dev/sda: 278.9 GiB, 299439751168 bytes, 584843264 sectors

Ethernet:
01:00.0 Ethernet controller: Broadcom Inc. and subsidiaries NetXtreme BCM5720 2-port Gigabit Ethernet PCIe
01:00.1 Ethernet controller: Broadcom Inc. and subsidiaries NetXtreme BCM5720 2-port Gigabit Ethernet PCIe
02:00.0 Ethernet controller: Broadcom Inc. and subsidiaries NetXtreme BCM5720 2-port Gigabit Ethernet PCIe
02:00.1 Ethernet controller: Broadcom Inc. and subsidiaries NetXtreme BCM5720 2-port Gigabit Ethernet PCIe

VGA:
0b:00.0 VGA compatible controller: Matrox Electronics Systems Ltd. G200eR2

Raid:
03:00.0 RAID bus controller: Broadcom / LSI MegaRAID SAS 2208 [Thunderbolt] (rev 05)
04:00.0 RAID bus controller: Broadcom / LSI MegaRAID Tri-Mode SAS3516 (rev 01)     
root@node5:~# 
```


## raid卡硬件信息
```
root@node5:~# storcli /call show
Generating detailed summary of the adapter, it may take a while to complete.

CLI Version = 007.1613.0000.0000 Oct 29, 2020
Operating system = Linux 5.4.0-81-generic
Controller = 0
Status = Success
Description = None

Product Name = RAID 930-8e 4GB Flash
Serial Number = SP74507794
SAS Address =  500062b203195400
PCI Address = 00:04:00:00
System Time = 09/05/2021 23:39:22
Mfg. Date = 11/17/17
Controller Time = 09/05/2021 15:39:21
FW Package Build = 50.0.1-0374
BIOS Version = 7.00.09.0_4.17.08.00_0x07001600
FW Version = 5.001.00-0805
Driver Name = megaraid_sas
Driver Version = 07.713.01.00-rc1
Vendor Id = 0x1000
Device Id = 0x14
SubVendor Id = 0x1D49
SubDevice Id = 0x604
Host Interface = PCI-E
Device Interface = SAS-12G
Bus Number = 4
Device Number = 0
Function Number = 0
Domain ID = 0
Security Protocol = None
Enclosures = 1

Enclosure LIST :
==============

--------------------------------------------------------------------
EID State Slots PD PS Fans TSs Alms SIM Port# ProdID VendorSpecific 
--------------------------------------------------------------------
134 OK       16  0  0    0   0    0   1 -     SGPIO                 
--------------------------------------------------------------------

EID=Enclosure Device ID | PD=Physical drive count | PS=Power Supply count
TSs=Temperature sensor count | Alms=Alarm count | SIM=SIM Count | ProdID=Product ID
```


## 升级固件
storcli /c0 download file=9480-8i8e_nopad.rom


## 接第二张阵列卡
1. 卡1
Product Name = RAID 930-8e 4GB Flash
Serial Number = SP73706937
SAS Address =  500062b202e0fd80
PCI Address = 00:04:00:00
System Time = 10/11/2021 21:52:18
Mfg. Date = 09/21/17
Controller Time = 10/11/2021 13:52:17
FW Package Build = 51.15.0-4005
BIOS Version = 7.15.00.0_0x070F0301
FW Version = 5.150.00-3499
Driver Name = megaraid_sas
Driver Version = 07.713.01.00-rc1
Current Personality = RAID-Mode 
Vendor Id = 0x1000
Device Id = 0x14
SubVendor Id = 0x1D49
SubDevice Id = 0x604
Host Interface = PCI-E
Device Interface = SAS-12G
Bus Number = 4
Device Number = 0

2. 卡2
Product Name = RAID 930-8e 4GB Flash
Serial Number = SP74402536
SAS Address =  500062b2031178c0
PCI Address = 00:05:00:00
System Time = 10/11/2021 21:53:04
Mfg. Date = 11/07/17
Controller Time = 10/11/2021 13:53:03
FW Package Build = 50.0.1-0374
BIOS Version = 7.00.09.0_4.17.08.00_0x07001600
FW Version = 5.001.00-0805
Driver Name = megaraid_sas
Driver Version = 07.713.01.00-rc1
Vendor Id = 0x1000
Device Id = 0x14
SubVendor Id = 0x1D49
SubDevice Id = 0x604
Host Interface = PCI-E
Device Interface = SAS-12G
Bus Number = 5