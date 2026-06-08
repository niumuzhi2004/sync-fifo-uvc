`include "uvm_macros.svh"

import fifo_pkg::*;
import uvm_pkg::*;
import fifo_tb_pkg::*;

module tb_top();
    logic clk = 0;
    always #5 clk = ~clk; // clock generation

    fifo_if #(DEPTH, DATA_WIDTH) if_inst(clk);

    sync_fifo #(
        DEPTH, 
        DATA_WIDTH, 
        ALMOST_FULL_THRESHOLD, 
        ALMOST_EMPTY_THRESHOLD
    ) dut (
        .clk          (clk),
        .rst_n        (if_inst.rst_n),
        .wr_en        (if_inst.wr_en),
        .rd_en        (if_inst.rd_en),
        .wr_data      (if_inst.wr_data),
        .rd_data      (if_inst.rd_data),
        .full         (if_inst.full),
        .empty        (if_inst.empty),
        .almost_full  (if_inst.almost_full),
        .almost_empty (if_inst.almost_empty),
        .count        (if_inst.count)
    );

    initial begin
        if_inst.wr_en   = 0;
        if_inst.rd_en   = 0;
        if_inst.wr_data = 0;
        if_inst.rst_n   = 0;
        repeat (3) @(posedge clk);
        if_inst.rst_n   = 1;

        uvm_config_db #(virtual fifo_if #(DEPTH, DATA_WIDTH))
            ::set(null, "uvm_test_top.*", "vif", if_inst);
        run_test();
    end

endmodule