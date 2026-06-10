class fifo_coverage extends uvm_component;
    `uvm_component_utils(fifo_coverage)

    logic [DATA_WIDTH-1:0] wr_data;
    logic full, almost_full, empty, almost_empty;
    logic [$clog2(DEPTH):0] count;

    // receive transactions from the monitor
    uvm_analysis_imp_wr #(fifo_write_seq_item, fifo_coverage) wr_imp;
    uvm_analysis_imp_rd #(fifo_read_seq_item, fifo_coverage) rd_imp;

    covergroup fifo_wr_covergroup with function sample();

        cp_full: coverpoint full {
            bins is_full  = { 1 };
            bins not_full = { 0 };
        }

        cp_almost_full: coverpoint almost_full {
            bins is_almost_full     = { 1 };
            bins not_almost_full = { 0 };
        }

        cp_wr_data: coverpoint wr_data {
            bins min  = {  32'h00000000  };
            bins smal = { [32'h00000001:32'h7FFFFFFF] };
            bins larg = { [32'h80000000:32'hFFFFFFFE] };
            bins max  = {  32'hFFFFFFFF  };
        }

        cp_state: coverpoint count {
            bins empty        = { 0 };
            bins almost_empty = { [1:ALMOST_EMPTY_THRESHOLD] };
            bins normal       = { [ALMOST_EMPTY_THRESHOLD+1:ALMOST_FULL_THRESHOLD-1] };
            bins almost_full  = { [ALMOST_FULL_THRESHOLD:DEPTH-1] };
            bins full         = { DEPTH };

            bins empty_to_almost_empty  = (0 => 1);
            bins almost_empty_to_normal = (ALMOST_EMPTY_THRESHOLD => ALMOST_EMPTY_THRESHOLD+1);
            bins normal_to_almost_full  = (ALMOST_FULL_THRESHOLD-1 => ALMOST_FULL_THRESHOLD);
            bins almost_full_to_full    = (DEPTH-1 => DEPTH);
        }

    endgroup

    covergroup fifo_rd_covergroup with function sample();

        cp_empty: coverpoint empty {
            bins empty     = { 1 };
            bins not_empty = { 0 };
        }

        cp_almost_empty: coverpoint almost_empty {
            bins almost_empty     = { 1 };
            bins not_almost_empty = { 0 };
        }

        cp_state: coverpoint count {
            bins empty        = { 0 };
            bins almost_empty = { [1:ALMOST_EMPTY_THRESHOLD] };
            bins normal       = { [ALMOST_EMPTY_THRESHOLD+1:ALMOST_FULL_THRESHOLD-1] };
            bins almost_full  = { [ALMOST_FULL_THRESHOLD:DEPTH-1] };
            bins full         = { DEPTH };

            bins full_to_almost_full    = (DEPTH => DEPTH-1);
            bins almost_full_to_normal  = (ALMOST_FULL_THRESHOLD => ALMOST_FULL_THRESHOLD-1);
            bins normal_to_almost_empty = (ALMOST_EMPTY_THRESHOLD+1 => ALMOST_EMPTY_THRESHOLD);
            bins almost_empty_to_empty  = (1 => 0);
        }

    endgroup

    function new(string name = "fifo_coverage", uvm_component parent = null);
        super.new(name, parent);
        fifo_wr_covergroup = new();
        fifo_rd_covergroup = new();
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        wr_imp = new("wr_imp", this);
        rd_imp = new("rd_imp", this);
    endfunction

    function void write_wr(fifo_write_seq_item item);
        wr_data     = item.wr_data;
        full        = item.full;
        almost_full = item.almost_full;
        count       = item.count;
        fifo_wr_covergroup.sample();
    endfunction

    function void write_rd(fifo_read_seq_item item);
        empty        = item.empty;
        almost_empty = item.almost_empty;
        count        = item.count;
        fifo_rd_covergroup.sample();
    endfunction

endclass