`timescale 1ns/1ps

module Universal_Gate(a, b, out);
input a, b;
output out;
wire nb;

not n1(nb, b);
and a1(out, a, nb);

endmodule