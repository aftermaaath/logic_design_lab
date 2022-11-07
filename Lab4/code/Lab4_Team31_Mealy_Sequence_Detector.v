`timescale 1ns/1ps

module Mealy_Sequence_Detector (clk, rst_n, in, dec);
input clk, rst_n;
input in;
output dec;
//  output [4:0]state;

reg dec;
reg [4:0]state;
reg [4:0]nxt_state;
parameter S0 = 4'd0;
parameter S1 = 4'd1;
parameter S2 = 4'd2;
parameter S3 = 4'd3;
parameter S4 = 4'd4;
parameter S5 = 4'd5;
parameter S6 = 4'd6;
parameter S7 = 4'd7;
parameter S8 = 4'd8;
parameter S9 = 4'd9;
parameter S10 = 4'd10;

always@(posedge clk)begin
    if(!rst_n) state <= S0;
    else state <= nxt_state;
end
always@(*)begin
    case(state)
    S0: begin
        if(in == 1'b0)begin
            nxt_state = S1;
            dec = 1'b0;
        end
        else begin
            nxt_state = S4;
            dec = 1'b0;
        end
    end
    S1:begin
        if(in == 1'b0)begin
            nxt_state = S9;
            dec = 1'b0;
        end
        else begin
            nxt_state = S2;
            dec = 1'b0;
        end
    end
    S2:begin
        if(in == 1'b0)begin
            nxt_state = S10;
            dec = 1'b0;
        end
        else begin
            nxt_state = S3;
            dec = 1'b0;
        end
    end
    S3:begin
        if(in == 1'b0)begin
            nxt_state = S0;
            dec = 1'b0;
        end else begin
            nxt_state = S0;
            dec = 1'b1;
        end
    end
    S4:begin
        if(in == 1'b0)begin
            nxt_state = S7;
            dec = 1'b0;
        end else begin
            nxt_state = S5;
            dec = 1'b0;
        end
    end
    S5:begin
        if(in == 1'b0)begin
            nxt_state = S6;
            dec = 1'b0;
        end else begin
            nxt_state = S10;
            dec = 1'b0;
        end
    end
    S6:begin
        if(in == 1'b0)begin
            nxt_state = S0;
            dec = 1'b1;
        end else begin
            nxt_state = S0;
            dec = 1'b0;
        end
    end
    S7:begin
        if(in == 1'b0)begin
            nxt_state = S10;
            dec = 1'b0;
        end else begin
            nxt_state = S8;
            dec = 1'b0;
        end
    end
    S8:begin
        if(in == 1'b0)begin
            nxt_state = S0;
            dec = 1'b0;
        end else begin
            nxt_state = S0;
            dec = 1'b1;
        end
    end
    S9:begin
        nxt_state = S10;
        dec = 1'b0;
    end
    default:begin
        nxt_state = S0;
        dec = 1'b0;
    end
    endcase
end
endmodule