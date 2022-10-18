`timescale 1ns/1ps

module Round_Robin_FIFO_Arbiter_t();
reg clk = 1'b0;
reg rst_n = 1'b0;
reg [4-1:0] wen = 4'b0;
reg [8-1:0] a = 8'd12, b = 8'b0, c = 8'b0, d = 8'b0;
wire [8-1:0] dout;
wire valid;

parameter cyc = 10;
always#(cyc/2)clk = !clk;

Round_Robin_FIFO_Arbiter arb(
    .clk(clk),
    .rst_n(rst_n),
    .wen(wen),
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .dout(dout),
    .valid(valid)
 );
 
initial begin
    // ver0: pdf testbench
//    @(negedge clk)
//    rst_n = 1'b1;
//    wen = 4'b1111;
//    a = 8'd87;
//    b = 8'd56;
//    c = 8'd9;
//    d = 8'd13;
//    @(negedge clk)
//    wen = 4'b1000;
//    d = 8'd85;
//    @(negedge clk)
//    wen = 4'b0100;
//    c = 8'd139;
//    @(negedge clk)
//    wen = 4'b0000;
//    @(negedge clk)
//    wen = 4'b0000;
//    @(negedge clk)
//    wen = 4'b0000;
//    @(negedge clk)
//    wen = 4'b0001;
//    a = 8'd51;
//    @(negedge clk)
//    wen = 4'b0000;
//    @(negedge clk)
//    wen = 4'b0000;
    // ver1: only write in a
    @(negedge clk)
    rst_n = 1'b1;
    wen = 4'b0001;
    a = 8'd87;
    @(negedge clk)
    a = a + 2'b10;
    @(negedge clk)
    a = a + 2'b10;
    @(negedge clk)
    wen = 4'b0;
//    a = a + 2'b10;
    @(negedge clk)
//    a = a + 2'b10;
    @(negedge clk)
//    a = a + 2'b10;
    @(negedge clk)
    $finish;
end 

endmodule
