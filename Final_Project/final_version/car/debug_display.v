`timescale 1ns / 1ps

module state_display(
    input [3:0] state,
    output reg [6:0] state_7seg,
    output wire [3:0] an
);

assign an = 4'b1110;
    
always @ (*) begin
	case (state)
		4'd0 : state_7seg = 7'b1000000;
		4'd1 : state_7seg = 7'b1111001;
		4'd2 : state_7seg = 7'b0100100;
		4'd3 : state_7seg = 7'b0110000;
		4'd4 : state_7seg = 7'b0011001;
        4'd5 : state_7seg = 7'b0010010;
        4'd6 : state_7seg = 7'b0000010;
        4'd7 : state_7seg = 7'b1111000;
        4'd8 : state_7seg = 7'b0000000;
		default : state_7seg = 7'b1111111;
	endcase
end

endmodule

module led_display(
    input [15:0] in_led,
    output wire [15:0] led
);

assign led = in_led;

endmodule
