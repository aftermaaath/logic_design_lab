`timescale 1ns/1ps

`timescale 1ns/1ps

module Memory (clk, ren, wen, addr, din, dout);
input clk;
input ren, wen;
input [7-1:0] addr;
input [8-1:0] din;
output reg [8-1:0] dout = 8'b0;
reg [8-1:0] mem [128-1:0];

always@(posedge clk)begin
    if(ren == 1'b1)begin
        dout = mem[addr];
    end
    else dout = 8'b0;
    if(wen == 1'b1 && ren == 1'b0)begin
        mem[addr] = din;
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

reg [15:0] renb = 16'b0, wenb = 16'b0;
reg [127:0] dinb, doutb, addr;

Memory bk[16-1:0](
    .clk(clk), 
    .ren(renb[15:0]), 
    .wen(wenb[15:0]), 
    .addr(addr[127:0]), 
    .din(dinb[127:0]), 
    .dout(doutb[127:0])
);

always@(posedge clk)begin
    if(ren == 1'b1)begin
        renb = 16'b0;
        renb[raddr[10:7]] = 1'b1;
        dout = doutb[raddr]; // correct?
    end
    else dout = 8'b0;
    if(wen == 1'b1 && waddr != raddr)begin
        wenb = 16'b0;
        wenb[waddr[10:7]] = 1'b1;
        dinb[waddr] = din;
        addr[waddr] = waddr[6:0];
    end
end

endmodule
