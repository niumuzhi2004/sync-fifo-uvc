class fifo_wr_seq extends uvm_sequence #(fifo_write_seq_item);
    `uvm_object_utils(fifo_wr_seq)

    int count = DEPTH + 1;

    function new(string name = "fifo_wr_seq");
        super.new(name);
    endfunction

    task body();
        repeat (count) begin
            req = fifo_write_seq_item::type_id::create("req");
            start_item(req);
            if (!req.randomize()) begin
                `uvm_error("BODY", "Randomization failed!")
            end
            finish_item(req);
        end 
    endtask

endclass


class fifo_rd_seq extends uvm_sequence #(fifo_read_seq_item);
    `uvm_object_utils(fifo_rd_seq)

    int count = DEPTH + 1;

    function new(string name = "fifo_rd_seq");
        super.new(name);
    endfunction

    task body();
        repeat (count) begin
            req = fifo_read_seq_item::type_id::create("req");
            start_item(req);
            finish_item(req);
        end 
    endtask

endclass