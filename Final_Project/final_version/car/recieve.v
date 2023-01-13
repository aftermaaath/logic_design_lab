module UART_RXD(
    input clk,
    input UART_RX,
    input UART_clk,
    input rst,
    output reg [7:0] data_rcv
);
// parameters
parameter WAIT = 2'b00;
parameter START = 2'b01;
parameter REC = 2'b10;
parameter STOP = 2'b11;
parameter CNT_HOLD_MAX = 10'd640;
// variables
reg [1:0] state, next_state;
reg [7:0] data, next_data;
reg [4:0] count, next_count;
reg [3:0] cnt_in, next_cnt_in;
reg [9:0] cnt_hold, next_cnt_hold;
reg hold_valid, next_hold_valid;
// assign
//assign data_rcv = data;

always@(posedge clk) begin
    if(rst) begin
        state <= WAIT;
        data <= 8'd0;
        count <= 5'd0;
        cnt_in <= 4'd0;
        cnt_hold <= 10'd0;
        hold_valid <= 1'b0;
        data_rcv <= 1'b0;
    end else begin
        state <= next_state;
        data <= next_data;
        count <= next_count;
        cnt_in <= next_cnt_in;
        cnt_hold <= next_cnt_hold;
        hold_valid <= next_hold_valid;
        if(state == STOP) data_rcv <= data;
        else data_rcv <= data_rcv;
    end
end

always@(*) begin
    case(state) 
        WAIT: begin
            if(UART_RX==1'b0) next_state = START;
            else next_state = WAIT;
            next_data = data;
            next_count = 5'd0;
            next_cnt_in = 4'd0;
        end
        START: begin
            if(count == 5'b01000) begin
                next_state = REC;
                next_data = data;
                next_count = 5'd0;
                next_cnt_in = 4'd0;
            end
            else begin
                next_state = START;
                next_data = data;
                if(UART_clk==1'b1) next_count = count + 1'b1;
                else next_count = count;
                next_cnt_in = 4'd0;
            end
        end
        REC: begin
            if(cnt_in==4'b1000) begin
                next_state = STOP;
                next_data = data;
                next_count = 5'd0;
                next_cnt_in = 4'd0;
            end else begin
                if(count==5'b10000) begin
                    next_state = REC;
                    next_data = {UART_RX, data[7:1]};
                    next_count = 5'd0;
                    next_cnt_in = cnt_in + 4'd1;
                end else begin
                    if(UART_clk==1'b1) begin
                        next_state = REC;
                        next_data = data;
                        next_count = count + 5'd1;
                        next_cnt_in = cnt_in;
                    end else begin
                        next_state = REC;
                        next_data = data;
                        next_count = count;
                        next_cnt_in = cnt_in;
                    end
                end
            end
        end
        STOP: begin
            if(count==5'd24) begin
                next_state = WAIT;
                next_data = data;
                next_count = 5'd0;
                next_cnt_in = 4'd0;
            end else begin
                next_state = STOP;
                next_data = data;
                next_cnt_in = cnt_in;
                if(UART_clk==1'b1) next_count = count +5'd1;
                else next_count = count;
            end
        end
    endcase
end

always@(*) begin
    if(state == STOP) begin
        next_cnt_hold = 10'd0;
        next_hold_valid = 1'b1;
    end else begin
        if(hold_valid == 1'b1) begin
            if(cnt_hold == CNT_HOLD_MAX) begin
                next_cnt_hold = 10'd0;
                next_hold_valid = 1'b0;
            end else begin 
                if(UART_clk == 1'b1) next_cnt_hold = cnt_hold + 10'd1;
                else next_cnt_hold = cnt_hold;
                next_hold_valid = 1'b1;
            end
        end else begin
            next_cnt_hold = 10'd0;
            next_hold_valid = 1'b0;
        end
    end
end
endmodule