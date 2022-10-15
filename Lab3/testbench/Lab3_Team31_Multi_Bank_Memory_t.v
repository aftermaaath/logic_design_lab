`timescale 1ns/1ps

module Multi_Bank_Memory_t ();
reg clk;
reg ren, wen;
reg [11-1:0] waddr;
reg [11-1:0] raddr;
reg [8-1:0] din;
wire [8-1:0] dout;

Multi_Bank_Memory bk(
    .clk(clk), 
    .ren(ren), 
    .wen(wen), 
    .waddr(waddr), 
    .raddr(raddr), 
    .din(din), 
    .dout(dout)
);

endmodule
