`timescale 1ns/1ps

module FIFO_8(clk, rst_n, wen, ren, din, dout, error);
input clk;
input rst_n;
input wen, ren;
input [8-1:0] din;
output reg [8-1:0] dout;
output reg error;
reg [2:0] head = 3'b0, rear = 3'b0;
reg [3:0] ct = 4'b0; 
reg [8-1:0] queue [8-1:0];

always@(posedge clk)begin
    if(rst_n == 1'b0)begin
        dout <= 8'b0;
        error <= 1'b0;
        head <= 3'b0;
        rear <= 3'b0;
        ct <= 4'b0;
    end
    else begin
        if(ren == 1'b1)begin
            if(ct == 4'b0) error <= 1'b1;
            else begin
                dout <= queue[head];
                head <= head + 1'b1;
                ct <= ct - 1'b1;
                error <= 1'b0;
            end
        end
        else if(wen == 1'b1)begin
            if(ct == 4'b1000) error <= 1'b1;
            else begin
                queue[rear] <= din;
                rear <= rear + 1'b1;
                ct <= ct + 1'b1;
                error <= 1'b0;
            end
        end
    end
end

endmodule
