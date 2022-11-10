`timescale 1ns/1ps

module Many_To_One_LFSR(clk, rst_n, out_msb);
input clk;
input rst_n;
output wire out_msb;

reg [8-1:0] out;
wire [7:0] next_out;
assign next_out = {out[6:0], (out[1] ^ out[2]) ^ (out[3] ^ out[7])};
assign out_msb = out[7];

always@(negedge clk) begin
    if(rst_n == 1'b0) out <= 8'b10111101;
    else out <= next_out;
end

endmodule

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


module Built_In_Self_Test(clk, rst_n, scan_en, scan_in, scan_out);
input clk;
input rst_n;
input scan_en;
output scan_in;
output scan_out;

Many_To_One_LFSR lfsr(clk, rst_n, scan_in);
Scan_Chain_Design scd(clk, rst_n, scan_in, scan_en, scan_out);

endmodule
