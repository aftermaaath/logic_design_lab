`timescale 1ns/1ps

//  basic logic gates
module NOT(out, a);
    input a;
    output out;
    Universal_Gate u1(1'b1, a, out);
endmodule

module AND(out, a, b);
    input a, b;
    output out;
    wire nb;
    NOT n1(nb, b);
    Universal_Gate u1(a, nb, out);
endmodule

module OR(out, a, b);
    input a, b;
    output out;
    wire na, nout;
    NOT n1(na, a);
    Universal_Gate u1(na, b, nout);
    NOT n2(out, nout);
endmodule

module XOR(out, a, b);
    input a, b;
    output out;
    wire w1, w2;
    Universal_Gate u1(a, b, w1);
    Universal_Gate u2(b, a, w2);
    OR o1(out, w1, w2);
endmodule

module NAND(out, a, b);
    input a, b;
    output out;
    wire nout;
    AND a1(nout, a, b);
    NOT n1(out, nout);
endmodule

module NOR(out, a, b);
    input a, b;
    output out;
    wire nout;
    OR o1(nout, a, b);
    NOT n1(out. nout);
endmodule

module XNOR(out, a, b);
    input a, b;
    output out;
    wire nout;
    XOR o1(nout, a, b);
    NOT n1(out, nout);
endmodule

// modules
module Majority(a, b, c, out);
input a, b, c;
output out;
wire w1, w2, w3, w4;

AND a1(w1, a, b);
AND a2(w2, a, c);
AND a3(w3, c, b);
OR o1(w4, w1, w2);
OR o2(out, w4, w3);

endmodule

module Majority2(a, b, c, out);
input a, b, c;
output out;
wire w1, w2, w3, w4, nc;

NOT n1(nc, c);
XOR x1(w1, a, b);
XNOR x2(w2, a, b);
AND a1(w3, nc, w1);
AND a2(w4, c, w2);
OR a3(out, w4, w3);

endmodule

module Full_Adder (a, b, cin, cout, sum);
input a, b, cin;
output cout, sum;

Majority m1(a, b, cin, cout);
Majority2 m2(a, b, cin, sum);

endmodule

module and_4bit (out, a, b, c, d);
input a, b, c, d;
output out;
wire t1, t2;

AND and1(t1, a, b);
AND and2(t2, c, d);
AND and3(out, t1, t2);

endmodule

module or_4bit (out, a, b, c, d);
input a, b, c, d;
output out;
wire t1, t2;

OR or1(t1, a, b);
OR or2(t2, c, d);
OR or3(out, t1, t2);

endmodule

module mux_8x1_1bit (out, x1, x2, x3, x4, x5, x6, x7, x8, sel);
input x1, x2, x3, x4, x5, x6, x7, x8;
input [2:0] sel;
output out;
wire [2:0] nsel;
wire [7:0] w;
wire tmp1, tmp2;

NOT not1(nsel[0], sel[0]);
NOT not2(nsel[1], sel[1]);
NOT not3(nsel[2], sel[2]);

and_4bit a1 (w[0], x1, nsel[2], nsel[1], nsel[0]);
and_4bit a2 (w[1], x2, nsel[2], nsel[1], sel[0]);
and_4bit a3 (w[2], x3, nsel[2], sel[1], nsel[0]);
and_4bit a4 (w[3], x4, nsel[2], sel[1], sel[0]);
and_4bit a5 (w[4], x5, sel[2], nsel[1], nsel[0]);
and_4bit a6 (w[5], x6, sel[2], nsel[1], sel[0]);
and_4bit a7 (w[6], x7, sel[2], sel[1], nsel[0]);
and_4bit a8 (w[7], x8, sel[2], sel[1], sel[0]);

or_4bit o1(tmp1, w[0], w[1], w[2], w[3]);
or_4bit o2(tmp2, w[4], w[5], w[6], w[7]);
OR or1(out, tmp1, tmp2);

endmodule

// func
module SUB(rd, rs, rt);
input [3:0] rs, rt;
output [3:0] rd;
wire [3:0] rt_cmt, nrt;
wire tmp;

NOT n1(nrt[0], rt[0]);
NOT n2(nrt[1], rt[1]);
NOT n3(nrt[2], rt[2]);
NOT n4(nrt[3], rt[3]);

ADD a1(rt_cmt, 4'b0001, nrt);
ADD a2(rd, rs, rt_cmt);

endmodule

module ADD(rd, rs, rt);
input [3:0] rs, rt;
output [3:0] rd;
wire [3:0] cout;

Full_Adder f0(rs[0], rt[0], 1'b0, cout[0], rd[0]);
Full_Adder f1(rs[1], rt[1], cout[0], cout[1], rd[1]);
Full_Adder f2(rs[2], rt[2], cout[1], cout[2], rd[2]);
Full_Adder f3(rs[3], rt[3], cout[2], cout[3], rd[3]);

endmodule

module BITWISE_OR(rd, rs, rt);
input [3:0] rs, rt;
output [3:0] rd;

OR o1(rd[0], rs[0], rt[0]);
OR o2(rd[1], rs[1], rt[1]);
OR o3(rd[2], rs[2], rt[2]);
OR o4(rd[3], rs[3], rt[3]);

endmodule

module BITWISE_AND(rd, rs, rt);
input [3:0] rs, rt;
output [3:0] rd;

AND a1(rd[0], rs[0], rt[0]);
AND a2(rd[1], rs[1], rt[1]);
AND a3(rd[2], rs[2], rt[2]);
AND a4(rd[3], rs[3], rt[3]);

endmodule

module RIGHT_SHIFT(rd, rs, rt);
input [3:0] rs, rt;
output [3:0] rd;

AND a1(rd[0], 1'b1, rt[1]);
AND a2(rd[1], 1'b1, rt[2]);
AND a3(rd[2], 1'b1, rt[3]);
AND a4(rd[3], 1'b1, rt[3]);

endmodule

module LEFT_SHIFT(rd, rs, rt);
input [3:0] rs, rt;
output [3:0] rd;

AND a1(rd[0], 1'b1, rs[3]);
AND a2(rd[1], 1'b1, rs[0]);
AND a3(rd[2], 1'b1, rs[1]);
AND a4(rd[3], 1'b1, rs[2]);

endmodule

module CMP_LT(rd, rs, rt);
input [3:0] rs, rt;
output [3:0] rd;
wire [2:0] eq; 
wire [1:0] upeq;
wire [3:0] lt;
wire [2:0] cond;
wire tmp1, tmp2;

NOT n1(rd[3], 1'b0);
NOT n2(rd[2], 1'b1);
NOT n3(rd[1], 1'b0);

// rt[i] == 1 && rs[i] == 0
Universal_Gate u1(rt[3], rs[3], lt[3]);
Universal_Gate u2(rt[2], rs[2], lt[2]);
Universal_Gate u3(rt[1], rs[1], lt[1]);
Universal_Gate u4(rt[0], rs[0], lt[0]);

// rt[i  - 1] == rs[i - 1], i:3~1
XNOR x1(eq[2], rt[3], rs[3]);
XNOR x2(eq[1], rt[2], rs[2]);
XNOR x3(eq[0], rt[1], rs[1]);

//  rt[j] == rs[j], for all j >= i
AND a1(upeq[1], eq[2], eq[1]);
AND a2(upeq[0], upeq[1], eq[0]);

// cond[i]: ith bit differ
AND a3(cond[2], lt[2], eq[2]);
AND a4(cond[1], lt[1], upeq[1]);
AND a5(cond[0], lt[0], upeq[0]);

OR o1(tmp1, cond[0], cond[1]);
OR o2(tmp2, cond[2], lt[3]);
OR o3(rd[0], tmp1, tmp2);

endmodule

module CMP_EQ(rd, rs, rt);
input [3:0] rs, rt;
output [3:0] rd;
wire [3:0] w;
wire tmp1, tmp2;

NOT n1(rd[3], 1'b0);
NOT n2(rd[2], 1'b0);
NOT n3(rd[1], 1'b0);
XNOR x1(w[0], rs[0], rt[0]); 
XNOR x2(w[1], rs[1], rt[1]); 
XNOR x3(w[2], rs[2], rt[2]); 
XNOR x4(w[3], rs[3], rt[3]); 

AND a1(tmp1, w[0], w[1]);
AND a2(tmp2, w[2], w[3]);
AND a3(rd[0], tmp1, tmp2);

endmodule

module Decode_And_Execute(rs, rt, sel, rd);
input [4-1:0] rs, rt;
input [3-1:0] sel;
output [4-1:0] rd;
wire [3:0] x1, x2, x3, x4, x5, x6, x7, x8;

SUB func1(x1, rs, rt);
ADD func2(x2, rs, rt);
BITWISE_OR func3(x3, rs, rt);
BITWISE_AND func4(x4, rs, rt);
RIGHT_SHIFT func5(x5, rs, rt);
LEFT_SHIFT func6(x6, rs, rt);
CMP_LT func7(x7, rs, rt);
CMP_EQ func8(x8, rs, rt);

mux_8x1_1bit m1(rd[0], x1[0], x2[0], x3[0], x4[0], x5[0], x6[0], x7[0], x8[0], sel);
mux_8x1_1bit m2(rd[1], x1[1], x2[1], x3[1], x4[1], x5[1], x6[1], x7[1], x8[1], sel);
mux_8x1_1bit m3(rd[2], x1[2], x2[2], x3[2], x4[2], x5[2], x6[2], x7[2], x8[2], sel);
mux_8x1_1bit m4(rd[3], x1[3], x2[3], x3[3], x4[3], x5[3], x6[3], x7[3], x8[3], sel);

endmodule

module output_to_signal(rs, rt, sel, seg, en);
input [4-1:0] rs, rt;
input [3-1:0] sel;
output [7-1:0] seg;
output [3:0] en;
wire [3:0] rd, nrd;
wire [6:0] nseg;
wire x_w, yz, _xz, _x_y_w, _xyw, x_y_z;
wire _y_z, _x_y, _x_z_w, _y_w, x_zw, _xzw;
wire _xw, x_y, _xy, _zw;
wire x_z, _yzw, yz_w, y_zw;
wire xy, xz, z_w;
wire y_w, _xy_z;
wire _yz, _xy_w; 

Decode_And_Execute de(rs, rt, sel, rd);
not n1 [3:0] (nrd, rd);
not n2 [3:0] (en, 4'b0001);

// xyzw: 3210
// A
and a1(x_w, rd[3], nrd[0]);
and a2(yz, rd[2], rd[1]);
and a3(_xz, nrd[3], rd[1]);
and a4(_x_y_w, nrd[3], nrd[2], nrd[0]);
and a5(_xyw, nrd[3], rd[2], rd[0]);
and a6(x_y_z, rd[3], nrd[2], nrd[1]);
// B
and a7(_y_z, nrd[2], nrd[1]);
and a8(_x_y, nrd[3], nrd[2]);
and a9(_x_z_w, nrd[3], nrd[1], nrd[0]);
and a10(_y_w, nrd[2], nrd[0]);
and a11(x_zw, rd[3], nrd[1], rd[0]);
and a12(_xzw, nrd[3], rd[1], rd[0]);
// C
and a13(_xw, nrd[3], rd[0]);
and a14(x_y, rd[3], nrd[2]);
and a15(_xy, nrd[3], rd[2]);
and a16(_zw, nrd[1], rd[0]);
// D
and a17(x_z, rd[3], nrd[1]);
and a18(_yzw, nrd[2], rd[1], rd[0]);
and a19(yz_w, rd[2], rd[1], nrd[0]);
and a20(y_zw, rd[2], nrd[1], rd[0]);
// E
and a21(xy, rd[3], rd[2]);
and a22(xz, rd[3], rd[1]);
and a23(z_w, rd[1], nrd[0]);
// FG
and a24(y_w, rd[2], nrd[0]);
and a25(_xy_z, nrd[3], rd[2], nrd[1]);
and a26(_yz, nrd[2], rd[1]);
and a27(_xy_w, nrd[3], rd[2], nrd[0]);

or o1(nseg[0], x_w, yz, _xz, _x_y_w, _xyw, x_y_z);
or o2(nseg[1], _y_z, _x_y, _x_z_w, _y_w, x_zw, _xzw);
or o3(nseg[2], _y_z, _xw, x_y, _xy, _zw);
or o4(nseg[3], x_z, _x_y_w, _yzw, yz_w, y_zw);
or o5(nseg[4], x_w, xy, xz, z_w, _y_w);
or o6(nseg[5], x_y, xz, y_w, _xy_z, _x_z_w);
or o7(nseg[6], x_y, xz, _yz, _xy_w, y_zw);
not n3 [6:0] (seg, nseg);

endmodule
