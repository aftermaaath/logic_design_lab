`timescale 1ns/1ps

module Greatest_Common_Divisor (clk, rst_n, start, a, b, done, gcd);
input clk, rst_n;
input start;
input [15:0] a;
input [15:0] b;
output reg done;
output reg [15:0] gcd;

reg [1:0] state, next_state;
reg [15:0] cha, chb, ans;
reg [15:0] lcha, lchb, lans;

parameter WAIT = 2'b00;
parameter CAL = 2'b01;
parameter FIN = 2'b10;
parameter FIN2 = 2'b11;

always@(posedge clk) begin
    if(rst_n == 1'b0) begin 
        state <= 2'b0;
        lcha <= 16'b0;
        lchb <= 16'b0;
        lans <= 16'b0;
    end
    else begin 
        state <= next_state;
        lcha <= cha;
        lchb <= chb;
        lans <= ans;
    end
end

//  output: next_state, cha, chb, gcd, done, ans
always@(*)begin
    case(state)
        WAIT: begin
            if(start == 1'b0) begin
                next_state = WAIT;
                cha = 16'b0;
                chb = 16'b0;
                gcd = 16'b0;
                done = 1'b0;
                ans = 16'b0;
            end
            else begin
                next_state = CAL;
                cha = a;
                chb = b;
                gcd = 16'b0;
                done = 1'b0;
                ans = 16'b0;
            end
        end
        CAL: begin
            if(lcha == 16'b0) begin
                next_state = FIN;
                cha = lcha;
                chb = lchb;
                gcd = 16'b0;
                done = 1'b0;
                ans = lchb;
            end
            else if (lchb == 16'b0) begin
                next_state = FIN;
                cha = lcha;
                chb = lchb;
                gcd = 16'b0;
                done = 1'b0;
                ans = lcha;
            end
            else if(lcha > lchb) begin
                next_state = CAL;
                cha = lcha - lchb;
                chb = lchb;
                gcd = 16'b0;
                done = 1'b0;
                ans = 16'b0;
            end
            else begin
                next_state = CAL;
                cha = lcha;
                chb = lchb - lcha;
                gcd = 16'b0;
                done = 1'b0;
                ans = 16'b0;
            end
        end
        FIN: begin
            next_state = FIN2;
            cha = 16'b0;
            chb = 16'b0;
            gcd = lans;
            done = 1'b1;
            ans = lans;
        end
        default: begin
            next_state = WAIT;
            cha = 16'b0;
            chb = 16'b0;
            gcd = lans;
            done = 1'b1;
            ans = lans;
        end
    endcase
end

endmodule
