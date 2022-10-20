`timescale 1ns/1ps

module Memory (clk, ren, wen, addr, din, dout);
input clk;
input ren, wen;
input [7-1:0] addr;
input [8-1:0] din;
output [8-1:0] dout;
reg [8-1:0] mem [128-1:0];
reg [8-1:0] dout = 8'b0;

always@(posedge clk)begin
    if(ren == 1'b1)begin
        dout <= mem[addr];
    end
    else dout <= 8'b0;
    if(wen == 1'b1 && ren == 1'b0)begin
        mem[addr] <= din;
    end
end
endmodule

module Bank(clk, ren, wen, raddr, waddr, din, dout);
input clk, ren, wen;
input [8:0] raddr, waddr;
input [7:0] din;
output wire [7:0] dout;

reg [3:0] renm, wenm;
reg [6:0] addr [3:0];
wire [7:0] doutm [3:0];

assign dout = doutm[0] | doutm[1] | doutm[2] | doutm[3];

Memory m1(clk, renm[0], wenm[0], addr[0], din, doutm[0]);
Memory m2(clk, renm[1], wenm[1], addr[1], din, doutm[1]);
Memory m3(clk, renm[2], wenm[2], addr[2], din, doutm[2]);
Memory m4(clk, renm[3], wenm[3], addr[3], din, doutm[3]);

always@(*)begin
    if(ren == 1'b0) renm = 4'b0;
    else renm = 1 << raddr[8:7];
    if(wen == 1'b0) wenm = 4'b0;
    else wenm = 1 << waddr[8:7];
    
    addr[0] = renm[0] == 1'b1 ? raddr[6:0] : waddr[6:0];
    addr[1] = renm[1] == 1'b1 ? raddr[6:0] : waddr[6:0];
    addr[2] = renm[2] == 1'b1 ? raddr[6:0] : waddr[6:0];
    addr[3] = renm[3] == 1'b1 ? raddr[6:0] : waddr[6:0];
end

endmodule

module Multi_Bank_Memory (clk, ren, wen, waddr, raddr, din, dout);
input clk;
input ren, wen;
input [11-1:0] waddr;
input [11-1:0] raddr;
input [8-1:0] din;
output wire [8-1:0] dout;

reg [3:0] renb, wenb;
wire [7:0] doutb [3:0];

assign dout = doutb[0] | doutb[1] | doutb[2] | doutb[3]; 

Bank bk1(clk, renb[0], wenb[0], raddr[8:0], waddr[8:0], din, doutb[0]);
Bank bk2(clk, renb[1], wenb[1], raddr[8:0], waddr[8:0], din, doutb[1]);
Bank bk3(clk, renb[2], wenb[2], raddr[8:0], waddr[8:0], din, doutb[2]);
Bank bk4(clk, renb[3], wenb[3], raddr[8:0], waddr[8:0], din, doutb[3]);

always@(*)begin
    if(ren == 1'b0) renb = 4'b0;
    else renb = 1 << raddr[10:9];
    if(wen == 1'b0) wenb = 4'b0;
    else wenb = 1 << waddr[10:9];
end

endmodule
