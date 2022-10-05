`timescale 1ns/1ps

module Ripple_Carry_Adder_t;
reg [7:0] a = 8'b0000_1010;
reg [7:0] b = 8'b0000_0000;
reg cin = 1'b0;
wire cout;
wire [7:0] sum;

Ripple_Carry_Adder ra(
    .a (a),
    .b (b),
    .cin (cin),
    .cout (cout),
    .sum (sum)
);

initial begin
    repeat (2 ** 5) begin
        #1 a = a + 2'b10;
        b = b + 1'b1;
        cin = cin + 1'b1;
//        {a, b, cin} = {a, b, cin} + 1'b1;
    end
    #1 $finish;
end
endmodule
