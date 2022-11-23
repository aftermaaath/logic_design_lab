`timescale 1ns/1ps

module Sliding_Window_Sequence_Detector_t;
reg clk = 1'b1;
reg rst_n = 1'b0;
reg in = 1'b0;
wire dec;
// reg [3:0]tmp;
// wire [3:0]state;
// wire [3:0]nxt_st;

// specify duration of a clock cycle.
parameter cyc = 10;

// generate clock.
always #(cyc/2) clk = ~clk;

Sliding_Window_Sequence_Detector swsd (
    .clk (clk),
    .rst_n (rst_n),
    .in (in),
    .dec (dec)
);
initial begin
    @(negedge clk) rst_n = 1'b1;
    in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;

    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;

    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b0;

    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;

    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;

    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;

    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;

    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b0;
    @(negedge clk) in = 1'b1;
    @(negedge clk) in = 1'b0;


    @(negedge clk) $finish;

end
endmodule