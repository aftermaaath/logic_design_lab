`timescale 1ns/1ps

module Content_Addressable_Memory(clk, wen, ren, din, addr, dout, hit);
input clk;
input wen, ren;
input [7:0] din;
input [3:0] addr;
output [3:0] dout; // output an address
output hit; // find or not
reg [7:0]CAM[15:0]; // m bits per word(data) / n words(set)
reg [3:0]dout, nxt_out_reg;
reg hit, nxt_hit_reg;
wire [3:0]nxt_out[16:0];
assign nxt_out[0] = nxt_out_reg;
wire [16:0]nxt_hit;
assign nxt_hit[0] = nxt_hit_reg;
wire [7:0]nxt_din;
assign nxt_din = (wen & !ren) ? din : CAM[addr];
always @(posedge clk) begin
    CAM[addr] <= nxt_din;
    nxt_hit_reg <= 1'b0;
    nxt_out_reg <= 4'b0;
    if(ren == 1'b1)begin
        hit <= nxt_hit[16];
        dout <= nxt_out[16];
    end
    else begin
        dout <= 4'b0;
        hit <= 1'b0;
    end
end

for_loop f0(5'd0, nxt_hit[0], nxt_out[0], nxt_hit[1], nxt_out[1], din, CAM[0]);
for_loop f1(5'd1, nxt_hit[1], nxt_out[1], nxt_hit[2], nxt_out[2], din, CAM[1]);
for_loop f2(5'd2, nxt_hit[2], nxt_out[2], nxt_hit[3], nxt_out[3], din, CAM[2]);
for_loop f3(5'd3, nxt_hit[3], nxt_out[3], nxt_hit[4], nxt_out[4], din, CAM[3]);
for_loop f4(5'd4, nxt_hit[4], nxt_out[4], nxt_hit[5], nxt_out[5], din, CAM[4]);
for_loop f5(5'd5, nxt_hit[5], nxt_out[5], nxt_hit[6], nxt_out[6], din, CAM[5]);
for_loop f6(5'd6, nxt_hit[6], nxt_out[6], nxt_hit[7], nxt_out[7], din, CAM[6]);
for_loop f7(5'd7, nxt_hit[7], nxt_out[7], nxt_hit[8], nxt_out[8], din, CAM[7]);
for_loop f8(5'd8, nxt_hit[8], nxt_out[8], nxt_hit[9], nxt_out[9], din, CAM[8]);
for_loop f9(5'd9, nxt_hit[9], nxt_out[9], nxt_hit[10], nxt_out[10], din, CAM[9]);
for_loop f10(5'd10, nxt_hit[10], nxt_out[10], nxt_hit[11], nxt_out[11], din, CAM[10]);
for_loop f11(5'd11, nxt_hit[11], nxt_out[11], nxt_hit[12], nxt_out[12], din, CAM[11]);
for_loop f12(5'd12, nxt_hit[12], nxt_out[12], nxt_hit[13], nxt_out[13], din, CAM[12]);
for_loop f13(5'd13, nxt_hit[13], nxt_out[13], nxt_hit[14], nxt_out[14], din, CAM[13]);
for_loop f14(5'd14, nxt_hit[14], nxt_out[14], nxt_hit[15], nxt_out[15], din, CAM[14]);
for_loop f15(5'd15, nxt_hit[15], nxt_out[15], nxt_hit[16], nxt_out[16], din, CAM[15]);

endmodule

module for_loop(i, hit, out, nxt_hit, nxt_out, din, cam_in);
input [4:0]i;
input hit;
input [7:0]din, cam_in;
input [3:0]out;
output nxt_hit;
output[3:0]nxt_out;
reg nxt_hit;
reg [3:0]nxt_out;
always@(*)begin
    if(hit == 1'b1)begin // found
        nxt_hit = 1'b1;
        nxt_out = out;
    end
    else begin // not found yet
        nxt_hit = 1'b0;
        if(din == cam_in)begin // if found
            nxt_out = i;
            nxt_hit = 1'b1;
        end
        else begin
            nxt_hit = 1'b0;
            nxt_out = 1'b0; // still not found
        end
    end
end
endmodule