module shoot_top(
    input rst_pb,
    input clk,
    input turn_pb,
    input turn_back_pb,
    input start,
    output reg [1:0] left,
    output reg [1:0] right,
    output wire pwm,
    output wire delay_pwm,
    output wire [1:0]state, // for testing
    output wire pwm_head, // left_motor
    output wire pwm_con // right_motor
);

    wire rst_op, rst_db;
    wire turn_db, turn_back_db;
    
    debounce d0(rst_db, rst_pb, clk);
    onepulse d1(rst_db, clk, rst_op);
    debounce d2(turn_db, turn_pb, clk);
    debounce d3(turn_back_db, turn_back_pb, clk);

    Rotation_PWM_gen m0(clk, rst_op, pwm_head);
    // Rotation_PWM_gen m1(clk, rst_op, pwm_con);
    SG90 sg(
        .rst(rst_db),
        .clk(clk),
        .start(start),
        .pwm(pwm),
        .delay_pwm(delay_pwm),
        .state(state) // for testing
    );

    always@(*)begin
        if(turn_db) {left, right} = 4'b1011;// turn
        else if(turn_back_db) {left, right} = 4'b0111;// turn in oposite direction
        else {left, right} = 4'b1111;//stop
    end
endmodule