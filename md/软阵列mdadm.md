- 创建阵列
mdadm --create --verbose /dev/md0 --level=0 --raid-devices=4 /dev/sda{1,2,3,4}

mdadm --create --verbose /dev/md0 --level=0 --raid-devices=4 /dev/nvme0n1p1 /dev/nvme1n1p1 /dev/nvme2n1p1 /dev/nvme3n1p1

mdadm --create --verbose /dev/md0 --level=0 --raid-devices=4 /dev/nvme0n1p1 /dev/nvme1n1p1 /dev/nvme2n1p1 /dev/nvme3n1p1

- 查看阵列
cat /proc/mdstat

- 格式化&挂载
mkfs.xfs /dev/md0
mkdir -p /mnt/md0
mount /dev/md0 /mnt/md0

- 保存raid
mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf
update-initramfs -u
echo '/dev/md0 /mnt/md0 xfs defaults, nofail, discard 0 0' | sudo tee -a /etc/fstab


/dev/nvme0n1p1 /dev/n1p1 /dev/nvme2n1p1 /dev/nvme3n1p1

mdadm --zero-superblock /dev/md0 --level=0 --raid-devices=4 /dev/nvme0n1 /dev/nvme2n1 /dev/nvme3n1
