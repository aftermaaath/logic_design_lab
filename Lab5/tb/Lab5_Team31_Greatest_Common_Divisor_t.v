`timescale 1ns/1ps

module Greatest_Common_Divisor_t ();
reg clk = 1'b0, rst_n = 1'b0;
reg start = 1'b0;
reg [15:0] a = 16'b0;
reg [15:0] b = 16'b0;
wire done;
wire [15:0] gcd;
//wire [1:0] state;

Greatest_Common_Divisor GCD(
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .a(a),
    .b(b),
    .done(done),
    .gcd(gcd)
//    .state(state)
);

always #5 clk = ~clk;

initial begin
    #10 rst_n = 1'b1;
    #10 start = 1'b1; a = 16'd1; b = 16'd1; // 1, 1
    #10 start = 1'b0;
    #40 start = 1'b1; a = 16'd24; b = 16'd196; //  8 + 6, 4
    #10 start = 1'b0; 
    #170 start = 1'b1; a = 16'd10000; b = 16'd625; // 16, 625
    #10 start = 1'b0;
    #190 start = 1'b1; a = 16'd45; b = 16'd200; // 4 + 2 + 4, 5
    #10 start = 1'b0;
    #130 start = 1'b1; a = 16'd36; b = 16'd36; // 1, 36
    #10 start = 1'b0;
    #40 start = 1'b1; a = 16'd128; b = 16'd9; // 14 + 4 + 2, 36
    #10 start = 1'b0;
    #230 $finish;
end

endmodule
