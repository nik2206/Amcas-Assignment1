# AMCAS Assignment 1

This repository contains the experiments, simulation inputs, and result files for AMCAS Assignment 1. The work is organized by part and mapped to the specific tooling used in each task:

- Part A: SPICE-based 6T SRAM circuit analysis
- Part B: CACTI SRAM cache modeling and sizing
- Part C: NVSim STT-MRAM cache evaluation
- Part D: Ramulator DRAM scheduling and address mapping study
- Part E: gem5 system-level cache performance evaluation

The formal write-up is in `AMCAS_A1.pdf`.

## Repository layout

- `Part A/`: 6T SRAM read/write margins, voltage sweeps, and temperature effects
- `Part B/`: CACTI SRAM L2 cache design space exploration
- `Part C/`: NVSim STT-MRAM L2 cache analysis and comparison to SRAM
- `Part D/`: DRAM channel analysis with Ramulator and workload trace processing
- `Part E/`: gem5 simulations on SRAM vs. STT-MRAM L2 caches
- `AMCAS_A1.pdf`: final report for the assignment
- `Assignment1_AMCAS.pdf`: original assignment brief / handout

## Which part is which tool?

### Part A — SPICE / ngspice

This part models the SRAM bitcell and its read/write behavior directly at transistor level. The `.spice` files in `Part A/Task1`, `Task2`, `Task3`, and `Task4` use the 45 nm PTM BSIM model file (`45nm_bulk.txt`) and are intended for transient simulation in ngspice.

Typical reproduction commands:

```bash
cd "Part A/Task1"
ngspice -b sram_task1.spice

cd "Part A/Task2"
ngspice -b sram_task2_orig.spice
ngspice -b sram_task2_wide.spice

cd "Part A/Task3"
ngspice -b sram_task3_sweep.spice
python plot_task3.py

cd "Part A/Task4"
ngspice -b sram_task4_85C.spice
```

The generated CSV and PNG outputs in each task folder document the measured bitline differential, access-time behavior, and temperature sensitivity.

### Part B — CACTI

This part sizes and evaluates an SRAM L2 cache using CACTI. The configuration files under `Part B/Task1`, `Part B/Task2`, and `Part B/Task3` correspond to different cache design points and optimization objectives.

Typical reproduction commands:

```bash
# Task 1 example
cd "Part B/Task1"
# run the CACTI binary against the SRAM config file
/path/to/cacti -infile cache_2mb_sram.cfg

# Task 2 plot
cd "Part B/Task2"
python plot_task2.py

# Task 3 objective sweep
cd "Part B/Task3"
./run_task3.sh
# or, explicitly:
/path/to/cacti -infile task3_pure_delay.cfg
/path/to/cacti -infile task3_pure_area.cfg
/path/to/cacti -infile task3_ed2p.cfg
```

Note: the local script uses absolute paths to the author's workstation, so you should replace them with the actual CACTI install path on your machine before running it.

### Part C — NVSim

This part compares an STT-MRAM L2 cache against the SRAM baseline using NVSim. The `.cfg` files define cache target, size, area, and cell model settings, while the `.cell` files define the STT-MRAM device model.

Typical reproduction commands:

```bash
cd "Part C/Task1"
/path/to/nvsim -cfg STT_cache_2MB.cfg

cd "Part C/Task3"
/path/to/nvsim -cfg STT_cache_2MB_tmr2.cfg

cd "Part C/Task4"
/path/to/nvsim -cfg STT_cache_2MB_lowreset.cfg
```

The corresponding output text files (`NVSim_STT_output.txt`, `task3_tmr2_results.txt`, `task4_lowreset_resized_results.txt`) are saved alongside the config files.

### Part D — Ramulator

This part evaluates DRAM behavior using Ramulator on a DDR4 memory channel, using the L2 miss trace as input. The YAML files in `Part D/Task1`, `Task2`, `Task3`, and `Task4` set the scheduler, address mapping, and controller policies.

Typical reproduction commands:

```bash
cd "Part D/Task1"
/path/to/ramulator -config ddr4.yaml

cd "Part D/Task2"
/path/to/ramulator -config ddr4.yaml

cd "Part D/Task3"
/path/to/ramulator -config ddr4.yaml

cd "Part D/Task4"
/path/to/ramulator -config ddr4.yaml
```

The repo already contains the generated logs (`run_output.txt`, `stats.txt`, `ctrl_trace.log.ch0`) for comparison. The YAML config files refer to the trace path `../workload/l2miss.trace`; if you want to reproduce the run from scratch, generate or place the trace in that location first.

### Part E — gem5

This part measures end-to-end system behavior for SRAM and STT-MRAM L2 caches using gem5. The shell scripts in `Part E/Task1` and `Part E/Task3` run full-system-style SE simulations with GAPBS workloads (`bfs` and `sssp`). The stats directories (`m5out_*`) are included in the repo.

Typical reproduction commands:

```bash
cd "Part E/Task1"
./run_task1.sh

cd "Part E/Task3"
./run_task3.sh
```

The scripts assume the gem5 binary is installed in a local path such as `/home/nikhil-v-atkuru/Desktop/IMC/gem5/build/X86/gem5.opt`, together with the GAPBS binaries under `/home/nikhil-v-atkuru/Desktop/AMCAS/gapbs/`. Update those paths before running the scripts on another machine.

## Practical notes for reproduction

- This repository contains both the inputs and the generated results, but some of the original run scripts contain hard-coded absolute paths. Those paths must be adjusted to your local environment before rerunning.
- For a clean reproduction, install or point to the following toolchains:
  - ngspice for Part A
  - CACTI for Part B
  - NVSim for Part C
  - Ramulator for Part D
  - gem5 + GAPBS for Part E
- The report in `AMCAS_A1.pdf` explains the design choices and interpretation of the results. The raw files in the part folders are the detailed data behind each conclusion.

## Important

This README is meant to help locate the right tool and files for each part of the assignment. It does not replace the report or the assignment brief; it is a guide for navigating the repository and reproducing the simulations.
