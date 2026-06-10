class fifo_write_seq_item extends uvm_sequence_item;

    rand bit [1:0] bucket;
    rand logic [DATA_WIDTH-1:0] wr_data;

    logic full;
    logic almost_full;
    logic [$clog2(DEPTH):0] count;

    `uvm_object_utils_begin(fifo_write_seq_item)
        `uvm_field_int(wr_data,     UVM_ALL_ON)
        `uvm_field_int(full,        UVM_ALL_ON)
        `uvm_field_int(almost_full, UVM_ALL_ON)
        `uvm_field_int(count,       UVM_ALL_ON)
    `uvm_object_utils_end

    // coverage-driven constraint
    constraint corner_cases {
        bucket dist { 0 := 1, 1 := 1, 2 := 1, 3 := 1 };
        bucket == 0 -> wr_data == 32'h00000000;
        bucket == 1 -> wr_data inside {[32'h00000001:32'h7FFFFFFF]};
        bucket == 2 -> wr_data inside {[32'h80000000:32'hFFFFFFFE]};
        bucket == 3 -> wr_data == 32'hFFFFFFFF;
    }

    function new(string name = "fifo_write_seq_item");
        super.new(name);
    endfunction

    // custom method for printing debug statement
    function string convert2string();
        return $sformatf("FIFO write transaction: data = %d, count = %d", wr_data, count);
    endfunction

endclass


class fifo_read_seq_item extends uvm_sequence_item;

    logic [DATA_WIDTH-1:0] rd_data;
    logic empty;
    logic almost_empty;
    logic [$clog2(DEPTH):0] count;
    time capture_time;

    `uvm_object_utils_begin(fifo_read_seq_item)
        `uvm_field_int(rd_data,      UVM_ALL_ON)
        `uvm_field_int(empty,        UVM_ALL_ON)
        `uvm_field_int(almost_empty, UVM_ALL_ON)
        `uvm_field_int(count,        UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "fifo_read_seq_item");
        super.new(name);
    endfunction

    // custom method for printing debug statement
    function string convert2string();
        return $sformatf("FIFO read transaction: data = %d, count = %d", rd_data, count);
    endfunction
    
endclass