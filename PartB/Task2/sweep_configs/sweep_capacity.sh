#!/bin/bash
CACTI_DIR=~/Desktop/AMCAS/cacti
WORKDIR=~/Desktop/AMCAS/Amcas-Assignment1/PartB
TEMPLATE=$WORKDIR/cache_2mb_sram.cfg

OUT=$WORKDIR/task2_sweep_results.csv
echo "capacity_bytes,capacity_label,log2_capacity_kb,access_time_ns" > "$OUT"

declare -A SIZES=(
  [262144]="256KB:0"
  [524288]="512KB:1"
  [1048576]="1MB:2"
  [2097152]="2MB:3"
  [4194304]="4MB:4"
  [8388608]="8MB:5"
  [16777216]="16MB:6"
)

for bytes in 262144 524288 1048576 2097152 4194304 8388608 16777216; do
  label=$(echo "${SIZES[$bytes]}" | cut -d: -f1)
  log2kb=$(echo "${SIZES[$bytes]}" | cut -d: -f2)

  cfg="$WORKDIR/sweep_${bytes}.cfg"
  sed "s/^-size (bytes) .*/-size (bytes) ${bytes}/" "$TEMPLATE" > "$cfg"

  cd "$CACTI_DIR" || exit 1
  result=$(./cacti -infile "$cfg" 2>/dev/null)

  access_time=$(echo "$result" | grep "Access time (ns):" | head -1 | awk -F': ' '{print $2}')

  echo "${bytes},${label},${log2kb},${access_time}" >> "$OUT"
  echo "Done: ${label} -> access time = ${access_time} ns"
done

echo ""
echo "All results saved to: $OUT"
cat "$OUT"
