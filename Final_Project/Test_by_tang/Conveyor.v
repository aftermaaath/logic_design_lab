module Conveyor (
    input wire clk,
    input wire reset,
    // input [9:0] duty,
    output reg PWM
);
    parameter duty = 32'd500; // decide motor speed
    wire [31:0] count_max = 32'd100_000_000 / 32'd25000;
    wire [31:0] count_duty = count_max * duty / 32'd1024;
    reg [31:0] count;
        
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            count <= 32'b0;
            PWM <= 1'b0;
        end else if (count < count_max) begin
            count <= count + 32'd1;
            if(count < count_duty)
                PWM <= 1'b1;
            else
                PWM <= 1'b0;
        end else begin
            count <= 32'b0;
            PWM <= 1'b0;
        end
    end
endmodule