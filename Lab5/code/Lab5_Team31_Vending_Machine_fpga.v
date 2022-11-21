`timescale 1ns/1ps

module Vending_Machine_display(clk, rst_n, in, cancel, an, seg, drinks, PS2_CLK, PS2_DATA); // module for 7-seg display and keybord
input clk, rst_n, cancel;
inout PS2_CLK, PS2_DATA;
input [2:0]in;
output [3:0]drinks;
output [3:0]an;
output [6:0]seg;
reg [3:0]an;
reg [6:0]seg;
wire [7:0]money;
wire [3:0]drinks;
wire div_clk, seg_clk;
wire rst_n_db, rst_op;
wire [2:0]in_db;
wire [2:0]in_op;
wire cancel_db, cancel_op;
reg [3:0]digit_display;
reg [3:0]b_drink;
wire [511:0]key_down;
wire [8:0]last_change;
wire key_valid;
reg [3:0]nxt_b_drink;
reg [3:0]nxt_b_drink_1;
reg [1:0]cnt;
wire[1:0]nxt_cnt;
reg cancel_delay, b, b_delay;
reg [7:0]cost;
reg [7:0]nxt_cost, nxt_cost_1;

assign nxt_cnt = cnt+1'b1;

parameter KEY_CODES_A = {1'h0, 4'h1, 4'hc}; // coffee
parameter KEY_CODES_S = {1'h0, 4'h1, 4'hb}; // coke
parameter KEY_CODES_D = {1'h0, 4'h2, 4'h3}; // oolong
parameter KEY_CODES_F = {1'h0, 4'h2, 4'hb}; // water

debounce db1(rst_n_db, rst_n, clk);
onepulse_1 op1(rst_n_db, clk, rst_op);
debounce db2(in_db[0], in[0], clk);
onepulse_1 op2(in_db[0], clk, in_op[0]);
debounce db3(in_db[1], in[1], clk);
onepulse_1 op3(in_db[1], clk, in_op[1]);
debounce db4(in_db[2], in[2], clk);
onepulse_1 op4(in_db[2], clk, in_op[2]);
debounce db5(cancel_db, cancel, clk);
onepulse_1 op5(cancel_db, clk, cancel_op);
clk_div cd(rst_op, clk, div_clk, seg_clk, b_delay, cancel_delay);
KeyboardDecoder kd(key_down, last_change, key_valid, PS2_DATA, PS2_CLK, rst_op, clk);
Vending_Machine vm(clk, div_clk, rst_op, in_op, cancel_delay, drinks, money, b_drink, cost, b_delay);
always@(posedge clk)begin
    if(cancel_op == 1'b1) cancel_delay <= 1'b1;
    else if(money > 7'd0 && cancel_delay == 1'b1) cancel_delay <= 1'b1;
    else cancel_delay <= 1'b0;
end
always@(posedge clk)begin
    if (rst_n) begin
            digit_display <= 4'b0000;
            cnt <= 2'b11;
            an <= 4'b1110;
        end
    else begin
        if (seg_clk) begin
            case (cnt)
                2'b00 : begin
                    if(money<7'd10) digit_display <= 4'd10;
                    else begin
                        if(money == 7'd100) digit_display <= 7'd0;
                        else digit_display <= money/7'd10;
                    end
                    an <= 4'b1101;
                    cnt <= nxt_cnt;
                end
                2'b01 : begin
                    if(money<7'd100) digit_display <= 4'd10;
                    else digit_display <= money / 7'd100;
                    an <= 4'b1011;
                    cnt <= nxt_cnt;
                end
                2'b10 : begin
                    digit_display <= money - (money/7'd10)*7'd10;
                    an <= 4'b1110;
                    cnt <= nxt_cnt;
                end
                default : begin
                    digit_display <= 4'd10;
                    an <= 4'b1111;
                    cnt <= nxt_cnt;
                end				
            endcase
        end 
        else begin
            digit_display <= digit_display;
            an <= an;
            cnt <= cnt;
        end
    end
end
always@(*)begin
    case(digit_display)
        4'd0: seg = 7'b0000001;
        4'd1: seg = 7'b1001111;
        4'd2: seg = 7'b0010010;
        4'd3: seg = 7'b0000110;
        4'd4: seg = 7'b1001100;
        4'd5: seg = 7'b0100100;
        4'd6: seg = 7'b0100000;
        4'd7: seg = 7'b0001111;
        4'd8: seg = 7'b0000000;
        4'd9: seg = 7'b0000100;
        default: seg = 7'b1111111; // show nothing
    endcase
end
always@(posedge clk)begin
    if(rst_n || money == 7'b0) begin
        b_drink <= 4'b0;
        cost <= 8'b0;
    end
    else begin
        b_drink <= nxt_b_drink_1;
        cost <= nxt_cost_1;
    end
end
always@(posedge clk)begin
    if(b == 1'b1) b_delay <= 1'b1;
    else if(money > 7'd0 && b_delay == 1'b1) b_delay <= 1'b1;
    else b_delay <= 1'b0;
end
always@(*)begin
    if(key_valid && key_down[last_change] == 1'b1 && nxt_b_drink!=4'b0)begin // a key is pressed
        nxt_b_drink_1 = nxt_b_drink;
        nxt_cost_1 = nxt_cost;
        b = 1'b1;
    end
    else begin
        nxt_b_drink_1 = 4'b0;
        b = 1'b0;
        nxt_cost_1 = 8'b0;
    end
end
always@(*)begin
    case(last_change)
            KEY_CODES_A: begin
                if(drinks[3] == 1'b1)begin 
                    nxt_b_drink = 4'b1000;
                    nxt_cost = 8'd80;
                end
                else begin
                    nxt_b_drink = 4'b0;
                    nxt_cost = 8'd0;
                end
            end
            KEY_CODES_S: begin
                if(drinks[2] == 1'b1)begin
                    nxt_b_drink = 4'b0100;
                    nxt_cost = 8'd30;
                end
                else begin
                    nxt_b_drink = 4'b0;
                    nxt_cost = 8'd0;
                end
            end
            KEY_CODES_D: begin
                if(drinks[1] == 1'b1)begin
                    nxt_b_drink = 4'b0010;
                    nxt_cost = 8'd25;
                end
                else begin
                    nxt_b_drink = 4'b0;
                    nxt_cost = 8'd0;
                end
            end
            KEY_CODES_F: begin
                if(drinks[0] == 1'b1)begin
                    nxt_b_drink = 4'b0001;
                    nxt_cost = 8'd20;
                end
                else begin
                    nxt_b_drink = 4'b0;
                    nxt_cost = 8'd0;
                end
            end
            default: begin
                nxt_b_drink = 4'b0;
                nxt_cost = 8'd0;
            end
    endcase
end
endmodule

module Vending_Machine(clk, div_clk, rst_n, in, cancel, drinks, money, b_drink, cost, b); // module for finding state and available drinks
input clk, div_clk, rst_n, cancel, b;
input [2:0]in; // 5, 10, 50
input [3:0]b_drink;
input [7:0]cost;
output [7:0]money; // how many dollars were inserted
output [3:0]drinks; // what can buy
reg [7:0]money;
reg [7:0]nxt_money;
reg [7:0]st;
reg [7:0]nxt_st;
reg[3:0]drinks;
wire [6:0]dol;
parameter S0 = 8'd0;
parameter S1 = 8'd20;
parameter S2 = 8'd25;
parameter S3 = 8'd30;
assign dol = (in == 3'b001 ? 7'd50 : ((in == 3'b010) ? 7'd10 : ((in == 3'b100) ? 7'd5 : 7'd0)));
always@(posedge clk)begin
    if(rst_n) begin
        st<=S0;
        money <= 8'd0;
    end
    else begin
        money <= nxt_money;
        st<=nxt_st;
    end
end

always@(*)begin
    if(!b && !cancel)begin // insert money
        case(st)
        S0:begin
            if(money+dol>=8'd20)begin
                nxt_st = S1;
                drinks = 4'b0001;
            end else begin
                nxt_st = S0;
                drinks = 4'b0000;
            end
        end
        S1:begin
            if(money+dol>=8'd25)begin
                nxt_st = S2;
                drinks = 4'b0011;
            end else begin
                nxt_st = S1;
                drinks = 4'b0001;
            end
        end
        S2:begin
            if(money+dol>=8'd30)begin
                nxt_st = S3;
                drinks = 4'b0111;
            end else begin
                nxt_st = S2;
                drinks = 4'b0011;
            end
        end
        S3:begin
            nxt_st = S3;
            if(money+dol>=8'd80) drinks = 4'b1111;
            else drinks = 4'b0111;
        end
        endcase
        nxt_money = money+dol<8'd100 ? money+dol : 8'd100;
    end
    else begin // bought
        nxt_st = S0;
        drinks = 4'b0;
        if(div_clk) nxt_money = (money>0)?money-7'd5:7'd0; // return 5 dollars every second
        else nxt_money = money>=cost?money-cost:money;
    end    
end
endmodule
module clk_div(rst_n, clk, div_clk, seg_clk, en, cel_delay); // div_clk for return money, seg_clk for segment display
input rst_n, clk, en, cel_delay;
output div_clk, seg_clk;
wire [26:0]nxt_cnt;
wire [15:0]nxt_cnt_1;
reg [26:0]cnt;
reg [15:0]cnt_1;
reg div_clk, seg_clk;
assign nxt_cnt = cnt+1;
assign nxt_cnt_1 = cnt_1+1;

always@(posedge clk)begin
    if(rst_n)begin
        cnt <= 27'b0;
        cnt_1 <= 16'b0;
        div_clk <= 1'b0;
        seg_clk <= 1'b0;
    end
    else begin
        if(en || cel_delay)begin
            if(cnt == 2**26-1'b1) begin
                div_clk <= 1'b1;
                cnt <= 27'b0;
            end else begin
                div_clk <= 1'b0;
                cnt <= nxt_cnt;
            end
        end
        else begin
            div_clk <= 1'b0;
            cnt <= 27'b0;
        end
        
        if(cnt_1 == 2**15-1'b1) begin
            seg_clk <= 1'b1;
            cnt_1 <= 16'b0;
        end
        else begin
            seg_clk <= 1'b0;
            cnt_1 <= nxt_cnt_1;
        end
    end
end
endmodule
module debounce(pb_debounce, pb, clk);
input pb;
input clk;
output pb_debounce;

reg [3:0]DFF;
always@(posedge clk)begin
    DFF[3:1]<=DFF[2:0];
    DFF[0]<=pb;
end

assign pb_debounce = (DFF == 4'b1111) ? 1'b1 : 1'b0;
endmodule
module onepulse_1(pb_debounced, clk, pb_one_pulse);
input pb_debounced;
input clk;
output pb_one_pulse;
reg pb_debounced_delay;
reg pb_one_pulse_reg;
wire pb_one_pulse = pb_one_pulse_reg;

always@(posedge clk)begin    
    pb_debounced_delay <= pb_debounced;
    pb_one_pulse_reg <= pb_debounced & (!pb_debounced_delay);
end
endmodule