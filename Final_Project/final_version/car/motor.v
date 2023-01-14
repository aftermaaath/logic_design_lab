module motor(
    input clk,
    input rst,
    input speed_up,
    input [2:0] mode,
    output wire [1:0] pwm
);

reg [9:0] next_left_motor, next_right_motor;
reg [9:0] left_motor, right_motor;
reg [9:0] cur_speed, cur_turn_speed;

// pwm gen  
wire left_pwm, right_pwm;
motor_pwm m0(clk, rst, left_motor, left_pwm);
motor_pwm m1(clk, rst, right_motor, right_pwm);
assign pwm = {left_pwm, right_pwm};

// state parameter
parameter stop = 4'd0;
parameter go_straight = 4'd1;
parameter go_left = 4'd2;
parameter go_right = 4'd3;
parameter go_back = 4'd4;
parameter left_front = 4'd5; 
parameter right_front = 4'd6;
parameter left_back = 4'd7;
parameter right_back = 4'd8;
// speed parameter 
parameter normal_spd = 10'd800;
parameter turn_spd = 10'd600;
parameter accr_spd = 10'd1023;
parameter accr_turn_spd = 10'd723;
    
always@(posedge clk) begin
    if(rst) begin
        left_motor <= 10'd0;
        right_motor <= 10'd0;
    end else begin
        left_motor <= next_left_motor;
        right_motor <= next_right_motor;
    end
end

always@(*) begin
    if(speed_up) begin
        cur_speed = accr_spd;
        cur_turn_speed = accr_turn_spd;
    end else begin
        cur_speed = normal_spd;
        cur_turn_speed = turn_spd;
    end
end

always@(*)begin
    case(mode)
        go_straight: begin
            next_left_motor = cur_speed;
            next_right_motor = cur_speed;
        end
        go_left: begin
            next_left_motor = cur_speed;
            next_right_motor = cur_speed;
        end
        go_right: begin
            next_left_motor = cur_speed;
            next_right_motor = cur_speed;
        end
        go_back: begin
            next_left_motor = cur_speed;
            next_right_motor = cur_speed;
        end
        left_front: begin
            next_left_motor = cur_turn_speed;
            next_right_motor = cur_speed;
        end
        right_front: begin
            next_left_motor = cur_speed;
            next_right_motor = cur_turn_speed;
        end
        left_back: begin
            next_left_motor = cur_turn_speed;
            next_right_motor = cur_speed;
        end
        right_back: begin
            next_left_motor = cur_speed;
            next_right_motor = cur_turn_speed;
        end
        default:begin
            next_left_motor = 10'd0;
            next_right_motor = 10'd0;
        end
    endcase
end

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

module motor_dir(
    input [3:0] state,
    output reg [1:0] left,
    output reg [1:0] right
);

parameter stop = 4'd0;
parameter go_straight = 4'd1;
parameter go_left = 4'd2;
parameter go_right = 4'd3;
parameter go_back = 4'd4;
parameter left_front = 4'd5; 
parameter right_front = 4'd6;
parameter left_back = 4'd7;
parameter right_back = 4'd8;

always @(*) begin
    case(state)
        stop: {left, right} = 4'b1111;
        go_straight: {left, right} = 4'b1010;
        go_left: {left, right} = 4'b0110;
        go_right: {left, right} = 4'b1001;
        go_back: {left, right} = 4'b0101;
        left_front: {left, right} = 4'b1010;
        right_front: {left, right} = 4'b1010;
        left_back: {left, right} = 4'b0101;
        right_back: {left, right} = 4'b0110;
        default: {left, right} = 4'b1111;
    endcase
end

endmodule
