module Top(
    input rst_pb,
    input clk,
    input turn_pb,
    input turn_back_pb,
    input start_pb,
    output reg [1:0] left,
    output reg [1:0] right,
    output wire pwm,
    output wire delay_pwm,
    output wire [1:0]state, // for testing
    output wire pwm_head, // left_motor
    output wire pwm_con, // right_motor
    output wire head_turn, // testing
    output wire con_turn // testing
);
    wire rst_op, rst_db;
    debounce d0(rst_db, rst_pb, clk);
    onepulse d1(rst_db, clk, rst_op);
    wire turn_db;
    debounce d2(turn_db, turn_pb, clk);
    wire turn_back_db;
    debounce d3(turn_back_db, turn_back_pb, clk);
    wire start_op, start_db;
    debounce d4(start_db, start_pb, clk);
    onepulse d5(start_db, clk, start_op);

    Rotation_PWM_gen m0(clk, rst_op, pwm_head);
    Rotation_PWM_gen m1(clk, rst_op, pwm_con);
    SG90 sg(
        .rst(rst_db),
        .clk(clk),
        .start(start_db),
        .pwm(pwm),
        .delay_pwm(delay_pwm),
        .state(state) // for testing
    );

    assign head_turn = ((turn_db == 1'b1) ? 1'b1 : 1'b0);
    assign con_turn = ((rst_op == 1'b1) ? 1'b1 : 1'b0);
    always@(*)begin
        if(turn_db) {left, right} = 4'b1011;// turn
        else if(turn_back_db) {left, right} = 4'b0111;// turn in oposite direction
        else {left, right} = 4'b1111;//stop
    end
endmodule
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

module SG90(
    input  rst,
    input  clk,
    input  start,
    output reg pwm,
    output reg delay_pwm,
    output reg [1:0]state // for testing
    );
    
    reg[30:0] cnt1;
    reg[30:0] cnt2;
    parameter MAX = 31'd33650000;
    parameter MAX_latter = 31'd33480000;

    wire div_clk;
    clk_div cd(rst, clk, div_clk);

    reg d_st;
    always@(posedge clk or posedge rst) begin
        if(rst)begin
                state <= 2'b00;
                d_st <= 1'b0;
                pwm <= 1'b0;
                delay_pwm <= 1'b1;
        end
        else begin
            case(state)
                2'b00:begin
                    if(start)begin
                        state <= 2'b01;
                        cnt1 <= 31'd0;
                        cnt2 <= 31'd0;
                        d_st <= 1'b1;
                        pwm <= pwm;
                        delay_pwm <= delay_pwm;
                    end
                    else if(d_st && div_clk)begin
                        state <= 2'b10;
                        cnt1 <= 31'd0;
                        cnt2 <= 31'd0;
                        d_st <= 1'b0;
                        pwm <= pwm;
                        delay_pwm <= delay_pwm;
                    end
                    else if(cnt1 <= 31'd149999)begin
                        state <= state;
                        cnt1 <= cnt1 + 1'b1;
                        cnt2 <= cnt2 + 1'b1;
                        d_st <= d_st;
                        pwm <= 1'b1;
                        delay_pwm <= 1'b1;
                    end
                    else if(cnt1 == 31'd1999999)begin
                        state <= state;
                        cnt2 <= cnt2 + 1'b1;
                        cnt1 <= 31'd0;
                        d_st <= d_st;
                        pwm <= 1'b0;
                        delay_pwm <= 1'b0;
                    end
                    else begin
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
                    end
                    else if(cnt1 <= 31'd59999)begin
                        state <= state;
                        cnt1 <= cnt1 + 1'b1;
                        cnt2 <= cnt2 + 1'b1;                           
                        pwm <= 1'b1;
                        delay_pwm <= 1'b0;
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
module clk_div(rst, clk, div_clk);
input rst, clk;
output div_clk;
wire [25:0]nxt_cnt;
reg [25:0]cnt;
reg div_clk;
assign nxt_cnt = cnt+1;

always@(posedge clk)begin
    if(rst)begin
        cnt <= 26'b0;
        div_clk <= 1'b0;
    end
    else begin
            if(cnt == 2**25-26'd800) begin
                div_clk <= 1'b1;
                cnt <= 25'b0;
            end else begin
                div_clk <= 1'b0;
                cnt <= nxt_cnt;
            end
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