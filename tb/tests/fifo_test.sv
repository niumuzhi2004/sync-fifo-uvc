class fifo_base_test extends uvm_test;
    `uvm_component_utils(fifo_base_test)

    fifo_env env;

    function new(string name = "fifo_base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = fifo_env::type_id::create("env", this);
    endfunction

endclass


class fifo_partial_fill_test extends fifo_base_test;
    `uvm_component_utils(fifo_partial_fill_test)

    function new(string name = "fifo_partial_fill_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        fifo_partial_fill_vseq partial_fill_seq;
        phase.raise_objection(this);
        partial_fill_seq = fifo_partial_fill_vseq::type_id::create("partial_fill_seq");
        partial_fill_seq.start(env.vseqr);
        phase.drop_objection(this);
    endtask

endclass


class fifo_full_cycle_test extends fifo_base_test;
    `uvm_component_utils(fifo_full_cycle_test)

    function new(string name = "fifo_full_cycle_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        fifo_full_cycle_vseq full_cycle_vseq;
        phase.raise_objection(this);
        full_cycle_vseq = fifo_full_cycle_vseq::type_id::create("full_cycle_vseq");
        full_cycle_vseq.start(env.vseqr);
        phase.drop_objection(this);
    endtask

endclass


class fifo_concurrent_test extends fifo_base_test;
    `uvm_component_utils(fifo_concurrent_test)

    function new(string name = "fifo_concurrent_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        fifo_concurrent_vseq concurrent_vseq;
        phase.raise_objection(this);
        concurrent_vseq = fifo_concurrent_vseq::type_id::create("concurrent_vseq");
        concurrent_vseq.start(env.vseqr);
        phase.drop_objection(this);
    endtask

endclass


class fifo_reset_test extends fifo_base_test;
    `uvm_component_utils(fifo_reset_test)

    function new(string name = "fifo_reset_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        fifo_reset_vseq reset_vseq;
        phase.raise_objection(this);
        reset_vseq = fifo_reset_vseq::type_id::create("reset_vseq");
        reset_vseq.start(env.vseqr);
        phase.drop_objection(this);
    endtask

endclass