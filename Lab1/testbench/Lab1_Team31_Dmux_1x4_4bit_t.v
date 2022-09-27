`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/22 23:46:23
// Design Name: 
// Module Name: Dmux_1x4_4bit_t
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Dmux_1x4_4bit_t;
reg [3:0]in = 4'b1010;
reg [1:0]sel = 2'b0;

wire [3:0]a;
wire [3:0]b;
wire [3:0]c;
wire [3:0]d;

Dmux_1x4_4bit m1(
    .a (a),
    .b (b),
    .c (c),
    .d (d),
    .sel (sel),
    .in (in)
);

initial begin
    repeat (2 ** 3) begin
        #1 sel = sel + 2'b1;
        in = in + 4'b1;
    end
    #1 $finish;
end

endmodule
