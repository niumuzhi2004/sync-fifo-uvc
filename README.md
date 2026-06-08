# Synchronous FIFO UVM Verification Component

## Overview
This project implements a simple **UVM (Universal Verification Methodology) verification component** for a synchronous FIFO (first-in-first-out).


## DUT Specification

![DUT Block Diagram](./.github/assets/fifo.svg)

| Parameter | Value |
|-----------|-------|
| `DATA_WIDTH` | 32 |
| `DEPTH` | 128 |
| `ALMOST_FULL_THRESHOLD` | Parameterizable |
| `ALMOST_EMPTY_THRESHOLD` | Parameterizable |
| Read style | Standard (registered output) |
| Reset | Synchronous, active-low |
| Write-while-full | Silently ignored |
| Read-while-empty | Output holds, `empty` asserted |
| Status flags | `full`, `empty`, `almost_full`, `almost_empty`, `count` |


## Testbench Architecture
- **UVC** - UVM verification component
    - 2 agents (write and read), each containing a driver, monitor, and sequencer
    - 2 sequence items for read and write transactions, respectively
- **Scoreboard** - checks data integrity and status flags using a SystemVerilog queue as a reference model
- **Coverage** - functional covergroups for write data boundary values, status flags (`full`, `empty`, `almost_full`, `almost_empty`), and FIFO state transitions
- **Sequences** - 4 virtual sequences based on the basic read and write sequences that test different scenarios of using the FIFO.

| Virtual Sequence | Description | Write/Read Count | Repetition |
|------------------|-------------|---------------|------------|
| Partial Fill | Write N items then read N items | N ∈ [1, DEPTH - 1] randomized | 100 |
| Full Cycle | Write to fill completely and read to drain FIFO | N = DEPTH + 1 fixed | 1 |
| Concurrent | Interleaved writes and reads via fork/join | N = DEPTH + 1 fixed | 1 |
| Reset | Write N items, reset FIFO, then write to fill completely and read to drain FIFO | N ∈ [1, DEPTH - 1] randomized | 10 |

- **Tests** - 4 tests (`fifo_partial_fill_test`, `fifo_full_cycle_test`, `fifo_concurrent_test`, `fifo_reset_test`) mapping to the 4 virtual sequences

## Results


## Requirements
| Tool | Version |
|---|---| 
| Xilinx Vivado | XSIM v2025.2 |
| UVM | UVM 1.2 (within Vivado) |


## How to Run
```cmd
cd sim
vivado -mode batch -source run.tcl
```

> Coverage report generated at `sim/coverage_report/functionalCoverageReport/xcrg_func_cov_report.txt`