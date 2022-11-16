#!/bin/bash
export MINER_API_INFO=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJBbGxvdyI6WyJyZWFkIiwid3JpdGUiLCJzaWduIiwiYWRtaW4iXX0.wG3Ll5hYV0MBMM73aVXV4FdI5rf7mDWp53q3OezA6m8:/ip4/192.168.22.31/tcp/2345/http
export LOTUS_EMPTY_PATH=/home/eb/data/empty_sector_34359738368
export FIL_PROOFS_SELECT_CORE_GROUPS=16
export FIL_PROOFS_PARAMETER_CACHE=/var/tmp/filecoin-proof-parameters
export FIL_PROOFS_MULTICORE_SDR_PRODUCERS=1
export FIL_PROOFS_USE_MULTICORE_SDR=1
export EXIT_AFTER_WOKE_DONE=1
export RUST_LOG=info
export RUST_BACKTRACE=1
export FIL_PROOFS_USE_GPU_TREE_BUILDER=1
export FIL_PROOFS_USE_GPU_COLUMN_BUILDER=1
export FIL_PROOFS_MAXIMIZE_CACHING=1
export LOTUS_SHUT_DOWN=false

#GPU
export CUDA_VISIBLE_DEVICES=0

nohup ./lotus-bench sealSpec  --storage-dir=/mnt/nvme1/bench --sector-size=32GiB --miner-addr=f0121810 --skip-commit2=true --skip-unseal=true --ticket-preimage=26de70d5a1c7c760e46f3e2868043f7349aacd4493456d0bc5e00a7dd2d117c2 --sector-number=136830  2>&1 > 136830.log &

