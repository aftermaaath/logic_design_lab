module UART_TXD(
    input clk,
    input UART_clk,
    input rst,
    input [7:0] data_in,
    input en,
    output reg [7:0] data_led,
    output reg UART_TX
);

// parameters
parameter WAIT = 1'b0;
parameter SEND = 1'b1; 
parameter MAX_SND_SIZE = 4'b1000;
// variables
reg next_UART_TX;
reg [7:0] SND_DATA, next_SND_DATA, next_data_led;
reg state, next_state;
reg [3:0] count_bit, next_count_bit;

always@(posedge clk) begin
    if(rst) begin
        state <= WAIT;
        SND_DATA <= 8'd0;
        count_bit <= 4'd0;
        UART_TX <= 1'b1;
        data_led <= 8'b0;
    end else begin
        state <= next_state;
        SND_DATA <= next_SND_DATA;
        count_bit <= next_count_bit;
        UART_TX <= next_UART_TX;
        data_led <= next_data_led;
    end
end

always@(*) begin
    case(state) 
        WAIT: begin
            if(en) begin
                next_state = SEND;
                next_UART_TX = 1'b1;
                next_SND_DATA = data_in;
                next_count_bit = 4'd0;
                next_data_led = data_led;
            end else begin
                next_state = WAIT;
                next_UART_TX = 1'b1;
                next_SND_DATA = data_in;
                next_count_bit = 4'd0;
                next_data_led = data_led;
            end
        end
        SEND: begin
            if(count_bit == 4'd0) begin
                next_state = SEND;
                if(UART_clk==1'b1) begin
                    next_UART_TX = 1'b0; // start bit
                    next_count_bit = count_bit + 4'd1;
                end else begin
                    next_UART_TX = UART_TX;
                    next_count_bit = count_bit;
                end
                next_SND_DATA = SND_DATA;
                next_data_led = data_led;
            end else if((count_bit > 4'd0) && (count_bit <= MAX_SND_SIZE)) begin
                next_state = SEND;
                if(UART_clk==1'b1) begin
                    next_UART_TX = SND_DATA[0];
                    next_count_bit = count_bit + 4'd1;
                    next_SND_DATA = SND_DATA >> 1;
                    next_data_led = {SND_DATA[0], data_led[7:1]};
                end else begin
                    next_UART_TX = UART_TX;
                    next_count_bit = count_bit;
                    next_SND_DATA = SND_DATA;
                    next_data_led = data_led;
                end
            end else if(count_bit == MAX_SND_SIZE + 4'd1) begin
                next_state = SEND;
                if(UART_clk==1'b1) begin
                    next_UART_TX = 1'b1; // end bit
                    next_count_bit = count_bit + 4'd1;
                end else begin
                    next_UART_TX = UART_TX;
                    next_count_bit = count_bit;
                end
                next_SND_DATA = SND_DATA;
                next_data_led = data_led;
            end else begin
                if(UART_clk == 1'b1)begin
                    next_state = WAIT;
                    next_UART_TX = 1'b1;
                    next_SND_DATA = data_in;
                    next_count_bit = 4'd0;
                    next_data_led = data_led;
                end else begin
                    next_state = SEND;
                    next_UART_TX = UART_TX;
                    next_SND_DATA = SND_DATA;
                    next_count_bit = count_bit;
                    next_data_led = data_led;
                end
            end
        end
    endcase
end

endmodule