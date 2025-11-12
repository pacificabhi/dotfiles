#!/bin/bash

GPU_UTIL=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null)
GPU_MEM=$(nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader,nounits 2>/dev/null)

if [[ -z "$GPU_UTIL" ]]; then
    echo '{"text":"GPU: off","tooltip":"GPU not active"}'
    exit 0
fi

USED=$(echo $GPU_MEM | awk '{print $1}')
TOTAL=$(echo $GPU_MEM | awk '{print $2}')
PERC=$(awk -v u="$USED" -v t="$TOTAL" 'BEGIN {printf "%.0f", (u/t)*100}')


echo "{\"text\":\"GPU: ${GPU_UTIL}% (${PERC}%)\",\"tooltip\":\"GPU Load: ${GPU_UTIL}%\nVRAM: ${USED}MB / ${TOTAL}MB\"}"

