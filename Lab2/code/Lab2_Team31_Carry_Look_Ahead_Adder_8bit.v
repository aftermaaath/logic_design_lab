`timescale 1ns/1ps

module Carry_Look_Ahead_Adder_8bit(a, b, c0, s, c8);
input [7:0] a, b;
input c0;
output [7:0] s;
output c8;

wire [7:0] p, g;
wire [2:0] cout_1, cout_2;
wire p03, g03, p47, g47;
wire c4;

// deal with FA
Full_Adder fa1(a[0], b[0], c0, p[0], g[0], s[0]);
Full_Adder fa2[3:1](a[3:1], b[3:1], cout_1[2:0], p[3:1], g[3:1], s[3:1]);
Full_Adder fa3(a[4], b[4], c4, p[4], g[4], s[4]);
Full_Adder fa4[7:5](a[7:5], b[7:5], cout_2[2:0], p[7:5], g[7:5], s[7:5]);

// deal with gen
generator_4bit genA(p[3:0], g[3:0], c0, p03, g03, cout_1);
generator_4bit genC(p[7:4], g[7:4], c4, p47, g47, cout_2);
generator_2bit genB(p03, g03, p47, g47, c0, c4, c8);

endmodule

module generator_4bit(p, g, c0, pout, gout, cout);
input [3:0] g, p;
input c0;
output pout, gout;
output [2:0] cout;

wire w1, w2, w3, w4, w5, w6, w7, w8, w9;
wire tmp1, tmp2, tmp3, tmp4;
// p[i, i+3]
and_gate and1(w1, p[0], p[1]);
and_gate and2(w2, p[2], p[3]);
and_gate and3(pout, w1, w2);

// g[i, i+3]
and_gate and4(w3, p[1], p[2]);
and_gate and5(w4, w3, p[3]);
and_gate and6(w5, w4, g[0]);

and_gate and7(w6, w2, g[1]);

and_gate and8(w7, p[3], g[2]);

or_gate or1(w8, w5, w6);
or_gate or2(w9, w7, w8);
or_gate or3(gout, w9, g[3]);

// cout
and_gate and9(tmp1, c0, p[0]);
or_gate or4(cout[0], tmp1, g[0]);

and_gate and10(tmp2, cout[0], p[1]);
or_gate or5(cout[1], tmp2, g[1]);

and_gate and11(tmp3, cout[1], p[2]);
or_gate or6(cout[2], tmp3, g[2]);

endmodule

module generator_2bit(p03, g03, p47, g47, c0, c4, c8);
input p03, g03, p47, g47, c0;
output c4, c8;

wire w1, w2;

and_gate and1(w1, p03, c0);
or_gate or1(c4, w1, g03);

and_gate and2(w2, p47, c4);
or_gate or2(c8, w2, g47);

endmodule

module Full_Adder (a, b, cin, p, g, sum);
input a, b, cin;
output sum, p, g;
wire w1;

and_gate and1(g, a, b);
or_gate or1(p, a, b);
xor_gate xor1(w1, a, b);
xor_gate xor2(sum, w1, cin);

endmodule

module or_gate(out, in1, in2);
input in1, in2;
output out;
wire or_tmp1, or_tmp2;

nand nand1(or_tmp1, in1, in1);
nand nand2(or_tmp2, in2, in2);
nand nand3(out, or_tmp1, or_tmp2);

endmodule

module and_gate(out, in1, in2);
input in1, in2;
output out;
wire and_tmp;

nand nand2(and_tmp, in1, in2);
nand nand3(out, and_tmp, and_tmp);

endmodule

module xor_gate(out, a, b);
input a, b;
output out;
wire w1, w2, w3;
nand nand1(w1, a, b);
nand nand2(w2, w1, a);
nand nand3(w3, w1, b);
nand nand4(out, w2, w3);

endmodule