`timescale 1ns/1ps

module FIFO_8(clk, rst_n, wen, ren, din, dout, error);
input clk;
input rst_n;
input wen, ren;
input [8-1:0] din;
output reg [8-1:0] dout;
output reg error;
reg [3:0] head = 3'b0, rear = 3'b0, ct = 3'b0;
reg [8-1:0] queue [8-1:0];

always@(posedge clk)begin
    if(rst_n == 1'b0)begin
        dout = 8'b0;
        error = 1'b0;
        head = 3'b0;
        rear = 3'b0;
        ct = 3'b0;
    end
    else begin
        if(ren == 1'b1)begin
            if(ct == 3'b0 || wen == 1'b1) error = 1'b1;
            else begin
                dout = queue[head];
                head = head + 1'b1;
                ct = ct - 1'b1;
                error = 1'b0;
            end
        end
        else if(wen == 1'b1)begin
            if(ct == 3'b111) error = 1'b1;
            else begin
                queue[rear] = din;
                rear = rear + 1'b1;
                ct = ct + 1'b1;
                error = 1'b0;
            end
        end
    end
end

endmodule

module Round_Robin_FIFO_Arbiter(clk, rst_n, wen, a, b, c, d, dout, valid);
input clk;
input rst_n;
input [4-1:0] wen;
input [8-1:0] a, b, c, d;
output reg [8-1:0] dout;
output reg valid;

reg [3:0] ren = 4'b0;
wire [7:0] out [1:0];
wire [3:0] err;
reg [1:0] ct = 2'b0;

FIFO_8 f1(clk, rst_n, wen[0], ren[0], a, out[0], err[0]);
FIFO_8 f2(clk, rst_n, wen[1], ren[1], b, out[1], err[1]);
FIFO_8 f3(clk, rst_n, wen[2], ren[2], c, out[2], err[2]);
FIFO_8 f4(clk, rst_n, wen[3], ren[3], d, out[3], err[3]);

always@(posedge clk)begin
    ct = ct + 1'b1;
end

always@(*)begin
    if(rst_n == 1'b0) ct = 2'b0;
    ren = 1 << ct;
    valid = rst_n == 1'b0 ? 1'b0 : !err[ct];
    dout = valid == 1'b0 ? 8'b0 : out[ct];
end

endmodule
