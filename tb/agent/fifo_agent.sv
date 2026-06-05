class fifo_wr_agent extends uvm_agent;
    `uvm_component_utils(fifo_wr_agent)

    fifo_wr_sequencer sequencer;
    fifo_wr_driver    driver;
    fifo_wr_monitor   monitor;

    uvm_analysis_port #(fifo_write_seq_item) fifo_wr_ap;

    // active mode:  instantiates sequencer, driver, and monitor
    // passive mode: instantiates monitor only 

    function new(string name = "fifo_wr_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (is_active == UVM_ACTIVE) begin
            sequencer = fifo_wr_sequencer::type_id::create("sequencer", this);
            driver    = fifo_wr_driver::type_id::create("driver", this);
        end
        monitor = fifo_wr_monitor::type_id::create("monitor", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (is_active == UVM_ACTIVE)
            driver.seq_item_port.connect(sequencer.seq_item_export);
        fifo_wr_ap = monitor.fifo_wr_ap;
    endfunction

endclass


class fifo_rd_agent extends uvm_agent;
    `uvm_component_utils(fifo_rd_agent)

    fifo_rd_sequencer sequencer;
    fifo_rd_driver    driver;
    fifo_rd_monitor   monitor;

    uvm_analysis_port #(fifo_read_seq_item) fifo_rd_ap;

    // active mode:  instantiates sequencer, driver, and monitor
    // passive mode: instantiates monitor only 

    function new(string name = "fifo_rd_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (is_active == UVM_ACTIVE) begin
            sequencer = fifo_rd_sequencer::type_id::create("sequencer", this);
            driver    = fifo_rd_driver::type_id::create("driver", this);
        end
        monitor = fifo_rd_monitor::type_id::create("monitor", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (is_active == UVM_ACTIVE)
            driver.seq_item_port.connect(sequencer.seq_item_export);
        fifo_rd_ap = monitor.fifo_rd_ap;
    endfunction

endclass