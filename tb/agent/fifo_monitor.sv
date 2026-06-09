class fifo_wr_monitor extends uvm_monitor;
    `uvm_component_utils(fifo_wr_monitor)

    virtual fifo_if #(DEPTH, DATA_WIDTH) vif;
    uvm_analysis_port #(fifo_write_seq_item) fifo_wr_ap;

    function new(string name = "fifo_wr_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        fifo_wr_ap = new("fifo_wr_ap", this); // instantiate analysis port

        if (!uvm_config_db #(virtual fifo_if #(DEPTH, DATA_WIDTH))::get(this, "", "vif", vif))
            `uvm_fatal("NO_VIF", "Virtual interface not found!")
    endfunction

    task run_phase(uvm_phase phase);
        fifo_write_seq_item mon_item;

        forever begin
            @(vif.monitor_cb);
            if (vif.monitor_cb.wr_en) begin
                mon_item = fifo_write_seq_item::type_id::create("mon_item");
                mon_item.wr_data     = vif.monitor_cb.wr_data;
                mon_item.full        = vif.monitor_cb.full;
                mon_item.almost_full = vif.monitor_cb.almost_full;
                mon_item.count       = vif.monitor_cb.count;
                fifo_wr_ap.write(mon_item);
            end
        end 
    endtask

endclass


class fifo_rd_monitor extends uvm_monitor;
    `uvm_component_utils(fifo_rd_monitor)

    virtual fifo_if #(DEPTH, DATA_WIDTH) vif;
    uvm_analysis_port #(fifo_read_seq_item) fifo_rd_ap;

    function new(string name = "fifo_rd_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        fifo_rd_ap = new("fifo_rd_ap", this); // instantiate analysis port

        if (!uvm_config_db #(virtual fifo_if #(DEPTH, DATA_WIDTH))::get(this, "", "vif", vif))
            `uvm_fatal("NO_VIF", "Virtual interface not found!")
    endfunction

    task run_phase(uvm_phase phase);
        fifo_read_seq_item mon_item;
        logic pending_read = 0;

        forever begin
            @(vif.monitor_cb);

            if (pending_read) begin
                mon_item.rd_data = vif.monitor_cb.rd_data;
                fifo_rd_ap.write(mon_item);
                pending_read = 0;
            end

            if (vif.monitor_cb.rd_en) begin
                mon_item = fifo_read_seq_item::type_id::create("mon_item");
                mon_item.empty        = vif.monitor_cb.empty;
                mon_item.almost_empty = vif.monitor_cb.almost_empty;
                mon_item.count        = vif.monitor_cb.count;
                pending_read = 1;
            end
        end 
    endtask

endclass