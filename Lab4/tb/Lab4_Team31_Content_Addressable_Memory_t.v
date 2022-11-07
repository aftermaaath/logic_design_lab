`timescale 1ns/1ps

module Mealy_Sequence_Detector_t;
reg clk = 1'b1;
reg rst_n = 1'b0;
reg in = 1'b0;
wire dec;
//wire [4:0]state;

// specify duration of a clock cycle.
parameter cyc = 10;

// generate clock.
always #(cyc/2) clk = ~clk;

Mealy_Sequence_Detector msc (
    .clk (clk),
    .rst_n (rst_n),
    .in (in),
    .dec (dec)
//    .state(state)
);

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
// initial begin
//     $fsdbDumpfile("Mealy.fsdb");
//     $fsdbDumpvars;
// end

initial begin
    @ (negedge clk) rst_n = 1'b1;
    in = 1'b0;
    @ (negedge clk) in = 1'b1;
    @ (negedge clk) in = 1'b1;
    @ (negedge clk) in = 1'b1;
    @ (negedge clk) in = 1'b0;
    @ (negedge clk) in = 1'b1;
    @ (negedge clk) in = 1'b1;
    @ (negedge clk) in = 1'b0;
    @ (negedge clk) in = 1'b1;
    @ (negedge clk) in = 1'b1;
    @ (negedge clk) in = 1'b0;
    @ (negedge clk) in = 1'b1;
    @ (negedge clk) in = 1'b0;
    @ (negedge clk) in = 1'b1;
    @ (negedge clk) in = 1'b0;
    @ (negedge clk) in = 1'b0;

    @ (negedge clk) in = 1'b0;
    @ (negedge clk) in = 1'b1;
    @ (negedge clk) in = 1'b1;
    @ (negedge clk) in = 1'b1;

    @ (negedge clk) in = 1'b0;
    @ (negedge clk) in = 1'b0;
    @ (negedge clk) in = 1'b0;
    @ (negedge clk) in = 1'b0;

    @ (negedge clk) in = 1'b1;
    @ (negedge clk) in = 1'b1;
    @ (negedge clk) in = 1'b0;
    @ (negedge clk) in = 1'b1;

    @ (negedge clk) in = 1'b1;
    @ (negedge clk) in = 1'b1;
    @ (negedge clk) in = 1'b1;
    @ (negedge clk) in = 1'b0;

    @ (negedge clk) in = 1'b1;
    @ (negedge clk) in = 1'b0;
    @ (negedge clk) in = 1'b1;
    @ (negedge clk) in = 1'b1;

    @ (negedge clk) in = 1'b0;
    @ (negedge clk) in = 1'b1;
    @ (negedge clk) in = 1'b1;
    @ (negedge clk) in = 1'b1;

    @ (negedge clk) $finish;
end

endmodule
