
module Rotation_PWM_gen (
    input wire clk,
    input wire reset,
    output reg PWM
);
    parameter duty = 32'd850; // decide motor speed
    wire [31:0] count_max = 32'd100_000_000 / 32'd25000;
    wire [31:0] count_duty = count_max * duty / 32'd1024;
//    wire [31:0] count_duty = count_max / 2;
    reg [31:0] count;
        
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            count <= 32'b0;
            PWM <= 1'b0;
        end else if (count < count_max) begin
            count <= count + 32'd1;
            if(count < count_duty) PWM <= 1'b1;
            else PWM <= 1'b0;
        end else begin
            count <= 32'b0;
            PWM <= 1'b0;
        end
    end
endmodule

module SG90(
    input  rst,
    input  clk,
    input  start,
    output reg pwm,
    output reg delay_pwm,
    output reg [1:0] state // for testing
    );
    
    reg [30:0] cnt1;
    reg [30:0] cnt2;
    parameter MAX = 31'd33650000;
    parameter MAX_latter = 31'd33480000;

    wire div_clk;
    servo_div_clk cd(rst, clk, div_clk);

    reg d_st;
    always@(posedge clk or posedge rst) begin
        if(rst)begin
                state <= 2'b00;
                d_st <= 1'b0;
                pwm <= 1'b0;
                delay_pwm <= 1'b1;
        end else begin
            case(state)
                2'b00:begin
                    if(start)begin
                        state <= 2'b01;
                        cnt1 <= 31'd0;
                        cnt2 <= 31'd0;
                        d_st <= 1'b1;
                        pwm <= pwm;
                        delay_pwm <= delay_pwm;
                    end else if(d_st && div_clk)begin
                        state <= 2'b10;
                        cnt1 <= 31'd0;
                        cnt2 <= 31'd0;
                        d_st <= 1'b0;
                        pwm <= pwm;
                        delay_pwm <= delay_pwm;
                    end else if(cnt1 <= 31'd149999)begin
                        state <= state;
                        cnt1 <= cnt1 + 1'b1;
                        cnt2 <= cnt2 + 1'b1;
                        d_st <= d_st;
                        pwm <= 1'b1;
                        delay_pwm <= 1'b1;
                    end else if(cnt1 == 31'd1999999)begin
                        state <= state;
                        cnt2 <= cnt2 + 1'b1;
                        cnt1 <= 31'd0;
                        d_st <= d_st;
                        pwm <= 1'b0;
                        delay_pwm <= 1'b0;
                    end else begin
                        state <= state;
                        cnt1 <= cnt1 + 1'b1;
                        cnt2 <= cnt2 + 1'b1;
                        d_st <= d_st;
                        pwm <= 1'b0;
                        delay_pwm <= 1'b0;
                    end
                end
                2'b01:begin
                    if(cnt2 == MAX)begin
                        state <= 2'b00;
                        cnt1 <= 31'd0;
                        cnt2 <= 31'd0;
                        pwm <= pwm;
                        delay_pwm <= 1'b0;
                    end else if(cnt1 <= 31'd59999)begin
                        state <= state;
                        cnt1 <= cnt1 + 1'b1;
                        cnt2 <= cnt2 + 1'b1;                           
                        pwm <= 1'b1;
                        delay_pwm <= 1'b0;
                    end else if(cnt1 == 31'd1999999)begin
                        state <= state;
                        cnt1 <= 31'd0;
                        cnt2 <= cnt2 + 1'b1;
                        pwm <= 1'b0;
                        delay_pwm <= 1'b0;
                    end else begin
                        state <= state;
                        cnt1 <= cnt1 + 1'b1;
                        cnt2 <= cnt2 + 1'b1;                        
                        pwm <= 1'b0;
                        delay_pwm <= 1'b0;
                    end
                end
                default:begin
                    if(cnt2 == MAX_latter)begin
                        state <= 2'b00;
                        cnt1 <= 31'd0;
                        cnt2 <= 31'd0;
                        pwm <= 1'b0;
                        delay_pwm <= delay_pwm;
                    end
                    else if(cnt1 <= 31'd59999)begin
                        state <= state;
                        cnt1 <= cnt1 + 1'b1;
                        cnt2 <= cnt2 + 1'b1; 
                        pwm <= 1'b0;                          
                        delay_pwm <= 1'b1;
                    end
                    else if(cnt1 == 31'd1999999)begin
                        state <= state;
                        cnt1 <= 31'd0;
                        cnt2 <= cnt2 + 1'b1;
                        pwm <= 1'b0;
                        delay_pwm <= 1'b0;
                    end
                    else begin
                        state <= state;
                        cnt1 <= cnt1 + 1'b1;
                        cnt2 <= cnt2 + 1'b1;  
                        pwm <= 1'b0;
                        delay_pwm <= 1'b0;
                    end
                end
            endcase
        end
    end           
endmodule