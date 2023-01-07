
## 故障现象
mount /dev/sdd1 /mnt/data3

[ 2487.311826] XFS (sdd1): log mount failed
[ 2527.584165] XFS (sdd1): Mounting V5 Filesystem
[ 2527.644728] XFS (sdd1): Corruption warning: Metadata has LSN (20:2811952) ahead of current LSN (20:2811728). Please unmount and run xfs_repair (>= v4.3) to resolve.
[ 2527.644731] XFS (sdd1): log mount/recovery failed: error -22
[ 2527.644769] XFS (sdd1): log mount failed
[ 2829.729103] perf: interrupt took too long (3129 > 3127), lowering kernel.perf_event_max_sample_rate to 63750
[ 3123.532151] XFS (sdd1): Mounting V5 Filesystem
[ 3123.776595] XFS (sdd1): Corruption warning: Metadata has LSN (20:2811952) ahead of current LSN (20:2811728). Please unmount and run xfs_repair (>= v4.3) to resolve.
[ 3123.776598] XFS (sdd1): log mount/recovery failed: error -22
[ 3123.776639] XFS (sdd1): log mount failed
root@storage1:~# 


## 命令参数
root@storage1:~# xfs_repair 
Usage: xfs_repair [options] device

Options:
  -f           The device is a file
  -L           Force log zeroing. Do this as a last resort.
  -l logdev    Specifies the device where the external log resides.
  -m maxmem    Maximum amount of memory to be used in megabytes.
  -n           No modify mode, just checks the filesystem for damage.
  -P           Disables prefetching.
  -r rtdev     Specifies the device where the realtime section resides.
  -v           Verbose output.
  -c subopts   Change filesystem parameters - use xfs_admin.
  -o subopts   Override default behaviour, refer to man page.
  -t interval  Reporting interval in seconds.
  -d           Repair dangerously.
  -V           Reports version and exits.



## repair
注：-n 参数 不作更改。
```
root@storage1:~# xfs_repair -n /dev/sdd1
Phase 1 - find and verify superblock...
        - reporting progress in intervals of 15 minutes
        - block cache size set to 11086128 entries
Phase 2 - using internal log
        - zero log...
zero_log: head block 2811728 tail block 2811432
ERROR: The filesystem has valuable metadata changes in a log which needs to
be replayed.  Mount the filesystem to replay the log, and unmount it before
re-running xfs_repair.  If you are unable to mount the filesystem, then use
the -L option to destroy the log and attempt a repair.
Note that destroying the log may cause corruption -- please attempt a mount
of the filesystem before doing this.
root@storage1:~# 
```


## repair again
```
xfs_repair -L /dev/sdd1
```

日志：
```

        - agno = 66
        - agno = 67
        - agno = 68
        - agno = 69
        - agno = 70
        - agno = 71
        - agno = 72
        - agno = 73
        - agno = 74
        - agno = 75
        - agno = 76
        - 17:03:13: check for inodes claiming duplicate blocks - 35712 of 35712 inodes done
Phase 5 - rebuild AG headers and trees...
        - 17:03:13: rebuild AG headers and trees - 77 of 77 allocation groups done
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
        - 17:03:18: verify and correct link counts - 77 of 77 allocation groups done
Maximum metadata LSN (20:2811952) is ahead of log (1:8).
Format log to cycle 23.
done
```