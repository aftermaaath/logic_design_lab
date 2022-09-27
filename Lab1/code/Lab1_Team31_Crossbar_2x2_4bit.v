`timescale 1ns/1ps

module selc(sel, out, a);
    input sel;
    input [3:0] a;
    output [3:0] out;
    and a1(out[0], a[0], sel);
    and a2(out[1], a[1], sel);
    and a3(out[2], a[2], sel);
    and a4(out[3], a[3], sel);
endmodule

module Dmux_1x2_4bit(in, a, b, sel);
input [4-1:0] in;
input sel;
output [4-1:0] a, b;
wire nsel;

not n1(nsel, sel);
selc s1(nsel, a, in);
selc s2(sel, b, in);
    
endmodule

module Mux_2x1_4bit(a, b, sel, f);
input [4-1:0] a, b;
input sel;
output [4-1:0] f;
wire nsel;
wire [3:0] t1, t2;

not n1(nsel, sel);
selc s1(nsel, t1, a);
selc s2(sel, t2, b);

or o1(f[0], t1[0], t2[0]);
or o2(f[1], t1[1], t2[1]);
or o3(f[2], t1[2], t2[2]);
or o4(f[3], t1[3], t2[3]);

endmodule

module Crossbar_2x2_4bit(in1, in2, control, out1, out2);
input [4-1:0] in1, in2;
input control;
output [4-1:0] out1, out2;
wire ncont;
wire [3:0] a, b, c, d;

not n1(ncont, control);
Dmux_1x2_4bit d1(in1, a, b, control);
Dmux_1x2_4bit d2(in2, c, d, ncont);
Mux_2x1_4bit m1(a, c, control, out1);
Mux_2x1_4bit m2(b, d, ncont, out2);

endmodule
