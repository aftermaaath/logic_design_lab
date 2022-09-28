`timescale 1ns/1ps

module Crossbar_4x4_4bit(in1, in2, in3, in4, out1, out2, out3, out4, control);
input [4-1:0] in1, in2, in3, in4;
input [5-1:0] control;
output [4-1:0] out1, out2, out3, out4;

wire [3:0]c0_1, c0_2, c3_1, c3_2, tmp_1, tmp_2; 

Crossbar_2x2_4bit c1(in1, in2, control[0], c0_1, c0_2);
Crossbar_2x2_4bit c2(in3, in4, control[3], c3_1, c3_2);
Crossbar_2x2_4bit c3(c0_2, c3_1, control[2], tmp_1, tmp_2);
Crossbar_2x2_4bit c4(c0_1, tmp_1, control[1], out1, out2);
Crossbar_2x2_4bit c5(tmp_2, c3_2, control[4], out3, out4);

endmodule

module selc(sel, out, a);
input sel;
input [3:0] a;
output [3:0] out;
and(out[0], a[0], sel);
and(out[1], a[1], sel);
and(out[2], a[2], sel);
and(out[3], a[3], sel);
endmodule

module Dmux_1x2_4bit(in, a, b, sel);
input [4-1:0] in;
input sel;
output [4-1:0] a, b;
wire nsel;

not(nsel, sel);
selc s1(nsel, a, in);
selc s2(sel, b, in);
    
endmodule

module Mux_2x1_4bit(a, b, sel, f);
input [4-1:0] a, b;
input sel;
output [4-1:0] f;
wire nsel;
wire [3:0] t1, t2;

not(nsel, sel);
selc s1(nsel, t1, a);
selc s2(sel, t2, b);

or(f[0], t1[0], t2[0]);
or(f[1], t1[1], t2[1]);
or(f[2], t1[2], t2[2]);
or(f[3], t1[3], t2[3]);

endmodule

module Crossbar_2x2_4bit(in1, in2, control, out1, out2);
input [4-1:0] in1, in2;
input control;
output [4-1:0] out1, out2;
wire ncont;
wire [3:0] a, b, c, d;

not(ncont, control);
Dmux_1x2_4bit d1(in1, a, b, control);
Dmux_1x2_4bit d2(in2, c, d, ncont);
Mux_2x1_4bit m1(a, c, control, out1);
Mux_2x1_4bit m2(b, d, ncont, out2);

endmodule
