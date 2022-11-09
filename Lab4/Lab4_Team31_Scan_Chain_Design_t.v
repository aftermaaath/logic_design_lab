`timescale 1ns/1ps

module Scan_Chain_Design_t();
reg clk = 1'b0;
reg rst_n = 1'b0;
reg scan_in = 1'b0;
reg scan_en = 1'b0;
wire scan_out;

always #5 clk = ~clk;
Scan_Chain_Design scd(
    .clk(clk),
    .rst_n(rst_n),
    .scan_in(scan_in),
    .scan_en(scan_en),
    .scan_out(scan_out)
);

initial begin
    #10 rst_n = 1'b1;
    scan_en = 1'b1;
    scan_in = scan_in + 1'b1;
    repeat (8) begin
        #10 scan_in = scan_in + 1'b1;
    end
    scan_en = 1'b0;
    #10 scan_en = 1'b1;
    #80 scan_en = 1'b0;
    
    #10 scan_en = 1'b1;
    scan_in = scan_in + 1'b1;
    repeat (8) begin
        #10 scan_in = $random;
    end
    scan_en = 1'b0;
    #10 scan_en = 1'b1;
    
    #80 $finish;
end

endmodule
