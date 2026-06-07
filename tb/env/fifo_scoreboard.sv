`uvm_analysis_imp_decl(_wr)
`uvm_analysis_imp_decl(_rd)

class fifo_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(fifo_scoreboard)

    // receive transactions from monitor
    uvm_analysis_imp_wr #(fifo_write_seq_item, fifo_scoreboard) wr_imp;
    uvm_analysis_imp_rd #(fifo_read_seq_item, fifo_scoreboard) rd_imp;

    logic [DATA_WIDTH-1:0] queue [$];

    function new(string name = "fifo_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        wr_imp = new("wr_imp", this);
        rd_imp = new("rd_imp", this);
    endfunction

    function void write_wr(fifo_write_seq_item item);
        logic full_passed, almost_full_passed, count_passed;

        full_passed        = item.full == (queue.size() == DEPTH);
        almost_full_passed = item.almost_full == (queue.size() >= ALMOST_FULL_THRESHOLD);
        count_passed       = (item.count == queue.size());

        if (queue.size() < DEPTH) 
            queue.push_back(item.wr_data);

        if (full_passed && almost_full_passed && count_passed) begin
            `uvm_info("SCORE", $sformatf("Test passed while writing %0d.", item.wr_data), UVM_LOW)
        end else begin
            `uvm_error("SCORE", $sformatf("Test failed while writing %0d.", item.wr_data))
        end

    endfunction

    function void write_rd(fifo_read_seq_item item);
        logic [DATA_WIDTH-1:0] exp_result;
        logic fifo_passed, empty_passed, almost_empty_passed, count_passed;

        empty_passed        = item.empty == (queue.size() == 0);
        almost_empty_passed = item.almost_empty == (queue.size() <= ALMOST_EMPTY_THRESHOLD);
        count_passed        = (item.count == queue.size());

        if (queue.size() == 0) begin
            `uvm_fatal("INVALID_READ", "Cannot read while queue is empty!")
        end else begin
            exp_result = queue.pop_front();
        end

        fifo_passed = (item.rd_data == exp_result);

        if (fifo_passed && empty_passed && almost_empty_passed && count_passed) begin
            `uvm_info("SCORE", $sformatf("Test passed while reading %0d.", item.rd_data), UVM_LOW)
        end else begin
            `uvm_error("SCORE", $sformatf("Test failed while reading %0d.", item.rd_data))
        end

    endfunction

endclass