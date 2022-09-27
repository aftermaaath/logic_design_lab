`timescale 1ns/1ps

module Toggle_Flip_Flop(clk, q, t, rst_n);
input clk;
input t;
input rst_n;
output q;

wire not_q, not_t, and_q, and_t, xor_out;
wire and_out;

// xor_gate
not Not1(not_q, q);
not Not2(not_t, t);
and And1(and_q, not_t, q);
and And2(and_t, not_q, t);
or Or1(xor_out, and_q, and_t);

// and_gate
and And3(and_out, rst_n, xor_out);

// DFF
D_Flip_Flop DFF(clk, and_out, q);

endmodule

module D_Flip_Flop(clk, d, q);
input clk;
input d;
output q;

wire n_clk, tmp;
not Not1(n_clk, clk);
D_Latch master_latch(n_clk, d, tmp);
D_Latch slave_latch(clk, tmp, q);

endmodule

module D_Latch(clk, d, tmp);
input clk;
input d;
output tmp;

wire nand1_out, not_d, nand2_out, nand3_out;

not nd(not_d, d);
nand nand1(nand1_out, d, clk);
nand nand2(nand2_out, not_d, clk);
nand nand3(tmp, nand1_out, nand3_out);
nand nand4(nand3_out, nand2_out, tmp);

endmodule