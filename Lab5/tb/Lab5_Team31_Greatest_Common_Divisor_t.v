`timescale 1ns/1ps

module Greatest_Common_Divisor_t ();
reg clk = 1'b0, rst_n = 1'b0;
reg start = 1'b0;
reg [15:0] a = 16'b0;
reg [15:0] b = 16'b0;
wire done;
wire [15:0] gcd;
// wire [1:0] state;

Greatest_Common_Divisor GCD(
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .a(a),
    .b(b),
    .done(done),
    .gcd(gcd)
    // .state(state)
);

always #5 clk = ~clk;

initial begin
    #10 rst_n = 1'b1;
    #10 start = 1'b1;
//    repeat(5) begin
//        #60
//        a = $random % 101;
//        a = a > 16'd60000 ? a + 16'd101 : a;
//        b = $random % 101;
//        b = b > 16'd60000 ? b + 16'd101 : b;
//    end
//    #60 rst_n = 1'b0;
//    start = 1'b0;
    #10 rst_n = 1'b1;
    #10 start = 1'b1;
    a = 16'd1; b = 16'd1; start = 1'b0; // 1, 1
    #60 start = 1'b1; a = 16'd24; b = 16'd196; //  8 + 6, 4
    #20 start = 1'b0; 
    #150 start = 1'b1; a = 16'd10000; b = 16'd625; // 16, 625
    #20 start = 1'b0;
    #190 start = 1'b1; a = 16'd45; b = 16'd200; // 4 + 2 + 4, 5
    #130 $finish;
end

endmodule
