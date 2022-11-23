`timescale 1ns/1ps

module Traffic_Light_Controller (clk, rst_n, lr_has_car, hw_light, lr_light);
input clk, rst_n;
input lr_has_car;
output [2:0] hw_light;
output [2:0] lr_light;
// output [2:0] st;
reg [2:0]st;
reg [2:0]nxt_st;
wire [6:0]cyc;
reg st_change;
reg [2:0] hw_light, nxt_hw;
reg [2:0] lr_light, nxt_lr;
parameter S0 = 4'd0;
parameter S1 = 4'd1;
parameter S2 = 4'd2;
parameter S3 = 4'd3;
parameter S4 = 4'd4;
parameter S5 = 4'd5;
parameter Red = 3'b001;
parameter Yellow = 3'b010;
parameter Green = 3'b100;

count_cyc cc(rst_n, st_change, clk, cyc);
always@(posedge clk)begin
    if(!rst_n) begin
        st <= S0;
        hw_light <= Green;
        lr_light <= Red;
    end
    else begin
        st <= nxt_st;
        hw_light <= nxt_hw;
        lr_light <= nxt_lr;
    end
end
always@(*)begin
    case(st)
    S0:begin
        if(cyc == 7'd69 && lr_has_car)begin
            nxt_st = S1;
            nxt_hw = Yellow;
            nxt_lr = Red;
            st_change = 1'b1;
        end
        else begin
            nxt_st = S0;
            nxt_hw = Green;
            nxt_lr = Red;
            st_change = 1'b0;
        end
    end
    S1:begin
        if(cyc == 7'd24)begin
            nxt_st = S2;
            nxt_hw = Red;
            nxt_lr = Red;
            st_change = 1'b1;
        end
        else begin
            nxt_st = S1;
            nxt_hw = Yellow;
            nxt_lr = Red;
            st_change = 1'b0;
        end
    end
    S2:begin
        nxt_st = S3;
        nxt_hw = Red;
        nxt_lr = Green;
        st_change = 1'b1;
    end
    S3:begin
        if(cyc == 7'd69)begin
            nxt_st = S4;
            nxt_hw = Red;
            nxt_lr = Yellow;
            st_change = 1'b1;
        end
        else begin
            nxt_st = S3;
            nxt_hw = Red;
            nxt_lr = Green;
            st_change = 1'b0;
        end
    end
    S4:begin
        if(cyc == 7'd24)begin
            nxt_st = S5;
            nxt_hw = Red;
            nxt_lr = Red;
            st_change = 1'b1;
        end
        else begin
            nxt_st = S4;
            nxt_hw = Red;
            nxt_lr = Yellow;
            st_change = 1'b0;
        end
    end
    S5:begin
        nxt_st = S0;
        nxt_hw = Green;
        nxt_lr = Red;
        st_change = 1'b1;
    end
    endcase
end

endmodule
module count_cyc(rst_n, st_change, clk, cyc);
input clk, rst_n, st_change;
output [6:0] cyc;
reg [6:0]cyc;
wire [6:0]nxt_cyc;
assign nxt_cyc = ((cyc==7'd69) ? cyc : (cyc+1'b1));
always@(posedge clk)begin
    if(!rst_n || st_change) cyc <= 7'b0;
    else begin
        cyc <= nxt_cyc;
    end
end
endmodule