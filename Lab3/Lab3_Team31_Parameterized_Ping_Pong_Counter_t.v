`timescale 1ns/1ps
module Parameterized_Ping_Pong_Counter_t;
reg clk = 1'b0;
reg rst_n = 1'b0;
reg enable = 1'b1;
reg flip = 1'b0;
reg [4-1:0] max = 4'd4;
reg [4-1:0] min = 4'd0;
wire direction;
wire [4-1:0] out;
// wire hold;

always#5 clk = ~clk;

Parameterized_Ping_Pong_Counter ppc(
    .clk(clk),
    .rst_n(rst_n),
    .enable(enable),
    .flip(flip),
    .max(max),
    .min(min),
    .direction(direction),
    .out(out)
    // .hold(hold)
);

initial begin
    #10 rst_n = 1'b1;
    #30
    repeat(3)begin
        #3
        flip = 1'b1;
        #10 flip = 1'b0;
    end
    #10 min = 4'd3;
    max = 4'd10;
    #20 
    rst_n = 1'b0;
    enable = 1'b0;
    #10 
    rst_n = 1'b1;
    enable = 1'b1;
    repeat(3)begin
        #15 flip = 1'b1;
        #9 flip = 1'b0;
    end
    #66
    min = 4'd9;
    max = 4'd9; 
    #20
    min = 4'd0;
    max = 15;
    #43 enable = 1'b0;
    #10 enable = 1'b1;
    repeat(2)begin
        #20 flip = 1'b1;
        #10 flip = 1'b0;
    end
    #50
    #10 min = 4'd3;
    #3 
    rst_n = 1'b0;
    enable = 1'b0;
    #5 enable = 1'b1;
    #10 rst_n = 1'b1;
    #10 max = 4'd7;
    #20 flip = 1'b1;
    #10 flip = 1'b0;
    #75 
    max = 4'd5;
    min = 4'd10;
    #25
    max = 4'd12;
    #30
    min = 4'd2;
    #10
    flip = 1'b1;
    #10 flip = 1'b0;
    #165
    min = 4'd8;
    #10
    max = 4'd13;
    #5
    rst_n = 1'b0;
    #10
    rst_n = 1'b1;
    #90
    $finish;
end

endmodule
