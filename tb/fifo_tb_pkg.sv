`ifndef FIFO_TB_PKG
`define FIFO_TB_PKG

`uvm_analysis_imp_decl(_wr)
`uvm_analysis_imp_decl(_rd)

package fifo_tb_pkg;

    import fifo_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "./agent/fifo_seq_item.sv"
    `include "./agent/fifo_sequencer.sv"
    `include "./agent/fifo_monitor.sv"
    `include "./agent/fifo_driver.sv"
    `include "./agent/fifo_agent.sv"
    `include "./env/fifo_scoreboard.sv"
    `include "./env/fifo_coverage.sv"
    `include "./env/fifo_virtual_sequencer.sv"
    `include "./env/fifo_env.sv"
    `include "./sequences/fifo_base_seq.sv"
    `include "./sequences/fifo_virtual_seq.sv"
    `include "./tests/fifo_test.sv"

endpackage


`endif