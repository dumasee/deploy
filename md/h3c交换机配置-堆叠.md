## 交换机堆叠配置
- 配置交换机-1 <主>
```
irf member 1 priority 32
interface Ten-GigabitEthernet 1/0/21
  shutdown
interface Ten-GigabitEthernet 1/0/22
  shutdown

irf-port 1/1
 port group interface Ten-GigabitEthernet 1/0/21
 port group interface Ten-GigabitEthernet 1/0/22
 
write
irf-port-configuration active

interface Ten-GigabitEthernet 1/0/21
  undo shutdown
interface Ten-GigabitEthernet 1/0/22
  undo shutdown
```

- 配置交换机-2 <从>
```
irf member 1 renumber 2
interface Ten-GigabitEthernet 1/0/21
  shutdown
interface Ten-GigabitEthernet 1/0/22
  shutdown
irf-port 1/2
 port group interface Ten-GigabitEthernet 1/0/21
 port group interface Ten-GigabitEthernet 1/0/22

irf-port-configuration active
write
```

- 堆叠生效
重启reboot sw-2这台后，从设备会`自动连到主设备同步配置`。因此一些共通的配置在主设备上配置就够了。
&nbsp;

- 命令记录
```
<sw>dis irf
MemberID    Role    Priority  CPU-Mac         Description
 *+1        Master  32        00e0-fc0f-8c02  ---
   2        Standby 1         00e0-fc0f-8c03  ---
--------------------------------------------------
 * indicates the device is the master.
 + indicates the device through which the user logs in.

 The bridge MAC of the IRF is: f010-90b3-6890
 Auto upgrade                : yes
 Mac persistent              : 6 min
 Domain ID                   : 0
<sw>dis ver
<sw>dis version
H3C Comware Software, Version 7.1.070, Release 6308
Copyright (c) 2004-2019 New H3C Technologies Co., Ltd. All rights reserved.
H3C S6520-30SG-SI uptime is 4 weeks, 3 days, 13 hours, 40 minutes
Last reboot reason : Cold reboot

Boot image: flash:/S6520SGSI-cmw710-boot-r6308.bin
Boot image version: 7.1.070, Release 6308
  Compiled Oct 12 2019 11:00:00
System image: flash:/S6520SGSI-cmw710-system-r6308.bin
System image version: 7.1.070, Release 6308
  Compiled Oct 12 2019 11:00:00
Feature image(s) list:
  flash:/S6520SGSI-cmw710-freeradius-r6308.bin, version: 7.1.070
    Compiled Oct 12 2019 11:00:00
  flash:/S6520SGSI-cmw710-escan-r6308.bin, version: 7.1.070
    Compiled Oct 12 2019 11:00:00


Slot 1:
Uptime is 4 weeks,3 days,13 hours,40 minutes
S6520-30SG-SI with 2 Processors
BOARD TYPE:         S6520-30SG-SI
DRAM:               1024M bytes
FLASH:              1024M bytes
PCB 1 Version:      VER.A
Bootrom Version:    101
CPLD 1 Version:     001
Release Version:    H3C S6520-30SG-SI-6308
Patch Version  :    None
Reboot Cause  :     ColdReboot
[SubSlot 0] 22SFP Plus + 8GE

Slot 2:
Uptime is 4 weeks,3 days,13 hours,26 minutes
S6520-30SG-SI with 2 Processors
BOARD TYPE:         S6520-30SG-SI
DRAM:               1024M bytes
FLASH:              1024M bytes
PCB 1 Version:      VER.A
Bootrom Version:    101
CPLD 1 Version:     001
Release Version:    H3C S6520-30SG-SI-6308
Patch Version  :    None
Reboot Cause  :     IRFMergeReboot
[SubSlot 0] 22SFP Plus + 8GE
<sw>
```
