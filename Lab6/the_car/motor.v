module motor(
    input clk,
    input rst,
    input [2:0] mode, // take state in tracker_sensor as input
    output wire [1:0] pwm
);

    reg [9:0]next_left_motor, next_right_motor;
    reg [9:0]left_motor, right_motor;
    wire left_pwm, right_pwm;
    
    parameter turn_left = 3'd0;
    parameter turn_right = 3'd1;
    parameter go_stright = 3'd2;
    parameter sharp_turn_left = 3'd3;
    parameter sharp_turn_right = 3'd4;
    
    parameter straight_speed = 10'd1000;
    parameter turn_in = 10'd800;
    parameter turn_out = 10'd1000;
    parameter sharp_turn_in = 10'd1000;
    parameter sharp_turn_out = 10'd1000;

    motor_pwm m0(clk, rst, left_motor, left_pwm);
    motor_pwm m1(clk, rst, right_motor, right_pwm);
    
    always@(posedge clk)begin
        if(rst)begin
            left_motor <= 10'd0;
            right_motor <= 10'd0;
        end else begin
            left_motor <= next_left_motor;
            right_motor <= next_right_motor;
        end
    end
    
    // [TO-DO] take the right speed for different situation
    always@(*)begin
        case(mode)
        // speed max 1023
        turn_left:begin // left < right
            next_left_motor = turn_in;
            next_right_motor = turn_out;
        end
        turn_right:begin // right < left
            next_left_motor = turn_out;
            next_right_motor = turn_in;
        end
        sharp_turn_left:begin // left << right
            next_left_motor = sharp_turn_in;
            next_right_motor = sharp_turn_out;
        end
        sharp_turn_right:begin // right << left
            next_left_motor = sharp_turn_out;
            next_right_motor = sharp_turn_in;
        end
        default:begin // same speed
            next_left_motor = straight_speed;
            next_right_motor = straight_speed;
        end
        endcase
    end

    assign pwm = {left_pwm, right_pwm};
endmodule

module motor_pwm (
    input clk,
    input reset,
    input [9:0]duty,
	output pmod_1 //PWM
);
        
    PWM_gen pwm_0 ( 
        .clk(clk), 
        .reset(reset), 
        .freq(32'd25000),
        .duty(duty), 
        .PWM(pmod_1)
    );

endmodule

//generte PWM by input frequency & duty
module PWM_gen (
    input wire clk,
    input wire reset,
	input [31:0] freq,
    input [9:0] duty,
    output reg PWM
);
    wire [31:0] count_max = 32'd100_000_000 / freq;
    wire [31:0] count_duty = count_max * duty / 32'd1024;
    reg [31:0] count;
        
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            count <= 32'b0;
            PWM <= 1'b0;
        end else if (count < count_max) begin
            count <= count + 32'd1;
            if(count < count_duty)
                PWM <= 1'b1;
            else
                PWM <= 1'b0;
        end else begin
            count <= 32'b0;
            PWM <= 1'b0;
        end
    end
endmodule

