`timescale 1ns/1ps

module Lab4_Team32_BIST_t;
reg clk = 1'b1;
reg rst_n = 1'b0;
reg scan_en = 1'b0;
wire scan_in;
wire scan_out;

parameter cyc = 10;

always#(cyc/2)clk = !clk;

Built_In_Self_Test BIST(clk, rst_n, scan_en, scan_in, scan_out);

initial begin
    #12 
	rst_n = 1'b1;
	#3
	scan_en = 1'b1;
	repeat(8)begin
	   #80 scan_en = 1'b0;
	   #10 scan_en = 1'b1;
	end
	#80 $finish;
end
endmodule

//module Built_In_Self_Test_t();
//reg clk = 1'b0, rst_n = 1'b0, scan_en = 1'b0;
//wire scan_in, scan_out;

//always #5 clk = ~clk;

//Built_In_Self_Test bist(
//    .clk(clk),
//    .rst_n(rst_n),
//    .scan_en(scan_en),
//    .scan_in(scan_in),
//    .scan_out(scan_out)
//);

//initial begin
//    #10 rst_n = 1'b1;
//    scan_en = 1'b1;
//    scan_en = 1'b0;
//    #10 scan_en = 1'b1;
//    #80 scan_en = 1'b0;
    
//    #10 scan_en = 1'b1;
//    scan_en = 1'b0;
//    #10 scan_en = 1'b1;
    
//    #80 $finish;
//end

//endmodule
