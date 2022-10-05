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

module Full_Adder (a, b, cin, cout, sum);
input a, b, cin;
output cout, sum;
wire tmp;

Majority m1(a, b, cin, cout);
XOR x1(tmp, a, b);
XOR x2(sum, tmp, cin);

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
