`timescale 1ns/1ps

module Mealy_Sequence_Detector (clk, rst_n, in, dec);
input clk, rst_n;
input in;
output dec;
// output [2:0]state_0, state_1, state_2;


wire dec;
reg [2:0]tmp_dec;
reg [2:0]state[2:0];
reg [2:0]nxt_state[2:0];
reg [2:0]cnt;
reg [2:0]nxt_cnt;
parameter S0 = 2'd0;
parameter S1 = 2'd1;
parameter S2 = 2'd2;
parameter S3 = 2'd3;
assign dec = tmp_dec[0] | tmp_dec[1] | tmp_dec[2];
// wire [2:0]state_0 = state[0];
// wire [2:0]state_1 = state[1];
// wire [2:0]state_2 = state[2];
always@(posedge clk)begin
    if(!rst_n)begin
        // cnt <= 1'b0;
        state[0] <= S0;
        state[1] <= S0;
        state[2] <= S0;
    end
    else begin
        // if(dec == 1'b1) begin
        //     state[0] <= S0;
        //     state[1] <= S0;
        //     state[2] <= S0;
        // end
        // else begin
            state[0] <= nxt_state[0];
            state[1] <= nxt_state[1];
            state[2] <= nxt_state[2];
        // end
    end
end
always@(*)begin
    case(state[0])
    S0: begin
        if(in == 1'b0)begin
            nxt_state[0] = S1;
            tmp_dec[0] = 1'b0;
        end
        else begin
            nxt_state[0] = S0;
            tmp_dec[0] = 1'b0;
        end
    end
    S1:begin
        if(in == 1'b0)begin
            nxt_state[0] = S0;
            tmp_dec[0] = 1'b0;
        end
        else begin
            nxt_state[0] = S2;
            tmp_dec[0] = 1'b0;
        end
    end
    S2:begin
        if(in == 1'b0)begin
            nxt_state[0] = S0;
            tmp_dec[0] = 1'b0;
        end
        else begin
            nxt_state[0] = S3;
            tmp_dec[0] = 1'b0;
        end
    end
    default:begin
        if(in == 1'b0)begin
            nxt_state[0] = S1;
            // nxt_state[0] = S0;
            tmp_dec[0] = 1'b0;
        end
        else begin
            nxt_state[0] = S0;
            tmp_dec[0] = 1'b1;
        end
    end
    endcase
    
    case(state[1])
    S0: begin
        if(in == 1'b0)begin
            nxt_state[1] = S0;
            tmp_dec[1] = 1'b0;
        end
        else begin
            nxt_state[1] = S1;
            tmp_dec[1] = 1'b0;
        end
    end
    S1:begin
        if(in == 1'b0)begin
            nxt_state[1] = S2;
            tmp_dec[1] = 1'b0;
        end
        else begin
            nxt_state[1] = S1;
            tmp_dec[1] = 1'b0;
        end
    end
    S2:begin
        if(in == 1'b0)begin
            nxt_state[1] = S0;
            tmp_dec[1] = 1'b0;
        end
        else begin
            nxt_state[1] = S3;
            tmp_dec[1] = 1'b0;
        end
    end
    default:begin
        if(in == 1'b0)begin
            nxt_state[1] = S2;
            tmp_dec[1] = 1'b0;
        end
        else begin
            nxt_state[1] = S1;
            // nxt_state[1] = S0;
            tmp_dec[1] = 1'b1;
        end
    end
    endcase
    
    case(state[2])
    S0: begin
        if(in == 1'b0)begin
            nxt_state[2] = S0;
            tmp_dec[2] = 1'b0;
        end
        else begin
            nxt_state[2] = S1;
            tmp_dec[2] = 1'b0;
        end
    end
    S1:begin
        if(in == 1'b0)begin
            nxt_state[2] = S0;
            tmp_dec[2] = 1'b0;
        end
        else begin
            nxt_state[2] = S2;
            tmp_dec[2] = 1'b0;
        end
    end
    S2:begin
        if(in == 1'b0)begin
            nxt_state[2] = S3;
            tmp_dec[2] = 1'b0;
        end
        else begin
            nxt_state[2] = S2;
            tmp_dec[2] = 1'b0;
        end
    end
    default:begin
        if(in == 1'b0)begin
            nxt_state[2] = S0;
            tmp_dec[2] = 1'b1;
        end
        else begin
            nxt_state[2] = S1;
            // nxt_state[2] = S0;
            tmp_dec[2] = 1'b0;
        end
    end
    endcase
    if(state[0] == S3 || state[1] == S3 || state[2] == S3) begin
        nxt_state[0] = S0;
        nxt_state[1] = S0;
        nxt_state[2] = S0;
    end
    else;
    // dec = ((cnt == 3'd4) ? (tmp_dec[0] | tmp_dec[1] | tmp_dec[2]) : 1'b0);
    // cnt = (cnt == 3'd4) ? 3'd0 : cnt + 1'b1;
end
endmodule
