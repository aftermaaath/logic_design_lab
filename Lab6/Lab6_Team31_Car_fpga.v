`timescale 1ns/1ps

module Top(
    input clk, // W5
    input rst,
    input echo, // H1
    input left_signal, // N2
    input right_signal, // L3
    input mid_signal, // M2
    output trig, // J1
    output left_motor, // L2
    output reg [1:0]left, // A16 A14
    output right_motor, //  K2
    output reg [1:0]right, //  B16 B15
    output wire test_led, // U18
    input test, // V17
    output wire lsig_led, // E19
    output wire rsig_led, // V19
    output wire msig_led, // U19
    output wire stop_led, // L1
    input stop_sw, // R2
    output reg [6:0] state_7seg, // 7seg
    output wire [3:0] an,
    output reg [3:0] test_motor // 
);
    
    wire Rst_n, rst_pb, stop, stop_ctrl;
    debounce d0(rst_pb, rst, clk);
    onepulse d1(rst_pb, clk, Rst_n);
    
    wire [2:0] state;
    wire [1:0] pwm;
    
    assign left_motor = pwm[1];
    assign right_motor = pwm[0];
    
    assign test_led = test;
    assign lsig_led = left_signal;
    assign msig_led = mid_signal;
    assign rsig_led = right_signal;
    assign stop_led = stop;
    assign stop_ctrl = stop & stop_sw;
    assign an = 4'b1110;
    
    always @ (*) begin
    	case (state)
    		3'd0 : state_7seg = 7'b1000000;	//0000
			3'd1 : state_7seg = 7'b1111001;   //0001
			3'd2 : state_7seg = 7'b0100100;   //0010
			3'd3 : state_7seg = 7'b0110000;   //0011
			3'd4 : state_7seg = 7'b0011001;   //0100
            3'd5 : state_7seg = 7'b0010010; //0101
			default : state_7seg = 7'b1111111;
    	endcase
    end
    
    motor A(
        .clk(clk),
        .rst(Rst_n),
        .mode(state),
        .pwm(pwm)
    );

    sonic_top B(
        .clk(clk), 
        .rst(Rst_n), 
        .Echo(echo), 
        .Trig(trig),
        .stop(stop)
    );
    
    tracker_sensor C(
        .clk(clk), 
        .reset(Rst_n), 
        .left_signal(left_signal), 
        .right_signal(right_signal),
        .mid_signal(mid_signal), 
        .state(state)
       );

    parameter turn_left = 3'd0;
    parameter turn_right = 3'd1;
    parameter go_straight = 3'd2;
    parameter sharp_turn_left = 3'd3;
    parameter sharp_turn_right = 3'd4;
    parameter back = 3'd5;
    always @(*) begin
        // [TO-DO] Use left and right to set your pwm
        //if(stop) {left, right} = ???;
        //else  {left, right} = ???;
        // if(stop_ctrl) begin
        //     left = 2'b11;
        //     right = 2'b11;
        // end
        // else if(state == sharp_turn_left) {left, right} = 4'b0110;
        // else if(state == sharp_turn_right) {left, right} = 4'b1001;
        // else {left, right} = 4'b1010;
        if(stop_ctrl) begin
            {left, right} = 4'b1111;
        end
        else begin
            case(state)
                go_straight:begin
                {left, right} = 4'b1010;
                test_motor = 4'b1010;
                end
                turn_left: begin
                {left, right} = 4'b1010;
                test_motor = 4'b1010;
                end
                turn_right:begin
                {left, right} = 4'b1010;
                test_motor = 4'b1010;
                end
                sharp_turn_left: begin
                {left, right} = 4'b0110;
                test_motor = 4'b0110;
                end
                sharp_turn_right:begin
                {left, right} = 4'b1001;
                test_motor = 4'b1001;
                end
                back:begin
                {left, right} = 4'b0101;
                test_motor = 4'b0101;
                end
                default: begin
                {left, right} = 4'b1010;
                test_motor = 4'b1010;
                end
            endcase
        end
    end

endmodule

module debounce (pb_debounced, pb, clk);
    output pb_debounced; 
    input pb;
    input clk;
    reg [4:0] DFF;
    
    always @(posedge clk) begin
        DFF[4:1] <= DFF[3:0];
        DFF[0] <= pb; 
    end
    assign pb_debounced = (&(DFF)); 
endmodule

module onepulse (PB_debounced, clk, PB_one_pulse);
    input PB_debounced;
    input clk;
    output reg PB_one_pulse;
    reg PB_debounced_delay;

    always @(posedge clk) begin
        PB_one_pulse <= PB_debounced & (! PB_debounced_delay);
        PB_debounced_delay <= PB_debounced;
    end 
endmodule

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
    parameter go_straight = 3'd2;
    parameter sharp_turn_left = 3'd3;
    parameter sharp_turn_right = 3'd4;
    parameter back = 3'd5;
    
    parameter straight_speed = 10'd1023;
    parameter turn_in = 10'd723;
    parameter turn_out = 10'd1023;
    parameter sharp_turn_in = 10'd1023;
    parameter sharp_turn_out = 10'd1023;
    parameter back_speed = 10'd1023;


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
        turn_left:begin
            next_left_motor = turn_in;
            next_right_motor = turn_out;
        end
        turn_right:begin
            next_left_motor = turn_out;
            next_right_motor = turn_in;
        end
        sharp_turn_left:begin 
            next_left_motor = sharp_turn_in;
            next_right_motor = sharp_turn_out;
        end
        sharp_turn_right:begin 
            next_left_motor = sharp_turn_out;
            next_right_motor = sharp_turn_in;
        end
        go_straight:begin
            next_left_motor = straight_speed;
            next_right_motor = 10'd1023;
        end
        default:begin
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

module sonic_top(clk, rst, Echo, Trig, stop);
	input clk, rst, Echo;
	output Trig;
	output reg stop;

	wire[19:0] dis; // 1e-3cm
	wire[19:0] d;
    wire clk1M;
	wire clk_2_17;

    div clk1(clk ,clk1M);
	TrigSignal u1(.clk(clk), .rst(rst), .trig(Trig));
	PosCounter u2(.clk(clk1M), .rst(rst), .echo(Echo), .distance_count(dis));

    // [TO-DO] calculate the right distance to trig stop(triggered when the distance is lower than 40 cm)
    // Hint: using "dis"
    always@(posedge clk) begin
        if(rst) stop <= 1'b0;
        else if(dis <= 20'd4000) stop <= 1'b1;
        else stop <= 1'b0;
    end

endmodule

module PosCounter(clk, rst, echo, distance_count);
    input clk, rst, echo;
    output[19:0] distance_count;

    parameter S0 = 2'b00;
    parameter S1 = 2'b01;
    parameter S2 = 2'b10;

    wire start, finish;
    reg[1:0] curr_state, next_state;
    reg echo_reg1, echo_reg2;
    reg[19:0] count, next_count, distance_register, next_distance;
    wire[19:0] distance_count;

    always@(posedge clk) begin
        if(rst) begin
            echo_reg1 <= 1'b0;
            echo_reg2 <= 1'b0;
            count <= 20'b0;
            distance_register <= 20'b0;
            curr_state <= S0;
        end
        else begin
            echo_reg1 <= echo;
            echo_reg2 <= echo_reg1;
            count <= next_count;
            distance_register <= next_distance;
            curr_state <= next_state;
        end
    end

    always @(*) begin
        case(curr_state)
            S0: begin
                next_distance = distance_register;
                if (start) begin
                    next_state = S1;
                    next_count = count;
                end else begin
                    next_state = curr_state;
                    next_count = 20'b0;
                end
            end
            S1: begin
                next_distance = distance_register;
                if (finish) begin
                    next_state = S2;
                    next_count = count;
                end else begin
                    next_state = curr_state;
                    next_count = (count > 20'd600_000) ? count : count + 1'b1;
                end
            end
            S2: begin
                next_distance = count;
                next_count = 20'b0;
                next_state = S0;
            end
            default: begin
                next_distance = 20'b0;
                next_count = 20'b0;
                next_state = S0;
            end
        endcase
    end

    assign distance_count = distance_register * 20'd100 / 20'd58;
    assign start = echo_reg1 & ~echo_reg2;
    assign finish = ~echo_reg1 & echo_reg2;
endmodule

module TrigSignal(clk, rst, trig);
    input clk, rst;
    output trig;

    reg trig, next_trig;
    reg[23:0] count, next_count;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            count <= 24'b0;
            trig <= 1'b0;
        end
        else begin
            count <= next_count;
            trig <= next_trig;
        end
    end

    always @(*) begin
        next_trig = trig;
        next_count = count + 1'b1;
        if(count == 24'd999)
            next_trig = 1'b0;
        else if(count == 24'd9999999) begin
            next_trig = 1'b1;
            next_count = 24'd0;
        end
    end
endmodule

module div(clk ,out_clk);
    input clk;
    output out_clk;
    reg out_clk;
    reg [6:0]cnt;

    always @(posedge clk) begin
        if(cnt < 7'd50) begin
            cnt <= cnt + 1'b1;
            out_clk <= 1'b1;
        end
        else if(cnt < 7'd100) begin
	        cnt <= cnt + 1'b1;
	        out_clk <= 1'b0;
        end
        else if(cnt == 7'd100) begin
            cnt <= 7'b0;
            out_clk <= 1'b1;
        end
        else begin
            cnt <= 7'b0;
            out_clk <= 1'b1;
        end
    end
endmodule

module tracker_sensor(clk, reset, left_signal, right_signal, mid_signal, state);
    input clk;
    input reset;
    input left_signal, right_signal, mid_signal; // black low, white high
    output reg [2:0] state;

    // [TO-DO] Receive three signals and make your own policy.
    // Hint: You can use output state to change your action.

    reg [2:0]next_state;
    // wire [2:0]signal;

    // assign signal = {left_signal, mid_signal, right_signal};

    parameter turn_left = 3'd0;
    parameter turn_right = 3'd1;
    parameter go_straight = 3'd2;
    parameter sharp_turn_left = 3'd3;
    parameter sharp_turn_right = 3'd4;
    //  parameter back = 3'd5;

    always@(posedge clk)begin
        if(reset) state <= go_straight;
        else state <= next_state;
    end
    always@(*)begin
//         case(signal)
//             3'b000:next_state = back; // all black, go back and redetect
//             3'b001:next_state = sharp_turn_right;
//             3'b010:next_state = back;
//             3'b011:next_state = turn_right;
//             3'b100:next_state = sharp_turn_left;
//             3'b110:next_state = turn_left;
//             3'b111:next_state = go_straight; // all white
//             default:next_state = go_straight;
//         endcase
    case(state)
            go_straight:begin
                if(left_signal == 1'b0 && right_signal == 1'b1) next_state = turn_right;
                else if(left_signal == 1'b1 && right_signal == 1'b0) next_state = turn_left;
                // else if(left_signal == 1'b0 && right_signal == 1'b0) next_state = back;
                else next_state = go_straight;
            end
            turn_left:begin
                if(right_signal == 1'b0) begin
                    if(mid_signal == 1'b0) next_state = sharp_turn_left;
                    else next_state = turn_left;
                end
                else next_state = go_straight;
            end
            turn_right:begin
                if(left_signal == 1'b0) begin
                    if(mid_signal == 1'b0) next_state = sharp_turn_right;
                    else next_state = turn_right;
                end
                else next_state = go_straight;
            end
            sharp_turn_left:begin
                if(mid_signal == 1'b0) next_state = sharp_turn_left;
                else next_state = turn_left;
            end
            sharp_turn_right:begin
                if(mid_signal == 1'b0) next_state = sharp_turn_right;
                else next_state = turn_right;
            end
            default:begin
                next_state = go_straight;
            end
    endcase
    end
endmodule
