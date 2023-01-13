`timescale 1ns/1ps
module car_top(
    input clk, // W5
    input rst, // V17
    input data, // J3
    input rst_pb, // U18
    output wire left_motor, // A14
    output wire right_motor, // A16
    output wire [1:0] left, //  G2, J2
    output wire [1:0] right, // L2, J1
    output wire [6:0] state_7seg, // U7, V5, U5, V8, U8, W6, W7
    output wire [3:0] an, // W4, V4, U4, U2
    output wire [15:0] led, // L1, P1, N3, P3, U3, W3,V3, V13, V14, U14, U15, W18, V19, U19, E19, U16
    output wire servo_pwm, // R18
    output wire servo_pwm_delay, // P18
    output wire servo_pwm_head, // A15
    output wire servo_pwm_con, // A17
    output wire [1:0] servo_left, // B16, B15
    output wire [1:0] servo_right // C16, C15
);

wire [3:0] state;
wire [3:0] dir;
wire [2:0] tmp;
wire [1:0] turn;
wire [1:0] servo_state;
wire speed_up, shoot_db;
wire UART_clk;

onepulse d1(shoot_db, clk, shoot_op);
    
motor A(
    .clk(clk),
    .rst(rst),
    .speed_up(speed_up),
    .mode(state),
    .pwm({left_motor, right_motor})
);

motor_dir B(
    .state(state),
    .left(left),
    .right(right)
);

state_display sd(
    .state(state),
    .state_7seg(state_7seg),
    .an(an)
); 

led_display ld(
    .in_led({servo_state, 12'b0, data, speed_up}),
    .led(led)
);

clk_divider_UART #(.N(10), .MAX(650)) cd1 (
    .dclk(UART_clk), 
    .clk(clk), 
    .rst(rst)
);

UART_RXD r1(
    .clk(clk),
    .UART_RX(data),
    .UART_clk(UART_clk),
    .rst(rst),
    .data_rcv({dir, speed_up, turn, shoot_db})
);

state_trans st(
    .dir(dir),
    .state(state)
);

shoot_top st2(
    .rst_pb(rst_pb),
    .clk(clk),
    .turn_pb(turn[0]),
    .turn_back_pb(turn[1]),
    .start(shoot_op),
    .left(servo_left),
    .right(servo_right),
    .pwm(servo_pwm),
    .delay_pwm(servo_pwm_delay),
    .state(servo_state),
    .pwm_head(servo_pwm_head),
    .pwm_con(servo_pwm_con)
);

endmodule

