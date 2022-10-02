`timescale 1ns/1ps

module Multiplier_4bit_t;
reg [3:0] a = 4'b0;
reg [3:0] b = 4'b0010;
wire [7:0] p;
Multiplier_4bit mul(
    .a(a),
    .b(b),
    .p(p)
);
initial begin
    repeat(2**3) begin
        #1 a = a+4'b1;
        b = b+4'b1;
    end
    #1 $finish;
end
endmodule