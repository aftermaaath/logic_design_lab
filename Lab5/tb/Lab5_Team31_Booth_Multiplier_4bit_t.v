`timescale 1ns/1ps 

module Booth_Multiplier_4bit_t();
reg clk = 1'b0;
reg rst_n = 1'b0; 
reg start = 1'b0;
reg signed [3:0] a = 4'b0, b = 4'b0;
wire signed [7:0] p;

Booth_Multiplier_4bit bm(
    .clk(clk), 
    .rst_n(rst_n),
    .start(start), 
    .a(a), 
    .b(b), 
    .p(p)
);

always#5 clk = ~clk;

initial begin
    #10 rst_n = 1'b1;
    #70 start = 1'b1;
    a = 4'b1000;
    b = 4'b0010;
    #10 start = 1'b0;
    #70 start = 1'b1;
    a = 4'b0010;
    b = 4'b1000;
    #10 start = 1'b0;
    #70 start = 1'b1;
    a = 4'b1101;
    b = 4'b0001;
    #10 start = 1'b0;
    #70 start = 1'b1;
    a = 4'b1000;
    b = 4'b1000;
    #10 start = 1'b0;
    #70 start = 1'b1;
    a = 4'b1000;
    b = 4'b0111;
    #10 start = 1'b0;
    #70 start = 1'b1;
    a = 4'b0000;
    b = 4'b0101;
    #10 start = 1'b0;
    #70 start = 1'b1;
    a = 4'b0000;
    b = 4'b1101;
    #10 start = 1'b0;
    #70 start = 1'b1;
    a = 4'b0010;
    b = 4'b0000;
    #10 start = 1'b0;
    #70 start = 1'b1;
    a = 4'b1010;
    b = 4'b0000;
//    repeat(5)begin
//        #10 start = 1'b1;
//        #70 start = 1'b0; 
//        a = $random;
//        b = $random;
//    end
    #10 start = 1'b0;
    #70 $finish;
end

endmodule
