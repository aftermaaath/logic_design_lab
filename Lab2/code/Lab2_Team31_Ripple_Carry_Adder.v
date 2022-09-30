`timescale 1ns/1ps

module AND_Gate (out, a, b);
input a, b;
output out;
wire nout;
nand n1(nout, a, b);
NOT_Gate not1(out, nout);

endmodule

module OR_Gate (out, a, b);
input a, b;
output out;
wire na, nb;

NOT_Gate not1(na, a);
NOT_Gate not2(nb, b);
nand n1(out, na, nb);

endmodule

module NOR_Gate (out, a, b);
input a, b;
output out;
wire nout;

OR_Gate or1(nout, a, b);
NOT_Gate not1(out, nout);

endmodule

module XOR_Gate (out, a, b);
input a, b;
output out;
wire x1, x2, na, nb;

NOT_Gate not1(na, a);
NOT_Gate not2(nb, b);
AND_Gate and1(x1, a, nb);
AND_Gate and2(x2, na, b);
OR_Gate or1(out, x1, x2);

endmodule

module XNOR_Gate (out, a, b);
input a, b;
output out;
wire nout;

XOR_Gate xor1(nout, a, b);
NOT_Gate not1(out, nout);

endmodule

module NOT_Gate (out, a);
input a;
output out;
nand n1(out, a, a);

endmodule

module Majority(a, b, c, out);
input a, b, c;
output out;
wire w1, w2, w3, w4;

AND_Gate a1(w1, a, b);
AND_Gate a2(w2, a, c);
AND_Gate a3(w3, c, b);
OR_Gate o1(w4, w1, w2);
OR_Gate o2(out, w4, w3);

endmodule

module Majority2(a, b, c, out);
input a, b, c;
output out;
wire w1, w2, w3, w4, nc;

NOT_Gate n1(nc, c);
XOR_Gate x1(w1, a, b);
XNOR_Gate x2(w2, a, b);
AND_Gate a1(w3, nc, w1);
AND_Gate a2(w4, c, w2);
OR_Gate a3(out, w4, w3);

endmodule

module Full_Adder (a, b, cin, cout, sum);
input a, b, cin;
output cout, sum;
wire tr3, tr1, tmp, tr0;

Majority m1(a, b, cin, cout);
Majority2 m2(a, b, cin, sum);

endmodule

module Ripple_Carry_Adder(a, b, cin, cout, sum);
input [8-1:0] a, b;
input cin;
output cout;
output [8-1:0] sum;
wire [6:0] c;

Full_Adder f1(a[0], b[0], cin, c[0], sum[0]);
Full_Adder f2(a[1], b[1], c[0], c[1], sum[1]);
Full_Adder f3(a[2], b[2], c[1], c[2], sum[2]);
Full_Adder f4(a[3], b[3], c[2], c[3], sum[3]);
Full_Adder f5(a[4], b[4], c[3], c[4], sum[4]);
Full_Adder f6(a[5], b[5], c[4], c[5], sum[5]);
Full_Adder f7(a[6], b[6], c[5], c[6], sum[6]);
Full_Adder f8(a[7], b[7], c[6], cout, sum[7]);
    
endmodule
