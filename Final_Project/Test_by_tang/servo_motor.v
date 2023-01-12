module SG90(
    input  rst_pb,
    input  clk,
    input  start_pb,
    input  key_2,
    output reg pwm,
    output reg delay_pwm,
    output reg [1:0]state // for testing
    );
    
    reg[30:0] cnt1;
    reg[30:0] cnt2;
    parameter MAX = 31'd23500000;
    parameter MAX_latter = 31'd33450000;
    
    wire rst_op, rst_db;
    debounce d0(rst_db, rst_pb, clk);
    onepulse d1(rst_db, clk, rst_op);

    wire start_op, start_db;
    debounce d2(start_db, start_pb, clk);
    onepulse d3(start_db, clk, start_op);

    wire div_clk;
    clk_div cd(rst_op, clk, div_clk);

    reg d_st;
    always@(posedge clk or posedge rst_op) begin
        if(rst_op)begin
                state <= 2'b00;
                d_st <= 1'b0;
                pwm <= 1'b0;
                delay_pwm <= 1'b1;
        end
        else begin
            case(state)
                2'b00:begin
                    if(start_op)begin
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