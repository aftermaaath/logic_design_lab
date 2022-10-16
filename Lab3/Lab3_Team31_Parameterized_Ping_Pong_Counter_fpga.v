`timescale 1ns/1ps
module Parameterized_Ping_Pong_Counter_FPGA (clk, rst_n_pb, enable, flip_pb, max, min, display_segment, an);
    input clk, rst_n_pb, enable, flip_pb;
    input [4-1:0] max;
    input [4-1:0] min;
    output [6:0] display_segment;
    output [3:0] an;

    reg [3:0]an = 4'b1111;

    reg [6:0] display_segment;

    reg [6:0]next_segment_out_left;
    reg [6:0]next_segment_out_right;
    reg [6:0]next_direction_display;

    wire direction, enable_clk;
    wire [3:0]out;
    wire rst_n, rst_n_one_pulse, flip_one_pulse, flip, rst;
    wire hold;
    wire devided_clk, digit_clk;

    Clock_Divider cd(clk, devided_clk, digit_clk);

    //debounce and generate one pulse clk
    debounce db1(rst_n, rst_n_pb, clk);
    debounce db2(flip, flip_pb, clk);
    onepulse op1(rst_n, clk, rst_n_one_pulse);
    onepulse op2(flip, clk, flip_one_pulse);

    assign rst = ~rst_n_one_pulse;
    assign enable_clk = enable & devided_clk;

    Parameterized_Ping_Pong_Counter pppc(clk, rst, enable_clk, flip_one_pulse, max, min, direction, out);

    always@(posedge clk)begin
        if(digit_clk)begin
            case(an)
            4'b0111: begin
                display_segment <= next_segment_out_right;
                an <= 4'b1011;
            end
            4'b1011: begin
                display_segment <= next_direction_display;
                an <= 4'b1101;
            end
            4'b1101: begin
                display_segment <= next_direction_display;
                an <= 4'b1110;
            end
            default: begin
                display_segment <= next_segment_out_left;
                an <= 4'b0111;
            end
            endcase
        end
        else begin
        end
    end

    always@(*)begin
        if(out < 4'b1010)begin
            next_segment_out_left = 7'b0000001;
            case(out)
                4'b0000: next_segment_out_right = 7'b0000001;
                4'b0001: next_segment_out_right = 7'b1001111;
                4'b0010: next_segment_out_right = 7'b0010010;
                4'b0011: next_segment_out_right = 7'b0000110;
                4'b0100: next_segment_out_right = 7'b1001100;
                4'b0101: next_segment_out_right = 7'b0100100;
                4'b0110: next_segment_out_right = 7'b0100000;
                4'b0111: next_segment_out_right = 7'b0001111;
                4'b1000: next_segment_out_right = 7'b0000000;
                default: next_segment_out_right = 7'b0000100;
            endcase
        end
        else begin
            next_segment_out_left = 7'b1001111;
            case(out)
                4'b1010: next_segment_out_right = 7'b0000001;
                4'b1011: next_segment_out_right = 7'b1001111;
                4'b1100: next_segment_out_right = 7'b0010010;
                4'b1101: next_segment_out_right = 7'b0000110;
                4'b1110: next_segment_out_right = 7'b1001100;
                default: next_segment_out_right = 7'b0100100;
            endcase
        end

        if(direction == 1'b1)begin
            next_direction_display = 7'b0011101;
        end
        else begin
            next_direction_display = 7'b1100011;
        end
    end

endmodule

module Parameterized_Ping_Pong_Counter (clk,  rst_n, enable, flip, max, min, direction, out);
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
        if(enable)begin
            direction <= next_direction;
            out <= next_out;
        end
        else begin
        end
    end

    always@(*)begin
        if(!rst_n)begin
            next_out = min;
            next_direction = 1'b1;
        end
        else begin
            if(!hold)begin
                if(flip) begin
                    next_direction = (direction == 1'b1) ? 1'b0 : 1'b1;
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

module onepulse(pb_debounced, clk, pb_one_pulse);
    input pb_debounced;
    input clk;
    output pb_one_pulse;
    reg pb_debounced_delay;
    reg pb_one_pulse;

    always@(posedge clk)begin    
        pb_debounced_delay <= pb_debounced;
        pb_one_pulse <= pb_debounced & (!pb_debounced_delay);
    end
endmodule

module Clock_Divider(clk, devided_clk, digit_clk);

    input clk;
    output devided_clk, digit_clk;
    reg [24:0]cnt = 25'b0;
    reg [19:0]cnt_1 = 20'b0;
    reg devided_clk, digit_clk;

    always@(posedge clk)begin
        if(cnt == 2**25 - 1'b1)begin
            cnt <= 25'b0;
            devided_clk <= 1'b1;
        end
        else begin
            devided_clk <= 1'b0;
            cnt <= cnt+1'b1;
        end
        
        if(cnt_1 == 2**15 - 1'b1)begin
            cnt_1 <= 20'b0;
            digit_clk <= 1'b1;
        end
        else begin
            digit_clk <= 1'b0;
            cnt_1 <= cnt_1+1'b1;
        end
    end
endmodule