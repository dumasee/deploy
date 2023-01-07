注意点：
1. 合并代码时候文本的编码格式
2. blst,ffi两个目录需要直接拷贝过去
3. build目录下的.filecoin-install和.update-modules都需要拷贝过去
4. makefile文件中需要把clean这个文件[.update-modules]的注释掉

修改文件的列表：
```
/cmd/lotus-seal-worker/main.go
/extern/sector-storage/manager.go
/extern/sector-storage/stores/http_handler.go
/extern/sector-storage/stores/remote.go
/extern/sector-storage/stores/util_unix.go
/extern/sector-storage/sched.go
/extern/sector-storage/selector_task.go
/extern/sector-storage/sealtasks/task.go
/extern/sector-storage/ffiwrapper/partialfile.go
/extern/sector-storage/ffiwrapper/sealer_cgo.go
/extern/filecoin-ffi/rust/Cargo.lock
/extern/filecoin-ffi/rust/Cargo.toml
/cmd/lotus-storage-miner/sealing.go
/extern/filecoin-ffi/workflows.go
/extern/sector-storage/stores/index.go
/extern/storage-sealing/states_sealing.go
/extern/sector-storage/selector_alloc.go
/extern/sector-storage/worker_tracked.go
/extern/storage-sealing/fsm.go
/extern/storage-sealing/states_failed.go
/extern/sector-storage/selector_existing.go
/extern/filecoin-ffi/rust/Cargo.toml
/api/api_storage.go
/api/apistruct/struct.go
/extern/sector-storage/stats.go
/node/impl/storminer.go
/cmd/lotus-bench/main.go
/cmd/lotus-bench/import.go
/extern/sector-storage/sched_worker.go
/miner/miner.go

filecoin-project/neptune/Cargo.toml
filecoin-project/neptune/gbench/Cargo.toml
filecoin-project/rust-fil-proofs/fil-proofs-tooling/Cargo.toml
filecoin-project/rust-fil-proofs/filecoin-proofs/Cargo.toml
filecoin-project/rust-fil-proofs/storage-proofs/core/Cargo.toml
filecoin-project/rust-fil-proofs/storage-proofs/porep/Cargo.toml
filecoin-project/rust-fil-proofs/storage-proofs/post/Cargo.toml
filecoin-project/rust-filecoin-proofs-api/Cargo.toml
```