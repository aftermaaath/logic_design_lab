module state_trans(
    input [3:0] dir,
    output reg [3:0] state
);

parameter stop = 4'd0;
parameter go_straight = 4'd1;
parameter go_left = 4'd2;
parameter go_right = 4'd3;
parameter go_back = 4'd4;
parameter left_front = 4'd5; 
parameter right_front = 4'd6;
parameter left_back = 4'd7;
parameter right_back = 4'd8;

// up down left right
always@(*) begin
    case(dir)
        4'b0000: state = stop;
        4'b0001: state = go_right;
        4'b0010: state = go_left;
        4'b0011: state = stop;
        // ----------
        4'b0100: state = go_back;
        4'b0101: state = right_back;
        4'b0110: state = left_back;
        4'b0111: state = go_back;
        // ----------
        4'b1000: state = go_straight;
        4'b1001: state = right_front;
        4'b1010: state = left_front;
        4'b1011: state = go_straight;
        // ----------
        4'b1100: state = stop;
        4'b1101: state = go_right;
        4'b1110: state = go_left;
        4'b1111: state = stop;
        default: state = stop;
    endcase
end

endmodule