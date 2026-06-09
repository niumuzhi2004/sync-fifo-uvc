class fifo_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(fifo_scoreboard)

    // receive transactions from monitor
    uvm_analysis_imp_wr #(fifo_write_seq_item, fifo_scoreboard) wr_imp;
    uvm_analysis_imp_rd #(fifo_read_seq_item, fifo_scoreboard) rd_imp;

    logic [DATA_WIDTH-1:0] queue [$];
    logic [DATA_WIDTH-1:0] last_rd_data = 0;
    time wr_time_queue[$];
    int pending_pop = 0;

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
        count_passed       = (item.count == queue.size() - pending_pop);

        `uvm_info("SCORE", $sformatf(
                    "write_wr called: queue.size=%0d, item.full=%0d, item.count=%0d",
                    queue.size(), item.full, item.count), UVM_LOW)

        if (queue.size() < DEPTH) begin
            wr_time_queue.push_back($time);
            queue.push_back(item.wr_data);
        end
        else begin
            `uvm_info("SCORE", $sformatf("Ignored writing %0d while FIFO is full.", item.wr_data), UVM_LOW)
        end

        if (full_passed && almost_full_passed && count_passed) begin
            `uvm_info("SCORE", $sformatf("Test passed while writing %0d.", item.wr_data), UVM_LOW)
        end else begin
            if (~full_passed) begin
                `uvm_error("SCORE", $sformatf("Full flag incorrect while writing %0d.", item.wr_data))
            end
            if (~almost_full_passed) begin
                `uvm_error("SCORE", $sformatf("Almost full flag incorrect while writing %0d.", item.wr_data))
            end
            if (~count_passed) begin
                `uvm_error("SCORE", $sformatf("Count incorrect. Expected %0d, Got %0d.", queue.size(), item.count))
            end
        end

    endfunction

    function void write_rd(fifo_read_seq_item item);
        logic [DATA_WIDTH-1:0] exp_result;
        logic fifo_passed, empty_passed, almost_empty_passed, count_passed;

        // check if read and write arrive simultaneously
        bit is_simultaneous = (wr_time_queue.size() > 0 && wr_time_queue[0] == item.capture_time);
        if (is_simultaneous) 
            wr_time_queue.delete(0);

        if (is_simultaneous) begin // simultaneous reads and writes
            // because the read and write happen at the same time,
            // the read should see the FIFO state before the write happens,
            // which means the count should be one less than the actual queue size after the write
            empty_passed        = item.empty == (queue.size()-1 == 0);
            almost_empty_passed = item.almost_empty == (queue.size()-1 <= ALMOST_EMPTY_THRESHOLD);
            count_passed        = (item.count == queue.size()-1);
        end else begin
            empty_passed        = item.empty == (queue.size() == 0);
            almost_empty_passed = item.almost_empty == (queue.size() <= ALMOST_EMPTY_THRESHOLD);
            count_passed        = (item.count == queue.size());
        end

        `uvm_info("SCORE", $sformatf(
                "write_rd called: queue.size=%0d, item.empty=%0d, item.count=%0d, item.rd_data=%0d",
                queue.size(), item.empty, item.count, item.rd_data), UVM_LOW)

        // pop only when FIFO is not empty
        if (queue.size() == 0 || (is_simultaneous && queue.size() == 1)) begin
            exp_result = last_rd_data;
            `uvm_info("SCORE", $sformatf("Read data holding previous value %d while FIFO is empty.", item.rd_data), UVM_LOW)
        end else begin
            if (is_simultaneous) 
                pending_pop++;
            exp_result   = queue.pop_front();
            last_rd_data = exp_result;
            if (pending_pop > 0) 
                pending_pop--;
        end

        fifo_passed = (item.rd_data == exp_result);

        if (fifo_passed && empty_passed && almost_empty_passed && count_passed) begin
            `uvm_info("SCORE", $sformatf("Test passed while reading %0d.", item.rd_data), UVM_LOW)
        end else begin
            if (~empty_passed) begin
                `uvm_error("SCORE", $sformatf("Empty flag incorrect while reading %0d.", item.rd_data))
            end
            if (~almost_empty_passed) begin
                `uvm_error("SCORE", $sformatf("Almost empty flag incorrect while reading %0d.", item.rd_data))
            end
            if (~count_passed) begin
                `uvm_error("SCORE", $sformatf("Count incorrect. Expected %0d, Got %0d.", queue.size(), item.count))
            end
            if (~fifo_passed) begin
                `uvm_error("SCORE", $sformatf("Read value incorrect. Expected %0d, Got %0d.", exp_result, item.rd_data))
            end
        end

    endfunction

    function void reset();
        queue.delete();
        last_rd_data = 0;
        wr_time_queue.delete();
        pending_pop = 0;
    endfunction

endclass