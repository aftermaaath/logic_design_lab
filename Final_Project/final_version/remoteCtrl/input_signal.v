`timescale 1ns / 1ps

module input_signal_btn(
    input clk,
    input rst,
    input [3:0] dir,
    output reg [3:0] data
);

wire [3:0] dir_db;
debounce d1 [3:0] (dir_db, dir, clk);

always@(posedge clk) begin
    if(rst) data <= 4'b0;
    else data <= dir_db;
end

endmodule

module input_signal_joystick(
    input clk,
    input rst,
    input [15:0] dir_x,
    input [15:0] dir_y,
    output reg [3:0] data
);

reg [3:0] cur_data;

always@(posedge clk) begin
    if(rst) data <= 4'b0;
    else data <= cur_data;
end

always@(*) begin
    if(dir_x[15:12] == 4'd1) cur_data[0] = 1'b1;
    else cur_data[0] = 1'b0;
    if(dir_x[15:12] == 4'd0 && dir_x[11:8] <= 4'd2) cur_data[1] = 1'b1;
    else cur_data[1] = 1'b0;
    if(dir_y[15:12] == 4'd1) cur_data[2] = 1'b1;
    else cur_data[2] = 1'b0;
    if(dir_y[15:12] == 4'd0 && dir_y[11:8] <= 4'd2) cur_data[3] = 1'b1;
    else cur_data[3] = 1'b0;
end

endmodule

module xy_assign(
    input clk,
    input rst,
    input [15:0] data_xy,
    output reg [1:0] sw_ctrl,
    output reg [15:0] data_x,
    output reg [15:0] data_y
);

wire div_clk;
reg [15:0] pre_data_x, pre_data_y;
reg [1:0] sw_delay;
reg [25:0] ct;
div_clk dc(div_clk, clk);

always@(posedge clk) begin
    if(rst) begin
        sw_ctrl <= 2'b0;
    end else begin
        if(div_clk) begin
            if(sw_ctrl == 2'b0) begin
                sw_ctrl <= 2'b10;
            end else begin
                sw_ctrl <= 2'b0;
            end
        end else begin
            sw_ctrl <= sw_ctrl;
        end
    end
end

always@(posedge clk) begin
    if(rst) begin
        sw_delay <= 2'b0;
        ct <= 26'b0;
    end else begin
        if(sw_delay == sw_ctrl) begin
            sw_delay <= sw_delay;
            ct <= 26'b0;
        end else if(ct == 2 ** 23 + 2 ** 20) begin
            sw_delay <= sw_ctrl;
            ct <= 26'b0;
        end else begin
            sw_delay <= sw_delay;
            ct <= ct + 1'b1;
        end
    end
end

always@(posedge clk) begin
    if(rst) begin
        pre_data_x <= 16'b0;
        pre_data_y <= 16'b0;
    end else begin
        pre_data_x <= data_x;
        pre_data_y <= data_y;
    end
end

always@(*) begin
    if(sw_delay == 2'b0) begin
        data_x = data_xy;
        data_y = pre_data_y;
    end else begin
        data_x = pre_data_x;
        data_y = data_xy;
    end
end

endmodule