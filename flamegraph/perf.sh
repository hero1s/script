#!/bin/bash


# check
if [ $# -ne 1 ]; then
    echo "用法: $0 <PID>"
    exit 1
fi

PID=$1

# 删除之前的采集文件
rm -f perf.data perf.unfold perf.folded

echo "开始采集进程 $PID 的性能数据，按 Ctrl+C 停止..."

post_process() {
    echo "正在生成火焰图..."
    perf script -i perf.data &> perf.unfold
    ./FlameGraph/stackcollapse-perf.pl perf.unfold &> perf.folded
    ./FlameGraph/flamegraph.pl perf.folded > perf-$(date +%Y-%m-%d_%H-%M-%S).svg
    echo "火焰图已生成。"
    exit 0
}


# 捕获 Ctrl+C 信号
trap post_process SIGINT

perf record -a --call-graph dwarf -p $PID


post_process