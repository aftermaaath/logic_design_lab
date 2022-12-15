`timescale 1ns/1ps
module tracker_sensor(clk, reset, left_signal, right_signal, mid_signal, state);
    input clk;
    input reset;
    input left_signal, right_signal, mid_signal; // black low, white high
    output reg [2:0] state;

    // [TO-DO] Receive three signals and make your own policy.
    // Hint: You can use output state to change your action.

    reg [2:0]next_state;
    wire [2:0]signal;
    
    assign signal = {left_signal, mid_signal, right_signal};
    
    parameter turn_left = 3'd0;
    parameter turn_right = 3'd1;
    parameter go_straight = 3'd2;
    parameter sharp_turn_left = 3'd3;
    parameter sharp_turn_right = 3'd4;
     parameter back = 3'd5;
    
    always@(posedge clk)begin
        if(reset) state <= go_straight;
        else state <= next_state;
    end
    always@(*)begin
//         case(signal)
//             3'b000:next_state = back; // all black, go back and redetect
//             3'b001:next_state = sharp_turn_right;
//             3'b010:next_state = back;
//             3'b011:next_state = turn_right;
//             3'b100:next_state = sharp_turn_left;
//             3'b110:next_state = turn_left;
//             3'b111:next_state = go_straight; // all white
//             default:next_state = go_straight;
//         endcase
    case(state)
            go_straight:begin
                if(left_signal==1'b0 && right_signal==1'b1) next_state = turn_right;
                else if(left_signal==1'b1 && right_signal==1'b0) next_state = turn_left;
                // else if(left_signal == 1'b0 && right_signal == 1'b0) next_state = back;
                else next_state = go_straight;
            end
            turn_left:begin
                if(right_signal==1'b0) begin
                    if(mid_signal==1'b0) next_state = sharp_turn_left;
                    else next_state = turn_left;
                end
                else next_state = go_straight;
            end
            turn_right:begin
                if(left_signal==1'b0) begin
                    if(mid_signal==1'b0) next_state = sharp_turn_right;
                    else next_state = turn_right;
                end
                else next_state = go_straight;
            end
            sharp_turn_left:begin
                if(mid_signal==1'b0) next_state = sharp_turn_left;
                else next_state = turn_left;
            end
            sharp_turn_right:begin
                if(mid_signal==1'b0) next_state = sharp_turn_right;
                else next_state = turn_right;
            end
            default:begin
                next_state = go_straight;
            end
    endcase
    end
endmodule
