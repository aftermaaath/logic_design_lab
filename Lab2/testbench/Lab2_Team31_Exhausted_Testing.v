`timescale 1ns/1ps

module Exhausted_Testing(a, b, cin, error, done);
output [4-1:0] a, b;
output cin;
output error;
output done;

// input signal to the test instance.
reg [4-1:0] a = 4'b0000;
reg [4-1:0] b = 4'b0000;
reg cin = 1'b0;

// initial value for the done and error indicator: not done, no error
reg done = 1'b0;
reg error = 1'b0;


// output from the test instance.
wire [4-1:0] sum;
wire cout;

// instantiate the test instance.
Ripple_Carry_Adder rca(
    .a (a), 
    .b (b), 
    .cin (cin),
    .cout (cout),
    .sum (sum)
);

initial begin
    repeat(2**1)begin
        repeat(2**4) begin
            repeat(2**4) begin
                #1;
                error = 1'b0;
                if({cout, sum[3:0]}!==a[3:0]+b[3:0]+cin) begin
                    error = 1'b1;
                end
                else begin
                end
                #4;
                a = a+4'b0001;
            end
            b = b+4'b0001;
        end
        cin = cin +1'b1;
    end
    done = 1'b1;
    #1 error = 1'b0;
    #5 done = 1'b0;
end

endmodule
