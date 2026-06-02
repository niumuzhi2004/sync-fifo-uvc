# Synchronous FIFO UVM Verification Component

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
