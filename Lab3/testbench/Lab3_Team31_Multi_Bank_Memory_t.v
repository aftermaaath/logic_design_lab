`timescale 1ns/1ps

module Multi_Bank_Memory_t ();
reg clk = 1'b0;
reg ren = 1'b0, wen = 1'b1;
reg [11-1:0] waddr = 11'd10;
reg [11-1:0] raddr = 11'b0;
reg [8-1:0] din = 8'd11;
wire [8-1:0] dout;

parameter cyc = 10;
always#(cyc/2)clk = !clk;

Multi_Bank_Memory bk(
    .clk(clk), 
    .ren(ren), 
    .wen(wen), 
    .waddr(waddr), 
    .raddr(raddr), 
    .din(din), 
    .dout(dout)
);

initial begin
    // testbench ver0: 00a/20c 
//    @(negedge clk)
//    raddr = 11'd10;
//    ren = 1'b1;
//    waddr = waddr + 11'd256;
//    din = din + 1'b1;
//    @(negedge clk)
//    ren = 1'b1;
//    waddr = waddr + 11'd256;
//    din = din + 1'b1;
//    @(negedge clk)
//    waddr = waddr + 11'd256;
//    din = din + 1'b1;
//    @(negedge clk)
//    waddr = waddr + 11'd256;
//    din = din + 1'b1;
//    @(negedge clk)
//    waddr = waddr + 11'd256;
//    din = din + 1'b1;
//    @(negedge clk)
//    waddr = waddr + 11'd256;
//    din = din + 1'b1;
    
//    @(negedge clk)
//    waddr = 11'd524;
//    ren = 1'b1;
//    din = din + 1'b1;
//    @(negedge clk)
//    raddr = 11'd524;
//    ren = 1'b1;
//    waddr = waddr + 11'd256;
//    din = din + 1'b1;
//    @(negedge clk)
//    waddr = waddr + 11'd256;
//    din = din + 1'b1;
//    @(negedge clk)
//    waddr = waddr + 11'd256;
//    din = din + 1'b1;
//    @(negedge clk)
//    waddr = waddr + 11'd256;
//    din = din + 1'b1;
//    @(negedge clk)
//    waddr = waddr + 11'd256;
//    din = din + 1'b1;
    
//    // testbench ver1
//    @(negedge clk)
//    waddr = {4'b0100, 7'b0100010};
//    din = 8'd87;
//    ren = 1'b0;
//    wen = 1'b1;
//    @(negedge clk)
//    waddr = {4'b0, 7'b0};
//    raddr = {4'b0100, 7'b0100010};
//    din = 8'd20;
//    ren = 1'b1;
//    wen = 1'b1;
//    @(negedge clk)
//    waddr = {4'b0001, 7'b0};
//    raddr = 11'b0;
//    din = 8'd50;
//    ren = 1'b1;
//    wen = 1'b1;
//    @(negedge clk)
//    waddr = {4'b0100, 7'b0100010};
//    raddr = {4'b0100, 7'b0100010};
//    din = 8'd37;
//    ren = 1'b1;
//    wen = 1'b1;
    
    // testbench ver2: ren = 1'b0
    @(negedge clk)
    waddr = {4'b0100, 7'b0100010};
    din = 8'd87;
    ren = 1'b0;
    wen = 1'b1;
    @(negedge clk)
    waddr = {4'b0, 7'b0};
    raddr = {4'b0100, 7'b0100010};
    din = 8'd20;
    ren = 1'b1;
    wen = 1'b1;
    @(negedge clk)
    waddr = {4'b0001, 7'b0};
    raddr = 11'b0;
    din = 8'd50;
    ren = 1'b0;
    wen = 1'b1;
    @(negedge clk)
    waddr = {4'b0100, 7'b0100010};
    raddr = {4'b0100, 7'b0100010};
    din = 8'd37;
    ren = 1'b0;
    wen = 1'b1;
    
    @(negedge clk)
    $finish;
end

endmodule
