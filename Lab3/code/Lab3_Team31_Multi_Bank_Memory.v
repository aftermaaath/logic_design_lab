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

module Multi_Bank_Memory (clk, ren, wen, waddr, raddr, din, dout);
input clk;
input ren, wen;
input [11-1:0] waddr;
input [11-1:0] raddr;
input [8-1:0] din;
output reg [8-1:0] dout;

reg [15:0] renb, wenb;
reg [127:0] dinb;
wire [127:0] doutb;
reg [111:0] addr;

Memory bk[16-1:0](
    .clk({16{clk}}), 
    .ren(renb[15:0]), 
    .wen(wenb[15:0]), 
    .addr(addr[111:0]), 
    .din(dinb[127:0]), 
    .dout(doutb[127:0])
);

always@(*)begin
    if(ren == 1'b0) renb = 16'b0;
    else  renb = 1 << raddr[10:7];
    if(wen == 1'b0) wenb = 16'b0;
    else  wenb = 1 << waddr[10:7];
    
    dout = doutb[raddr[10:7] * 8 +:8];
    addr[raddr[10:7] * 7 +:7] = raddr[6:0];
    
    if(wen == 1'b1 && ({waddr[10:7]} != {raddr[10:7]} || ren == 1'b0))begin
        addr[waddr[10:7] * 7 +:7] = waddr[6:0];
        dinb[waddr[10:7] * 8 +:8] = din;
    end
end

endmodule
