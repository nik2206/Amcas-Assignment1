#!/bin/bash

# Paths aligned with Task 1 environment
GEM5="/home/nikhil-v-atkuru/Desktop/IMC/gem5/build/X86/gem5.opt"
SE_SCRIPT="/home/nikhil-v-atkuru/Desktop/IMC/gem5/configs/deprecated/example/se.py"
BFS="/home/nikhil-v-atkuru/Desktop/AMCAS/gapbs/bfs"
SSSP="/home/nikhil-v-atkuru/Desktop/AMCAS/gapbs/sssp"
SCALE="-n 1 -g 12"

run_sim() {
    WORKLOAD=$1
    NAME=$2
    SIZE=$3
    LATENCY=$4
    CMD_PATH=$5
    OUTDIR="m5out_${WORKLOAD}_${NAME}"

    echo "=========================================================="
    echo "Task 3: Running ${WORKLOAD} - ${NAME} (TimingSimpleCPU | Size: ${SIZE}, Latency: ${LATENCY} cycles)"
    echo "=========================================================="

    $GEM5 --outdir=$OUTDIR $SE_SCRIPT \
      --cpu-type=TimingSimpleCPU --caches --l2cache --num-l2caches=1 \
      --l1d_size=32kB --l1i_size=32kB \
      --l2_size=$SIZE --l2_assoc=8 \
      --mem-type=DDR4_2400_8x8 --mem-size=4GB \
      --cmd=$CMD_PATH --options="$SCALE" \
      -P "system.l2.tag_latency=$LATENCY" -P "system.l2.data_latency=$LATENCY"
}

# Execute Task 3 runs on TimingSimpleCPU
run_sim "bfs"  "sram" "2MB" 7  $BFS
run_sim "bfs"  "mram" "8MB" 14 $BFS
run_sim "sssp" "sram" "2MB" 7  $SSSP
run_sim "sssp" "mram" "8MB" 14 $SSSP

echo ""
echo "=========================================================="
echo "                   TASK 3 RESULTS SUMMARY                 "
echo "=========================================================="
printf "%-10s | %-10s | %-12s | %-8s | %-12s\n" "Workload" "L2 Type" "simSeconds" "IPC" "L2 Miss Rate"
echo "----------------------------------------------------------"

for work in "bfs" "sssp"; do
    for type in "sram" "mram"; do
        DIR="m5out_${work}_${type}"
        if [ -f "${DIR}/stats.txt" ]; then
            SIM_SEC=$(grep "simSeconds" ${DIR}/stats.txt | awk '{print $2}')
            IPC=$(grep "system.cpu.ipc" ${DIR}/stats.txt | awk '{print $2}')
            MISS=$(grep "system.l2.overallMissRate::total" ${DIR}/stats.txt | awk '{print $2}')
            printf "%-10s | %-10s | %-12s | %-8s | %-12s\n" "$work" "$type" "$SIM_SEC" "$IPC" "$MISS"
        fi
    done
done
echo "=========================================================="
