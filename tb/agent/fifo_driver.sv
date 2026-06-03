class fifo_wr_driver extends uvm_driver #(fifo_write_seq_item);
    `uvm_component_utils(fifo_wr_driver)

    virtual fifo_if #(DEPTH, DATA_WIDTH) vif;

    function new(string name = "fifo_wr_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual fifo_if #(DEPTH, DATA_WIDTH))::get(this, "", "vif", vif))
            `uvm_fatal("NO_VIF", "Virtual interface not found!")
    endfunction

    task run_phase(uvm_phase phase);
        @(posedge vif.rst_n);
        forever begin
            seq_item_port.get_next_item(req);
            drive_item2bus(req);
            seq_item_port.item_done();
        end
    endtask

    task drive_item2bus(fifo_write_seq_item req);
        vif.wr_driver_cb.wr_en   = 1'b1;
        vif.wr_driver_cb.wr_data = req.wr_data;

        @(vif.wr_driver_cb);
        req.full        = vif.wr_driver_cb.full;
        req.almost_full = vif.wr_driver_cb.almost_full;
        req.count       = vif.wr_driver_cb.count;

        vif.wr_driver_cb.wr_en   = 1'b0;
    endtask

endclass


class fifo_rd_driver extends uvm_driver #(fifo_read_seq_item);
    `uvm_component_utils(fifo_rd_driver)

    virtual fifo_if #(DEPTH, DATA_WIDTH) vif;

    function new(string name = "fifo_rd_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual fifo_if #(DEPTH, DATA_WIDTH))::get(this, "", "vif", vif))
            `uvm_fatal("NO_VIF", "Virtual interface not found!")
    endfunction

    task run_phase(uvm_phase phase);
        @(posedge vif.rst_n);
        forever begin
            seq_item_port.get_next_item(req);
            drive_item2bus(req);
            seq_item_port.item_done();
        end
    endtask

    task drive_item2bus(fifo_read_seq_item req);
        vif.rd_driver_cb.rd_en = 1'b1;

        @(vif.rd_driver_cb);
        req.rd_data      = vif.rd_driver_cb.rd_data;
        req.empty        = vif.rd_driver_cb.empty;
        req.almost_empty = vif.rd_driver_cb.almost_empty;
        req.count        = vif.rd_driver_cb.count;

        vif.rd_driver_cb.rd_en = 1'b0;
    endtask

endclass