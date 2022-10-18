`timescale 1ns/1ps

module Ping_Pong_Counter (clk, rst_n, enable, direction, out);
input clk, rst_n;
input enable;
output direction;
output [4-1:0] out;

reg [3:0]out;
reg [3:0]next_out;
reg direction, next_direction;

always@(posedge clk)begin
    out <= next_out;
    direction <= next_direction;     
end

always@(*) begin
    if(!rst_n)begin
        next_out = 4'b0;
        next_direction = 1'b1;
    end
    else begin
        if(!enable)begin
            next_out = out;
            next_direction = direction;
        end
        else begin
            if((direction == 1 && out<4'b1111) || (direction == 0 && out == 4'b0)) begin
                next_out = out+1'b1;
                next_direction = 1'b1;
            end
            else begin
                next_out = out-1'b1;
                next_direction = 1'b0;
            end
        end
    end
end

endmodule
