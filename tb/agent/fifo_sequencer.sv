class fifo_wr_sequencer extends uvm_sequencer # (fifo_write_seq_item);
    `uvm_component_utils(fifo_wr_sequencer)

    function new(string name = "fifo_wr_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction

endclass


class fifo_rd_sequencer extends uvm_sequencer # (fifo_read_seq_item);
    `uvm_component_utils(fifo_rd_sequencer)

    function new(string name = "fifo_rd_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction

endclass