module sync_fifo #(
    parameter DEPTH = 128,
    parameter DATA_WIDTH = 32,
    parameter ALMOST_FULL_THRESHOLD = 112,
    parameter ALMOST_EMPTY_THRESHOLD = 16
) (
    input  logic clk,
    input  logic rst_n,
    input  logic wr_en,
    input  logic rd_en,
    input  logic [DATA_WIDTH-1:0] wr_data,
    output logic [DATA_WIDTH-1:0] rd_data,
    output logic full,
    output logic empty,
    output logic almost_full,
    output logic almost_empty,
    output logic [$clog2(DEPTH):0] count
);

    localparam NUM_OF_BITS = $clog2(DEPTH);

    // memory for buffer storage
    logic [DATA_WIDTH-1:0] mem [DEPTH];

    // write pointer for tracking write address
    logic [NUM_OF_BITS:0] wr_ptr;

    // read pointer for tracking read address
    logic [NUM_OF_BITS:0] rd_ptr;

    // memory write, read, and reset
    always_ff @(posedge clk) begin
        if (~rst_n) begin
            rd_data      <= 0;
            wr_ptr       <= 0;
            rd_ptr       <= 0;
            mem          <= '{default:0};
        end
        else begin
            if (wr_en && ~full) begin
                mem[wr_ptr[NUM_OF_BITS-1:0]] <= wr_data;
                wr_ptr                       <= wr_ptr + 1;
            end
            if (rd_en && ~empty) begin
                rd_data <= mem[rd_ptr[NUM_OF_BITS-1:0]];
                rd_ptr  <= rd_ptr + 1;
            end
        end
    end

    always_comb begin
        empty        = (wr_ptr == rd_ptr);
        full         = (wr_ptr[NUM_OF_BITS-1:0] == rd_ptr[NUM_OF_BITS-1:0])
                        && (wr_ptr[NUM_OF_BITS] != rd_ptr[NUM_OF_BITS]);
        count        = wr_ptr - rd_ptr;
        almost_empty = (count <= ALMOST_EMPTY_THRESHOLD);
        almost_full  = (count >= ALMOST_FULL_THRESHOLD);
    end

endmodule