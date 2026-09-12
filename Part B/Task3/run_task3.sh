#!/bin/bash
# ============================================================
# Part B — Task 3: Run CACTI with three different objectives
#   1) Pure delay   (100% weight on delay, Optimize = NONE)
#   2) Pure area    (100% weight on area,  Optimize = NONE)
#   3) ED²P         (Optimize = ED^2, overrides weights)
# ============================================================

CACTI=~/Desktop/AMCAS/cacti/cacti
CFG_DIR=~/Desktop/AMCAS/Amcas-Assignment1/PartB
OUT_DIR=~/Desktop/AMCAS/Amcas-Assignment1/PartB

echo "========================================"
echo "  Task 3 — Run 1: Pure Delay"
echo "========================================"
$CACTI -infile "$CFG_DIR/task3_pure_delay.cfg" | tee "$OUT_DIR/task3_pure_delay_results.txt"

echo ""
echo "========================================"
echo "  Task 3 — Run 2: Pure Area"
echo "========================================"
$CACTI -infile "$CFG_DIR/task3_pure_area.cfg" | tee "$OUT_DIR/task3_pure_area_results.txt"

echo ""
echo "========================================"
echo "  Task 3 — Run 3: ED²P"
echo "========================================"
$CACTI -infile "$CFG_DIR/task3_ed2p.cfg" | tee "$OUT_DIR/task3_ed2p_results.txt"

echo ""
echo "========================================"
echo "  SUMMARY — Best Ndwl / Ndbl / Nspd"
echo "========================================"
echo ""

for run in pure_delay pure_area ed2p; do
    echo "--- $run ---"
    grep -E "Best Nd(wl|bl)|Best Nspd|Access time|Cache height|Total dynamic read energy" "$OUT_DIR/task3_${run}_results.txt" | head -7
    echo ""
done
