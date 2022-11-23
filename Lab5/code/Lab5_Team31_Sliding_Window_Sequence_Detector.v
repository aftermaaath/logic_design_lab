`timescale 1ns/1ps

module Sliding_Window_Sequence_Detector (clk, rst_n, in, dec);
input clk, rst_n;
input in;
output dec;
// output [3:0]st;
// output [3:0]nxt_st;
reg [3:0]st;
reg [3:0]nxt_st;
reg dec;
parameter S0 = 4'd0;
parameter S1 = 4'd1;
parameter S2 = 4'd2;
parameter S3 = 4'd3;
parameter S4 = 4'd4;
parameter S5 = 4'd5;
parameter S6 = 4'd6;
parameter S7 = 4'd7;
always@(posedge clk)begin
    if(!rst_n) st <= S0;
    else st <= nxt_st;
end
always@(*)begin
    case(st)
    S0:begin
        if(in == 1'b1) nxt_st = S1;
        else nxt_st = S0;
        dec = 1'b0;
    end
    S1:begin
        if(in == 1'b1) nxt_st = S2;
        else nxt_st = S0;
        dec = 1'b0;
    end
    S2:begin
        if(in == 1'b1) nxt_st = S3;
        else nxt_st = S0;
        dec = 1'b0;
    end
    S3:begin
        if(in == 1'b1) nxt_st = S3;
        else nxt_st = S4;
        dec = 1'b0;
    end
    S4:begin
        if(in == 1'b1) nxt_st = S1;
        else nxt_st = S5;
        dec = 1'b0;
    end
    S5:begin
        if(in == 1'b1) nxt_st = S6;
        else nxt_st = S0;
        dec = 1'b0;
    end
    S6:begin
        if(in == 1'b1) nxt_st = S7; 
        else nxt_st = S5;
        dec = 1'b0;
    end
    default:begin
        if(in == 1'b1)begin
            nxt_st = S3;  
            dec = 1'b1;                      
        end
        else begin
            nxt_st = S0;
            dec = 1'b0;
        end
    end
    endcase
end
endmodule 