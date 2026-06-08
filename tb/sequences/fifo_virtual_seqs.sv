class fifo_full_cycle_vseq extends uvm_sequence;
    `uvm_object_utils(fifo_full_cycle_vseq)

    `uvm_declare_p_sequencer(fifo_virtual_sequencer)

    fifo_wr_seq wr_seq;
    fifo_rd_seq rd_seq;

    function new(string name = "fifo_full_cycle_vseq");
        super.new(name);
    endfunction

    task body();
        wr_seq = fifo_wr_seq::type_id::create("wr_seq");
        rd_seq = fifo_rd_seq::type_id::create("rd_seq");

        wr_seq.start(p_sequencer.wr_sequencer);
        rd_seq.start(p_sequencer.rd_sequencer);
    endtask

endclass


class fifo_concurrent_vseq extends uvm_sequence;
    `uvm_object_utils(fifo_concurrent_vseq)

    `uvm_declare_p_sequencer(fifo_virtual_sequencer)

    fifo_wr_seq wr_seq;
    fifo_rd_seq rd_seq;

    function new(string name = "fifo_concurrent_vseq");
        super.new(name);
    endfunction

    task body();
        wr_seq = fifo_wr_seq::type_id::create("wr_seq");
        rd_seq = fifo_rd_seq::type_id::create("rd_seq");

        fork
            begin: write_sequence
                wr_seq.start(p_sequencer.wr_sequencer);
            end
            begin: read_sequence
                rd_seq.start(p_sequencer.rd_sequencer);
            end
        join
    endtask

endclass


class fifo_reset_vseq extends uvm_sequence;
    `uvm_object_utils(fifo_reset_vseq)

    `uvm_declare_p_sequencer(fifo_virtual_sequencer)

    fifo_wr_seq wr_seq;
    fifo_rd_seq rd_seq;

    function new(string name = "fifo_reset_vseq");
        super.new(name);
    endfunction

    task body();
        wr_seq = fifo_wr_seq::type_id::create("wr_seq");
        rd_seq = fifo_rd_seq::type_id::create("rd_seq");

        wr_seq.count = DEPTH / 2; // half full
        wr_seq.start(p_sequencer.wr_sequencer);

        // apply reset
        p_sequencer.vif.rst_n = 1'b0;
        repeat (3) @(p_sequencer.vif.monitor_cb);
        p_sequencer.vif.rst_n = 1'b1;
        p_sequencer.scoreboard.reset();

        wr_seq.count = DEPTH + 1;
        wr_seq.start(p_sequencer.wr_sequencer);
        rd_seq.start(p_sequencer.rd_sequencer);
    endtask

endclass


class fifo_simultaneous_vseq extends uvm_sequence;
    `uvm_object_utils(fifo_simultaneous_vseq)

    `uvm_declare_p_sequencer(fifo_virtual_sequencer)

    fifo_wr_seq wr_seq;
    fifo_rd_seq rd_seq;

    function new(string name = "fifo_simultaneous_vseq");
        super.new(name);
    endfunction

    task body();
        
    endtask
    
endclass