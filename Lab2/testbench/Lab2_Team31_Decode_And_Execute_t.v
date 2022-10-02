`timescale 1ns/1ps

module Decode_And_Execute_t;
reg [4-1:0] rs = 4'b1000, rt = 4'b0010;
reg [3-1:0] sel = 3'b000;
wire [4-1:0] rd;

Decode_And_Execute DE(
    .rs(rs),
    .rt(rt),
    .sel(sel),
    .rd(rd)
);

initial begin
    repeat (6) begin
        #1 rs = rs + 2'b10;
        rt = rt + 1'b1;
        sel = sel + 1'b1;
    end
    // eq and lt unfinished
    repeat (6) begin
        #1 rs = rs + 2'b10;
        rt = rt + 1'b1;
    end
    #1 sel = sel + 1'b1;
    repeat (6) begin
        #1 rs = rs + 2'b10;
        rt = rt + 1'b1;
    end
    #1 rs = 4'b1010;
    rt = 4'b1010;
    #1 $finish;
end

endmodule
