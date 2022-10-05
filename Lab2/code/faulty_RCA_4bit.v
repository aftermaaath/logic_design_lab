`timescale 1ns/1ps

module Ripple_Carry_Adder(a, b, cin, cout, sum);
input [3:0] a, b;
input cin;
output cout;
output [3:0] sum;
wire c1, c2, c3;
wire c4;

Full_Adder fa1(a[0], b[0], cin, c1, c4);
Full_Adder fa2(a[1], b[1], c1, c2, sum[1]);
Full_Adder fa3(a[2], b[2], c2, c3, sum[2]);
Full_Adder fa4(a[3], b[3], c3, cout, sum[3]);
and_gate and2(sum[0], 1'b0, c4);
// and_gate and1(cout, c3, c4);

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
