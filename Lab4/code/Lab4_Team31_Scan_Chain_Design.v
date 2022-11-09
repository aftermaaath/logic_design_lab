`timescale 1ns/1ps

module Scan_Chain_Design(clk, rst_n, scan_in, scan_en, scan_out);
input clk;
input rst_n;
input scan_in;
input scan_en;
output reg scan_out;

reg [7:0] sdff, p;

always@(*)begin
    p = sdff[7:4] * sdff[3:0];
    scan_out = sdff[0];
end

always@(posedge clk)begin
    if(rst_n == 1'b0) sdff <= 8'b0;
    else begin
        if(scan_en == 1'b0) sdff <= p;
        else sdff <= {scan_in, sdff[7:1]};
    end
end

//always@(negedge clk)begin
//    $display("a: %d, b: %d, p: %d, sdff: %b", sdff[7:4], sdff[3:0], p, sdff);
//end

endmodule
