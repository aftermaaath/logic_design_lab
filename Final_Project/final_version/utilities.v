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

module div_clk(div_clk, clk);
input clk;
output reg div_clk;
reg [25:0] ct;

always@(posedge clk)begin
    if(ct == 2 ** 26 - 1) begin
        div_clk <= 1'b1;
        ct <= 26'b0;
    end
    else begin
        div_clk <= 1'b0;
        ct <= ct + 1'b1;  
    end  
end

endmodule

module clk_divider_UART#(parameter N = 5, parameter MAX = 20)(dclk, clk, rst);
input clk, rst;
output reg dclk;

reg next_dclk;
reg [N-1:0] counter;
reg [N-1:0] next_counter;

always@(posedge clk) begin
    if(rst) begin
        counter <= 0;
        dclk <= 1'b1;
    end else begin
        counter <= next_counter;
        dclk <= next_dclk;
    end
end

always@(*) begin
    if(counter == MAX - 1) begin
        next_dclk = 1'b1;
        next_counter = 0;         
    end else begin
        next_dclk = 1'b0;
        next_counter = counter + 1'b1;
    end
end

endmodule

module servo_div_clk(rst, clk, div_clk);
input rst, clk;
output div_clk;
wire [25:0] nxt_cnt;
reg [25:0] cnt;
reg div_clk;
assign nxt_cnt = cnt+1;

always@(posedge clk)begin
    if(rst)begin
        cnt <= 26'b0;
        div_clk <= 1'b0;
    end
    else begin
        if(cnt == 2 ** 25 - 26'd800) begin
            div_clk <= 1'b1;
            cnt <= 26'b0;
        end else begin
            div_clk <= 1'b0;
            cnt <= nxt_cnt;
        end
    end
end
endmodule