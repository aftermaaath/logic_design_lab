`timescale 1ns/1ps

module Traffic_Light_Controller_t;
reg clk = 1'b1;
reg rst_n = 1'b1;
reg lr_has_car = 1'b0;
wire [2:0] hw_light;
wire [2:0] lr_light;
// wire [2:0]st;
parameter cyc = 10;

always #(cyc/2) clk = ~clk;

Traffic_Light_Controller tlc (
    .clk (clk),
    .rst_n (rst_n),
    .lr_has_car (lr_has_car),
    .hw_light (hw_light),
    .lr_light(lr_light)
);
initial begin
    @(negedge clk) rst_n = 1'b0;
    #10 rst_n = 1'b1;
    #680 lr_has_car = 1'b1;
    #3000 lr_has_car = 1'b0;
    #700 lr_has_car = 1'b1;
    #3500 lr_has_car = 1'b0;
    #200 lr_has_car = 1'b1;
    #100 lr_has_car = 1'b0;
    #300 lr_has_car = 1'b1;
    #4000 rst_n = 1'b0;
    #10 rst_n = 1'b1;
    #6000 $finish;
end
endmodule