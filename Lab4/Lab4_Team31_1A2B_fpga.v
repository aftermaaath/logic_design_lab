`timescale 1ns/1ps

module fpga_1A2B(clk, start_btn, rst_btn, enter_btn, num, an, seg, ans);
input start_btn, rst_btn, enter_btn, clk;
input [3:0] num;
output reg [3:0] an;
output reg [6:0] seg;
output reg [15:0] ans;

parameter num_0 = 7'b0000001;
parameter num_1 = 7'b1001111;
parameter num_2 = 7'b0010010;
parameter num_3 = 7'b0000110;
parameter num_4 = 7'b1001100;
parameter num_5 = 7'b0100100;
parameter num_6 = 7'b0100000;
parameter num_7 = 7'b0001111;
parameter num_8 = 7'b0000000;
parameter num_9 = 7'b0000100;
parameter alp_a = 7'b0001000;
parameter alp_b = 7'b1100000;

reg [6:0] next_seg, seg3, seg2, seg1, seg0; // 7-segment display
//reg [6:0] pre_seg3, pre_seg2, pre_seg1, pre_seg0; // previous phase seg value
wire [15:0] guess; // answer guessed by player
wire [15:0] cur_ans; // hold value for answer
wire [3:0] res_a, res_b; // 'A' and 'B' for 1A2B game
wire [6:0] seg_a, seg_b; // segment for above a and b
wire [6:0] hd_seg3, hd_seg2, hd_seg1, hd_seg0; // hold value for segs
wire [6:0] seg_cur; //  the seg that being control by switches
wire start_db, rst_db, enter_db;
wire start_op, rst_op, enter_op;
reg start_hd, enter_hd; // hold value for buttons after being push until the phase change
wire rst;
wire div_clk, fli_clk; // clk for segment display / clk for flicker / clk for module
wire [15:0] gen_out; // current generate output by LFSR
reg flicker;
wire wflicker; // wire for flicker

reg [1:0] ct;
wire [1:0] next_ct;
reg [2:0] phase, next_phase;
wire [2:0] cur_phase, wnext_phase;

assign next_ct = ct + 1'b1;
assign rst = ~rst_op;
assign wflicker = flicker;
assign cur_ans = ans;
assign cur_phase = phase;
assign wnext_phase = next_phase;
assign hd_seg3 = seg3;
assign hd_seg2 = seg2;
assign hd_seg1 = seg1;
assign hd_seg0 = seg0;

debounce db1(start_db, start_btn, clk);
debounce db2(rst_db, rst_btn, clk);
debounce db3(enter_db, enter_btn, clk);
onepulse op1(start_op, start_db, clk);
onepulse op2(rst_op, rst_db, clk);
onepulse op3(enter_op, enter_db, clk);

Clock_Divider cd(clk, div_clk, fli_clk);
input_to_seg itos(num, seg_cur); // turn input num(input by switches) into seg
seg_to_input stoi(guess, hd_seg3, hd_seg2, hd_seg1, hd_seg0); // turn 4-digit seg into 16 bits number
ans_check ac(res_a, res_b, ans, guess);
input_to_seg intosa(res_a, seg_a); // turn value of 'A' into seg
input_to_seg intosb(res_b, seg_b); // turn value of 'B' into seg
// generate answer
LFSR lfsr(clk, rst, gen_out);

always@(posedge clk) begin
    if(fli_clk) flicker <= ~flicker;
    else flicker <= wflicker; 
end

always@(posedge clk) begin
    if(rst == 1'b0) begin
        seg3 <= num_1;
        seg2 <= alp_a;
        seg1 <= num_2;
        ans <= 16'b0;
    end
    else if(start_op) begin
        if(next_phase == 3'd1) begin
            seg3 <= num_0;
            seg2 <= num_0;
            seg1 <= num_0;
            ans <= cur_phase == 3'd0 ? gen_out : cur_ans;
        end
        else begin
            seg3 <= hd_seg3;
            seg2 <= hd_seg2;
            seg1 <= hd_seg1;
            ans <= cur_ans;
        end
    end
    else if(enter_op) begin
        if(next_phase == 3'd1) begin
            seg3 <= num_0;
            seg2 <= num_0;
            seg1 <= num_0;
            ans <= cur_ans;
        end
        else if(next_phase == 3'd0) begin
            seg3 <= hd_seg3;
            seg2 <= hd_seg2;
            seg1 <= hd_seg1;
            ans <= cur_ans;
        end
        else if(next_phase == 3'd5) begin
            seg3 <= seg_a;
            seg2 <= alp_a;
            seg1 <= seg_b;
            ans <= cur_ans;
        end
        else begin
            seg3 <= seg2;
            seg2 <= seg1;
            seg1 <= seg_cur;
            ans <= cur_ans;
        end
    end
    else begin
        seg3 <= hd_seg3;
        seg2 <= hd_seg2;
        seg1 <= hd_seg1;
        ans <= cur_ans;
    end
end

always@(posedge clk) begin
    if(rst == 1'b0) phase <= 3'd0;
    else phase <= next_phase;
end

always@(posedge clk) begin
    if(rst == 1'b0) begin
        ct <= 2'b0;
        an <= 4'b0;
    end
    else begin
        if(div_clk) begin
            ct <= next_ct;
            seg <= next_seg;
            if(ct == 2'b0) an <= 4'b1110;
            else if(ct == 2'b01) an <= 4'b1101;
            else if(ct == 2'b10) an <= 4'b1011;
            else an <= 4'b0111;
        end
    end
end

always@(*)begin
    case(ct)
        2'b01: next_seg = seg1;
        2'b10: next_seg = seg2;
        2'b11: next_seg = seg3;
        default: next_seg = seg0;
    endcase
end

// 'output' for state: next_phase, seg0
always@(*)begin
    case(phase)
        3'd0: begin
            if(start_op) begin
                next_phase = 3'd1;
                seg0 = flicker ? 7'b1111111 : seg_cur;
            end
            else begin
                next_phase = 3'd0;
                seg0 = alp_b; 
            end
        end
        3'd1: begin
            if(enter_op) begin
                next_phase = 3'd2;
                seg0 = flicker ? 7'b1111111 : seg_cur;
            end
            else begin
                next_phase = 3'd1;
                seg0 = flicker ? 7'b1111111 : seg_cur;
            end
        end
        3'd2: begin
            if(enter_op) begin
                next_phase = 3'd3;
                seg0 = flicker ? 7'b1111111 : seg_cur;
            end
            else begin
                next_phase = 3'd2;
                seg0 = flicker ? 7'b1111111 : seg_cur;
            end
        end
        3'd3: begin
            if(enter_op) begin
                next_phase = 3'd4;
                seg0 = flicker ? 7'b1111111 : seg_cur;
            end
            else begin
                next_phase = 3'd3;
                seg0 = flicker ? 7'b1111111 : seg_cur;
            end
        end
        3'd4: begin
            if(enter_op) begin
                next_phase = 3'd5;
                seg0 = flicker ? 7'b1111111 : seg_cur;
            end
            else begin
                next_phase = 3'd4;
                seg0 = flicker ? 7'b1111111 : seg_cur;
            end
        end
        3'd5: begin
            if(enter_op) begin
                if(hd_seg3 == num_4) begin
                    next_phase = 3'd0;
                    seg0 = alp_b;
                end
                else begin
                    next_phase = 3'd1;
                    seg0 = flicker ? 7'b1111111 : seg_cur;
                end
            end
            else begin
                next_phase = 3'd5;
                seg0 = alp_b;
            end
        end
    endcase
end

endmodule

module LFSR(clk, rst_n, valid_out);
input clk;
input rst_n;
output wire [15:0] valid_out;
reg [15:0] out;

wire [3:0] dg3, dg2, dg1, dg0;
reg [3:0] vdg3, vdg2, vdg1, vdg0;
assign dg3 = out[15:12] % 10;
assign dg2 = out[11:8] % 10;
assign dg1 = out[7:4] % 10;
assign dg0 = out[3:0] % 10;
assign valid_out = {vdg3, vdg2, vdg1, vdg0};

// sdff generate
wire [15:0] next_out;
wire gen_out0;
xnor(gen_out0, out[3], out[12], out[14], out[15]);
assign next_out = {out[14:0], gen_out0};

always@(posedge clk) begin
    if(rst_n == 1'b0) out <= 16'b0;
    else out <= next_out;
end

// verify
always@(*)begin
    // dg3
    vdg3 = dg3;
    // dg2 != dg3
    if(dg2 == vdg3) vdg2 = (vdg3 + 1'b1) % 10;
    else vdg2 = dg2;
    // dg1 != dg2 && dg1 != dg3
    if(dg1 != vdg2 && dg1 != vdg3) vdg1 = dg1;
    else begin
        if(dg1 == vdg2) begin
            if((vdg2 + 1'b1) % 10 == vdg3) vdg1 = (vdg3 + 1'b1) % 10;
            else vdg1 = vdg2 + 1'b1;
        end
        else begin
            if((vdg3 + 2'b11) % 10 == vdg2) vdg1 = (vdg3 + 2'b10) % 10;
            else vdg1 = vdg3 + 2'b11;
        end
    end
    // dg0 != dg1 && dg0 != dg2 && dg0 != dg3
    if(dg0 != vdg1 && dg0 != vdg2 && dg0 != vdg3) vdg0 = dg0;
    else begin
        if(4'd4 != vdg1 && 4'd4 != vdg2 && 4'd4 != vdg3) vdg0 = 4'd4;
        else if(4'd2 != vdg1 && 4'd2 != vdg2 && 4'd2 != vdg3) vdg0 = 4'd2;
        else if(4'd8 != vdg1 && 4'd8 != vdg2 && 4'd8 != vdg3) vdg0 = 4'd8;
        else if(4'd9 != vdg1 && 4'd9 != vdg2 && 4'd9 != vdg3) vdg0 = 4'd9;
        else if(4'd1 != vdg1 && 4'd1 != vdg2 && 4'd1 != vdg3) vdg0 = 4'd1;
        else if(4'd6 != vdg1 && 4'd6 != vdg2 && 4'd6 != vdg3) vdg0 = 4'd6;
        else if(4'd3 != vdg1 && 4'd3 != vdg2 && 4'd3 != vdg3) vdg0 = 4'd3;
        else if(4'd7 != vdg1 && 4'd7 != vdg2 && 4'd7 != vdg3) vdg0 = 4'd7;
        else if(4'd5 != vdg1 && 4'd5 != vdg2 && 4'd5 != vdg3) vdg0 = 4'd5;
        else vdg0 = 4'd0;
    end
end

endmodule

module ans_check (res_a, res_b, ans, guess);
input [15:0] ans, guess;
output wire [3:0] res_a, res_b;
wire eq3, eq2, eq1, eq0; //  same value same position
wire diff_eq3, diff_eq2, diff_eq1, diff_eq0; //  same value different position

assign eq3 = ans[15:12] == guess[15:12];
assign eq2 = ans[11:8] == guess[11:8];
assign eq1 = ans[7:4] == guess[7:4];
assign eq0 = ans[3:0] == guess[3:0];

assign diff_eq3 = (ans[15:12] == guess[11:8]) + (ans[15:12] == guess[7:4]) + (ans[15:12] == guess[3:0]);
assign diff_eq2 = (ans[11:8] == guess[15:12]) + (ans[11:8] == guess[7:4]) + (ans[11:8] == guess[3:0]);
assign diff_eq1 = (ans[7:4] == guess[11:8]) + (ans[7:4] == guess[15:12]) + (ans[7:4] == guess[3:0]);
assign diff_eq0 = (ans[3:0] == guess[11:8]) + (ans[3:0] == guess[7:4]) + (ans[3:0] == guess[15:12]);

assign res_a = (eq3 ? 4'd1 : 4'd0) + (eq2 ? 4'd1 : 4'd0) + (eq1 ? 4'd1 : 4'd0) + (eq0 ? 4'd1 : 4'd0);
assign res_b = (diff_eq3 ? 4'd1 : 4'd0) + (diff_eq2 ? 4'd1 : 4'd0) + (diff_eq1 ? 4'd1 : 4'd0) + (diff_eq0 ? 4'd1 : 4'd0);

endmodule

module input_to_seg(num, seg);
input [3:0] num;
output reg [6:0] seg;

parameter num_0 = 7'b0000001;
parameter num_1 = 7'b1001111;
parameter num_2 = 7'b0010010;
parameter num_3 = 7'b0000110;
parameter num_4 = 7'b1001100;
parameter num_5 = 7'b0100100;
parameter num_6 = 7'b0100000;
parameter num_7 = 7'b0001111;
parameter num_8 = 7'b0000000;
parameter num_9 = 7'b0000100;

always@(*)begin
    case(num)
        4'd1: seg = num_1;
        4'd2: seg = num_2;
        4'd3: seg = num_3;
        4'd4: seg = num_4;
        4'd5: seg = num_5;
        4'd6: seg = num_6;
        4'd7: seg = num_7;
        4'd8: seg = num_8;
        4'd9: seg = num_9;
        default: seg = num_0;
    endcase
end

endmodule

module per_seg_to_input(num, seg);
input [6:0] seg;
output reg [3:0] num;

parameter num_0 = 7'b0000001;
parameter num_1 = 7'b1001111;
parameter num_2 = 7'b0010010;
parameter num_3 = 7'b0000110;
parameter num_4 = 7'b1001100;
parameter num_5 = 7'b0100100;
parameter num_6 = 7'b0100000;
parameter num_7 = 7'b0001111;
parameter num_8 = 7'b0000000;
parameter num_9 = 7'b0000100;

always@(*)begin
    case(seg)
        num_1: num = 4'd1;
        num_2: num = 4'd2;
        num_3: num = 4'd3;
        num_4: num = 4'd4;
        num_5: num = 4'd5;
        num_6: num = 4'd6;
        num_7: num = 4'd7;
        num_8: num = 4'd8;
        num_9: num = 4'd9;
        default: num = 4'd0;
    endcase
end


endmodule

module seg_to_input(guess, seg3, seg2, seg1, seg0);
input [6:0] seg3, seg2, seg1, seg0;
output [15:0] guess;

per_seg_to_input p1(guess[15:12], seg3);
per_seg_to_input p2(guess[11:8], seg2);
per_seg_to_input p3(guess[7:4], seg1);
per_seg_to_input p4(guess[3:0], seg0);

endmodule

module debounce(pb_debounce, pb, clk);
    input pb;
    input clk;
    output pb_debounce;
    reg [3:0] DFF;

    always@(posedge clk)begin
        DFF[3:1]<=DFF[2:0];
        DFF[0]<=pb;
    end

    assign pb_debounce = (DFF == 4'b1111) ? 1'b1 : 1'b0;
endmodule

module onepulse(pb_one_pulse, pb_debounced, clk);
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

module Clock_Divider(clk, divided_clk, fli_clk);
    input clk;
    output reg divided_clk, fli_clk;
    reg [14:0] cnt = 15'b0;
    reg [24:0] cnt2 = 25'b0;
    
    always@(posedge clk)begin
        if(cnt == 2**15 - 1'b1)begin
            cnt <= 15'b0;
            divided_clk <= 1'b1;
        end
        else begin
            divided_clk <= 1'b0;
            cnt <= cnt + 1'b1;
        end
        if(cnt2 == 2**25 - 1'b1)begin
            cnt2 <= 25'b0;
            fli_clk <= 1'b1;
        end
        else begin
            fli_clk <= 1'b0;
            cnt2 <= cnt2 + 1'b1;
        end
    end
endmodule
