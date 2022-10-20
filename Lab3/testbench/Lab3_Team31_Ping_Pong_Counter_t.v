`timescale 1ns/1ps

module Ping_Pong_Counter_t;
reg clk = 1'b0;
reg rst_n = 1'b0;
reg enable = 1'b1;
wire direction;
wire [3:0]out;

Ping_Pong_Counter ppc(
    .clk(clk),
    .rst_n(rst_n),
    .enable(enable),
    .direction(direction),
    .out(out)
);

always #10 clk = ~clk;

initial begin
    #15
    rst_n = 1'b1;
    #10
    enable = 1'b0;
    #9
    enable = 1'b1;
    rst_n = 1'b0;
    #8
    repeat(2**2)begin
        #15 enable = ~enable;
    end
    repeat(2**2)begin
        #15 rst_n = ~rst_n;
    end
    #5
    rst_n = 1'b1;
    #285
    enable = 1'b0;
    #25
    enable = 1'b1;
    #5
    rst_n = 1'b0;
    #25
    rst_n = 1'b1;
    #25
    rst_n = 1'b0;
    enable = 1'b0;
    #35
    rst_n = 1'b1;
    enable = 1'b1;
    #700
    $finish;
end
endmodule