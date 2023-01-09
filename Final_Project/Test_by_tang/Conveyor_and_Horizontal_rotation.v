module Top(
    input rst_pb,
    input clk,
    input turn_pb,
    output reg [1:0] left,
    output reg [1:0] right,
    output wire pwm_head, // left_motor
    output wire pwm_con, // right_motor
    output wire head_turn, // testing
     output wire con_turn // testing
);
    wire rst_op, rst_db;
    debounce d0(rst_db, rst_pb, clk);
    onepulse d1(rst_db, clk, rst_op);
    wire turn_op, turn_db;
    debounce d2(turn_db, turn_pb, clk);
    // onepulse d3(turn_db, clk, turn_op);

    Rotation_PWM_gen m0(clk, rst_op, pwm_head);
    Rotation_PWM_gen m1(clk, rst_op, pwm_con);

    assign head_turn = ((turn_db == 1'b1) ? 1'b1 : 1'b0);
     assign con_turn = ((rst_op == 1'b1) ? 1'b1 : 1'b0);
    always@(*)begin
        if(turn_db) {left, right} = 4'b1011;// turn
        else {left, right} = 4'b1111;//stop
    end
endmodule
module Rotation_PWM_gen (
    input wire clk,
    input wire reset,
    output reg PWM
);
    parameter duty = 32'd770; // decide motor speed
    wire [31:0] count_max = 32'd100_000_000 / 32'd65000;
    wire [31:0] count_duty = count_max * duty / 32'd1024;
//    wire [31:0] count_duty = count_max / 2;
    reg [31:0] count;
        
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            count <= 32'b0;
            PWM <= 1'b0;
        end 
        else if (count < count_max) begin
            count <= count + 32'd1;
            if(count < count_duty)
                PWM <= 1'b1;
            else
                PWM <= 1'b0;
        end
        else begin
            count <= 32'b0;
            PWM <= 1'b0;
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