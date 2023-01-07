1. 取消easylogging的日志打印方式 ，easylog在多线程下打印会引起core。(是否是因为票池本身数据有问题引起的core?) 将日志使用内置的LOGPRINT宏打印。
2. 对票池的操作使用读写锁模式，防止多个线程对同一个票池做读写时引起数据不一致而产生CORE问题。具体使用boost库的Lock,WriteLock和ReadLock.
```
typedef boost::shared_mutex Lock;                  
typedef boost::unique_lock< Lock >  WriteLock;
typedef boost::shared_lock< Lock >  ReadLock;
```
3. 增加票池块高的延时ticketpool_height_latency, 在当前块高延迟ticketpool_height_latency个块后将区块中的买票加入到票池中，防止因暂时分叉引起票池数据不一致。
4. 在更新票池时若出现分叉，当分叉高度不超过ticketpool_height_latency时,不更新到票池中，若分叉高度超过了ticketpool_height_latency，需要将票池中错误的选票删除，并把原来已经当作幸运票删除的选票补回去（补回去的动作需要分析实现逻辑）。