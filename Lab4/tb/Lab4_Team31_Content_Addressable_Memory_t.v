`timescale 1ns/1ps

module Lab4_TeamX_Content_Addressable_Memory_t;
reg clk = 1'b0;
reg wen, ren;
reg[7:0]din;
reg[3:0]addr;
wire [3:0]dout;
wire hit;
// specify duration of a clock cycle.
parameter cyc = 10;

// generate clock.
always #(cyc/2) clk = ~clk;

Content_Addressable_Memory cam (
    .clk (clk),
    .wen (wen),
    .ren (ren),
    .din(din),
    .addr(addr),
    .dout (dout),
    .hit (hit)
);

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
// initial begin
//     $fsdbDumpfile("Mealy.fsdb");
//     $fsdbDumpvars;
// end

initial begin
    @ (negedge clk) addr = 4'd0; // write only
    din = 8'd0;
    ren = 1'b0;
    wen = 1'b1;
    @ (negedge clk) addr = 4'd0;
    din = 8'd4;
    @ (negedge clk) addr = 4'd7;
    din = 8'd8;
    @ (negedge clk) addr = 4'd15;
    din = 8'd35;
    @ (negedge clk) addr = 4'd9;
    din = 8'd8;
    @ (negedge clk) addr = 4'd10;
    din = 8'd100;
    @ (negedge clk) addr = 4'd1;
    din = 8'd30;
    @ (negedge clk) addr = 4'd12;
    din = 8'd255;
    @ (negedge clk) addr = 4'd5;
    din = 8'd100;
    @ (negedge clk) addr = 4'd8;
    din = 8'd223;
    
    @ (negedge clk) addr = 4'd0;
    din = 8'd0;
    wen = 1'b0;

    @ (negedge clk)ren = 1'b1; // read only
    wen = 1'b0;
    din = 8'd4;
    @ (negedge clk) din = 8'd8;
    addr = 4'd1;
    @ (negedge clk) din = 8'd35;
    addr = 4'd5;
    @ (negedge clk) din = 8'd87;
    addr = 4'd8;
    @ (negedge clk) din = 8'd45;
    addr = 4'd0;
    @ (negedge clk) ren = 1'b0;

    @ (negedge clk) ren = 1'b1; // ren > wen
    wen = 1'b1;
    din = 8'd100;
    @ (negedge clk) din = 8'd30;
    addr = 4'd5;
    @ (negedge clk) din = 8'd255;
    addr = 4'd8;
    @ (negedge clk) din = 8'd223;
    addr = 4'd0;
    @ (negedge clk) din = 8'd3;
    @ (negedge clk) din = 8'd30;
    @ (negedge clk) din = 8'd5;
    @ (negedge clk) din = 8'd255;

    @ (negedge clk) wen = 1'b0;
    ren = 1'b0;

    @ (negedge clk) $finish;
end

endmodule
