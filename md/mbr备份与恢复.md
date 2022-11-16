
## 备份mbr
```
dd if=/dev/sda of=mbr.img bs=512 count=1   
```

## 恢复mbr
```
dd if=mbr.img of=/dev/sda
```