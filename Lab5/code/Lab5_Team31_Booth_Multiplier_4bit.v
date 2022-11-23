`timescale 1ns/1ps 

module Booth_Multiplier_4bit(clk, rst_n, start, a, b, p);
input clk;
input rst_n; 
input start;
input signed [3:0] a, b;
output reg signed [7:0] p;

reg [1:0] state, next_state;
reg [9:0] ans, lans, rsans;
reg [9:0] A, S, lA, lS;
reg [1:0] ct, lct;

wire signed [4:0] exa;
wire [3:0] exb;
assign exa = a;
assign exb = b;

parameter WAIT = 2'b00;
parameter CAL = 2'b01;
parameter FIN = 2'b10;
parameter FIN2 = 2'b11;

always@(posedge clk) begin
    if(rst_n == 1'b0) begin
        state <= 2'b0;
        lans <= 10'b0;
        rsans <= 10'b0;
        lct <= 2'b0;
        lA <= 10'b0;
        lS <= 10'b0;
    end
    else begin
        state <= next_state;
        lans <= ans;
        rsans <= {ans[9], ans[9:1]};
        lct <= ct;
        lA <= A;
        lS <= S;
    end
end

//  output: next_state, p, ans, A, S, ct
always@(*)begin
    case(state)
        WAIT: begin
            if(start == 1'b0) begin
                next_state = WAIT;
                p = 8'b0;
                ans = 10'b0;
                A = 10'b0;
                S = 10'b0;
                ct = 2'b0;
            end
            else begin
                next_state = CAL;
                p = 8'b0;
                ans = exb << 2;
                A = exa << 5;
                S = (-exa) << 5;
                ct = 2'b0;
            end
        end
        CAL: begin           
            next_state = lct == 2'b11 ? FIN : CAL;
            ct = lct + 1'b1;
            p = 8'b0;
            A = lA;
            S = lS;
            if(rsans[1:0] == 2'b01) ans = rsans + lA;
            else if(rsans[1:0] == 2'b10) ans = rsans + lS;
            else ans = rsans;
        end
        FIN: begin
            next_state = FIN2;
            p = rsans[8:1];
            ans = lans;
            A = 10'b0;
            S = 10'b0;
            ct = 2'b0;
        end
        default: begin
            next_state = WAIT;
            p = rsans[8:1];
            ans = lans;
            A = 10'b0;
            S = 10'b0;
            ct = 2'b0;
        end
    endcase
end

endmodule
