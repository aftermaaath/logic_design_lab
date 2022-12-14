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
//                back:begin
//                {left, right} = 4'b0101;
//                test_motor = 4'b0101;
//                end
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

