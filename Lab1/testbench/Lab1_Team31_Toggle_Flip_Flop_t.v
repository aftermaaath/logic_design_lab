`timescale 1ns/1ps

module Toggle_Flip_Flop_t;

// input and output signals
reg t = 1'b0;
reg rst_n = 1'b0;
reg clk = 1'b0;
wire q;

always#(1) clk = ~clk;

// test instance instantiation
Toggle_Flip_Flop TFF(clk, q, t, rst_n);

// brute force 
initial begin
    // rst_n = 1'b0;
    @(negedge clk) rst_n = 1'b1;

    @(negedge clk) t = 1'b1;
    @(negedge clk) t = 1'b0;
    @(negedge clk) t = 1'b1;
    @(negedge clk) t = 1'b0;
    
    @(negedge clk) rst_n = 1'b1;
    @(negedge clk) t = 1'b1;
    @(negedge clk) t = 1'b0;

    @(negedge clk) rst_n = 1'b0;
    @(negedge clk) t = 1'b1;
    @(negedge clk) t = 1'b0;

    @(negedge clk) rst_n = 1'b1;
    @(negedge clk) t = 1'b1;

    @(negedge clk) $finish;
end

endmodule