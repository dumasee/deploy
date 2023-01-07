
1. grub修复
liveCD引导进入系统。
```
sudo -i
mount /dev/sda5 /mnt
chroot /mnt
grub2-install /dev/sda
```

2. 重建grub列表
进入系统      
```
update-grub
```

重新写入第一分区mbr
```
grub2-install /dev/sda
```

3. 修改启动顺序
修改/boot/grub目录下的grub.cfg文件。这里注意此文件不可写的，可以先运行一下命令
```
sudo chmod +w /boot/grub/grub.cfg
```
然后再就可以修改了。
