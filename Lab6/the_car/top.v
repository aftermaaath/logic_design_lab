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
    input test // V17
);
    
    assign test_led = test;
    
    wire Rst_n, rst_pb, stop;
    debounce d0(rst_pb, rst, clk);
    onepulse d1(rst_pb, clk, Rst_n);
    
    wire [2:0] state;
    wire [1:0] pwm;
    
    assign left_motor = pwm[1];
    assign right_motor = pwm[0];
    
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

    always @(*) begin
        // [TO-DO] Use left and right to set your pwm
        //if(stop) {left, right} = ???;
        //else  {left, right} = ???;
        if(stop) begin
            left <= 2'b0;
            right <= 2'b0;
        end
        else begin
            left <= 2'b10;
            right <= 2'b10;
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

