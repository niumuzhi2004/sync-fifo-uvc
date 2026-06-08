class fifo_virtual_sequencer extends uvm_sequencer;
    `uvm_component_utils(fifo_virtual_sequencer)

    fifo_wr_sequencer wr_sequencer;
    fifo_rd_sequencer rd_sequencer;
    virtual fifo_if #(DEPTH, DATA_WIDTH) vif;
    fifo_scoreboard scoreboard;

    function new(string name = "fifo_virtual_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction

endclass