interface fifo_if #(
    parameter DEPTH = 128,
    parameter DATA_WIDTH = 32
) (
    input logic clk
);

    logic rst_n;
    logic [$clog2(DEPTH):0] count;

    logic wr_en;
    logic [DATA_WIDTH-1:0] wr_data;
    logic full;
    logic almost_full;

    logic rd_en;
    logic [DATA_WIDTH-1:0] rd_data;
    logic empty;
    logic almost_empty;

    clocking wr_driver_cb @ (posedge clk);
        default input #1 output #1;
        input full, almost_full, count;
        output wr_en, wr_data; 
    endclocking

    clocking rd_driver_cb @ (posedge clk);
        default input #1 output #1;
        input empty, almost_empty, count, rd_data;
        output rd_en;
    endclocking

    clocking monitor_cb @ (posedge clk);
        default input #1;
        input full, almost_full, empty, almost_empty,
              count, wr_en, wr_data, rd_en, rd_data;
    endclocking

    modport wr_driver_port (clocking wr_driver_cb, input clk);
    modport rd_driver_port (clocking rd_driver_cb, input clk);
    modport monitor_port   (clocking monitor_cb, input clk);
    
endinterface