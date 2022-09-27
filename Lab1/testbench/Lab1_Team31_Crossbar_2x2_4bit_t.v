`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/22 23:56:53
// Design Name: 
// Module Name: Crossbar_2x2_4bit_t
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


module Crossbar_2x2_4bit_t;
reg [4-1:0] in1 = 4'b1000, in2 = 4'b0001;
reg control = 1'b0;
wire [4-1:0] out1, out2;

Crossbar_2x2_4bit c1(
    .in1(in1), 
    .in2(in2), 
    .control(control), 
    .out1(out1), 
    .out2(out2)
);

initial begin
    repeat (2 ** 3) begin
        #1 control = control + 1'b1;
        in1 = in1 + 4'b0001;
        in2 = in2 + 4'b0001;
    end
    #1 $finish;
end

endmodule
