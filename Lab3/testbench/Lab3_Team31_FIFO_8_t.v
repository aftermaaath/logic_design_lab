`timescale 1ns/1ps

module FIFO_8_t();
reg clk = 1'b1;
reg rst_n = 1'b0;
reg wen = 1'b0, ren = 1'b0;
reg [8-1:0] din = 8'b0;
wire [8-1:0] dout;
wire error;

parameter cyc = 10;
always#(cyc/2)clk = !clk;

FIFO_8 fifo(
    .clk(clk),
    .rst_n(rst_n),
    .wen(wen),
    .ren(ren),
    .din(din),
    .dout(dout),
    .error(error)
);

initial begin
    @(negedge clk) rst_n = 1'b0;
    @(negedge clk) rst_n = 1'b1;
    @(negedge clk)
    din = 8'd22;
    ren = 1'b0;
    wen = 1'b1;
    @(negedge clk) din = 8'd11;
    @(negedge clk) din = 8'd34;
    @(negedge clk) din = 8'd28;
    @(negedge clk) din = 8'd10;
    @(negedge clk) din = 8'd33;
    @(negedge clk) din = 8'd23;
    @(negedge clk) din = 8'd27;
    @(negedge clk) din = 8'd15;
    @(negedge clk)
    ren = 1'b1;
    wen = 1'b1;
    @(negedge clk)
    wen = 1'b0;
    @(negedge clk)
    @(negedge clk)
    @(negedge clk)
    @(negedge clk) rst_n = 1'b0;
    @(negedge clk) 
    rst_n = 1'b1;
    ren = 1'b1;
    @(negedge clk) 
    din = 8'd11;
    ren = 1'b0;
    wen = 1'b1;
    @(negedge clk) din = 8'd13;
    @(negedge clk) din = 8'd34;
    @(negedge clk)
    ren = 1'b1;
    wen = 1'b1;
    din = 8'd36;
//    @(negedge clk) repeat (2 ** 3) begin
//        #(cyc)
//        din = $random % 256;
//        ren = $random % 2;
//        wen = $random % 2;
//    end
//    @(negedge clk) rst_n = 1'b0;
//    @(negedge clk) rst_n = 1'b1;
//    @(negedge clk) repeat (2 ** 3) begin
//        #(cyc)
//        din = $random % 256;
//        ren = $random % 2;
//        wen = $random % 2;
//    end
    @(negedge clk)
    #1 $finish;
end

endmodule
