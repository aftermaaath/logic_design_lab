`timescale 1ns/1ps

module Parameterized_Ping_Pong_Counter (clk, rst_n, enable, flip, max, min, direction, out);
input clk, rst_n;
input enable;
input flip;
input [4-1:0] max;
input [4-1:0] min;
output direction;
output [4-1:0] out;
// output hold;

reg direction, next_direction;
reg [3:0]next_out;
reg [3:0]out;
wire hold;

assign hold = ((max<min)||(out>max)||(out<min)||((max == min) && (min == out))) ? 1'b1 : 1'b0;

always@(posedge clk)begin
    if(!rst_n)begin
        direction <= 1'b1;
        out <= min;
    end
    else begin
        direction <= next_direction;
        out <= next_out;
    end
end

always@(*)begin
    if(!enable)begin
        next_direction = direction;
        next_out = out;             
    end
    else begin
        if(!hold)begin
            if(flip) begin
                next_direction = ~direction;
                next_out = (direction == 1'b1) ? out - 1'b1 : out + 1'b1;
            end
            else begin
                if((out < max && direction == 1'b1)||(out == min && direction == 1'b0))begin
                    next_direction = 1'b1;
                    next_out = out + 1'b1;
                end
                else begin
                    next_direction = 1'b0;
                    next_out = out - 1'b1;
                end
            end
        end
        else begin
            next_direction = direction;
            next_out = out;
        end
    end    
end
endmodule
