`timescale 1ns/1ps

module remoteCtrl_top(
    input clk, // W5
    input en, //  V16
    input rst, // V17
    input [3:0] dir_btn, // T18, U17, W19, T17
    input speed_up, // W16 
    input dir_input, // W17
    input [1:0] turn, // R2, T1
    input shoot, // U18
    input vauxp6, // J3
    input vauxn6, // K3
    input vauxp7, // M2
    input vauxn7, // M1
    input vauxp15, // N2
    input vauxn15, // N1
    input vauxp14, // L3
    input vauxn14, // M3
    input vp_in,
    input vn_in,
    output wire data, // L17
    output wire [7:0] send_led, //  L1, P1, N3, P3, U3, W3, V3, V13
    output wire [3:0] state_led // V19, U19, E19, U16
);

wire [3:0] state, state1, state2;
wire [15:0] data_x, data_y;
wire [15:0] data_xy;
wire UART_clk;
wire shoot_db;
wire [1:0] sw_ctrl;
debounce d1(shoot_db, shoot, clk);
assign state_led = state;
assign state = dir_input ? state2 : state1;

clk_divider_UART #( .N(14), .MAX(10420)) cd1 (
    .dclk(UART_clk),
    .clk(clk),
    .rst(rst)
);

UART_TXD t1(
    .clk(clk),
    .UART_clk(UART_clk),
    .rst(rst),
    .data_in({state, speed_up, turn, shoot_db}),
    .en(en),
    .data_led(send_led),
    .UART_TX(data)
);

input_signal_btn is(
    .clk(clk),
    .rst(rst),
    .dir(dir_btn),
    .data(state1)
);

input_signal_joystick isj(
    .clk(clk),
    .rst(rst),
    .dir_x(data_x),
    .dir_y(data_y),
    .data(state2)
);

xy_assign xy(
    .clk(clk),
    .rst(rst),
    .data_xy(data_xy),
    .sw_ctrl(sw_ctrl),
    .data_x(data_x),
    .data_y(data_y)
);

XADCdemo xadc(
    .CLK100MHZ(clk),
    .vauxp6(vauxp6),
    .vauxn6(vauxn6),
    .vauxp7(vauxp7),
    .vauxn7(vauxn7),
    .vauxp15(vauxp15),
    .vauxn15(vauxn15),
    .vauxp14(vauxp14),
    .vauxn14(vauxn14),
    .vp_in(vp_in),
    .vn_in(vn_in),
    .sw(sw_ctrl),
    .dp(),
    .sseg_data(data_xy),
    .an(),
    .seg()
);

endmodule