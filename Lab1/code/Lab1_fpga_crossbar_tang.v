`timescale 1ns/1ps

module selc(sel, out, a);
    input sel;
    input [3:0] a;
    output [3:0] out;
    and and1(out[0], a[0], sel);
    and and2(out[1], a[1], sel);
    and and3(out[2], a[2], sel);
    and and4(out[3], a[3], sel);
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

or or1(f[0], t1[0], t2[0]);
or or2(f[1], t1[1], t2[1]);
or or3(f[2], t1[2], t2[2]);
or or4(f[3], t1[3], t2[3]);

endmodule

module Crossbar_2x2_4bit(in1, in2, control, out1, out2, out1_1, out2_1);
input [4-1:0] in1, in2;
input control;
output [4-1:0] out1, out2;
output [3:0]out1_1, out2_1;
wire ncont;
wire [3:0] a, b, c, d;
wire [3:0]out1_tmp, out2_tmp;
not n1(ncont, control);
Dmux_1x2_4bit d1(in1, a, b, control);
Dmux_1x2_4bit d2(in2, c, d, ncont);
Mux_2x1_4bit m1(a, c, control, out1);
Mux_2x1_4bit m2(b, d, ncont, out2);

not n2[3:0](out1_tmp, out1);

// not n2(out1_tmp[0], out1[0]);
// not n3(out1_tmp[1], out1[1]);
// not n4(out1_tmp[2], out1[2]);
// not n5(out1_tmp[3], out1[3]);

not n3[3:0](out2_tmp, out2);

// not(out2_tmp[0], out2[0]);
// not(out2_tmp[1], out2[1]);
// not(out2_tmp[2], out2[2]);
// not(out2_tmp[3], out2[3]);

not n4[3:0](out1_1, out1_tmp);

// not(out1_1[0], out1_tmp[0]);
// not(out1_1[1], out1_tmp[1]);
// not(out1_1[2], out1_tmp[2]);
// not(out1_1[3], out1_tmp[3]);

not n5[3:0](out2_1, out2_tmp);

// not(out2_1[0], out2_tmp[0]);
// not(out2_1[1], out2_tmp[1]);
// not(out2_1[2], out2_tmp[2]);
// not(out2_1[3], out2_tmp[3]);

endmodule
