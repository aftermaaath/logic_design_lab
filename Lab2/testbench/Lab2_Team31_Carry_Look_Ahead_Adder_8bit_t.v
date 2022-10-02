`timescale 1ns/1ps

module Carry_Look_Ahead_Adder_8bit_t;
reg [7:0] a = 8'b0;
reg [7:0] b = 8'd10;
reg c0 = 1'b0;
wire [7:0] s;
wire c8;

Carry_Look_Ahead_Adder_8bit CLA(
    .a (a),
    .b (b),
    .c0 (c0),
    .s (s),
    .c8(c8)
);

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
// initial begin
//      $fsdbDumpfile("Carry_Look_Ahead_Adder_8bit.fsdb");
//      $fsdbDumpvars;
// end

initial begin
    repeat (2 ** 3) begin
        #1 c0 = c0+1;
        #1 a = a+8'd30;
        b = b+8'd20;
    end
    #1 $finish;
end
endmodule
