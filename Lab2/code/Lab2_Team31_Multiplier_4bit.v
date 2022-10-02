`timescale 1ns/1ps

module Multiplier_4bit(a, b, p);
input [3:0] a, b;
output [7:0] p;

wire [2:0] w1; // a3b0, a2b0, a1b0
wire [3:0] w2, w3, w4;
wire [3:0] cout1, cout2, cout3;
wire [2:0] sum_1, sum_2;

// and
and_gate and0(p[0], a[0], b[0]); // a0b0
and_gate and1[3:1](w1[2:0], a[3:1], b[0]); // a3b0, a2b0, a1b0
and_gate and2[3:0](w2, a, b[1]); // a3b1, a2b1, a1b1, a0b1
and_gate and3[3:0](w3, a, b[2]); // a3b2, a2b2, a1b2, a0b2
and_gate and4[3:0](w4, a, b[3]); // a3b3, a2b3, a1b3, a0b3
// HA
Half_Adder ha1(w1[0], w2[0], cout1[0], p[1]);
Half_Adder ha2(sum_1[0], w3[0], cout2[0], p[2]);
Half_Adder ha3(sum_2[0], w4[0], cout3[0], p[3]);
Half_Adder ha4(cout1[2], w2[3], cout1[3], sum_1[2]);
// FA
Full_Adder fa1(w1[1], w2[1], cout1[0], cout1[1], sum_1[0]);
Full_Adder fa2(w1[2], w2[2], cout1[1], cout1[2], sum_1[1]);
Full_Adder fa3(sum_1[1], w3[1], cout2[0], cout2[1], sum_2[0]);
Full_Adder fa4(sum_1[2], w3[2], cout2[1], cout2[2], sum_2[1]);
Full_Adder fa5(sum_2[1], w4[1], cout3[0], cout3[1], p[4]);
Full_Adder fa6(cout1[3], w3[3], cout2[2], cout2[3], sum_2[2]);
Full_Adder fa7(sum_2[2], w4[2], cout3[1], cout3[2], p[5]);
Full_Adder fa8(cout2[3], w4[3], cout3[2], p[7], p[6]);

endmodule

module Half_Adder(a, b, cout, sum);
input a, b;
output cout, sum;

xor_gate xor1(sum, a, b);
and_gate and1(cout, a, b);

endmodule

module Full_Adder (a, b, cin, cout, sum);
input a, b, cin;
output cout, sum;
wire w1;

Majority maj(cout, a, b, cin);
xor_gate xor1(w1, a, b);
xor_gate xor2(sum, w1, cin);

endmodule

module Majority(out, a, b, c);
input a, b, c;
output out;
wire w1, w2, w3, w4;

and_gate and1(w1, a, b);
and_gate and2(w2, a, c);
and_gate and3(w3, b, c);

or_gate or1(w4, w1, w2);
or_gate or2(out, w4, w3);

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

module and_gate(out, in1, in2);
input in1, in2;
output out;
wire and_tmp;

nand nand2(and_tmp, in1, in2);
nand nand3(out, and_tmp, and_tmp);

endmodule

module or_gate(out, in1, in2);
input in1, in2;
output out;
wire or_tmp1, or_tmp2;

nand nand1(or_tmp1, in1, in1);
nand nand2(or_tmp2, in2, in2);
nand nand3(out, or_tmp1, or_tmp2);

endmodule