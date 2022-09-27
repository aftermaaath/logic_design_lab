`timescale 1ns/1ps

module Dmux_1x2_4bit(in, a, b, sel);
input [4-1:0] in;
input sel;
output [4-1:0] a, b;
wire nsel;

not(nsel, sel);
and a1(a[0], nsel, in[0]);
and a2(a[1], nsel, in[1]);
and a3(a[2], nsel, in[2]);
and a4(a[3], nsel, in[3]);

and a5(b[0], sel, in[0]);
and a6(b[1], sel, in[1]);
and a7(b[2], sel, in[2]);
and a8(b[3], sel, in[3]);
    
endmodule

module Dmux_1x4_4bit(in, a, b, c, d, sel);
input [4-1:0] in;
input [2-1:0] sel;
output [4-1:0] a, b, c, d;
wire [3:0] in1, in2;

Dmux_1x2_4bit d3(in, in1, in2, sel[1]);
Dmux_1x2_4bit d1(in1, a, b, sel[0]);
Dmux_1x2_4bit d2(in2, c, d, sel[0]);

endmodule
