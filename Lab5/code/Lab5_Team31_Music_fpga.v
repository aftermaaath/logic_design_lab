`timescale 1ns/1ps

`define C4 32'd262
`define D4 32'd294
`define E4 32'd330
`define F4 32'd349
`define G4 32'd392
`define A4 32'd440
`define B4 32'd494
`define C5 32'd523
`define D5 32'd587
`define E5 32'd659
`define F5 32'd698
`define G5 32'd784
`define A5 32'd880
`define B5 32'd988
`define C6 32'd1047
`define sli 32'd20000 //slience (over freq.)

module music_fpga(PS2_DATA, PS2_CLK, clk, pmod_1, pmod_2, pmod_4);

reg state, next_state, next_state_1, rst_sig, enter_press;
reg [31:0] speed, next_speed, next_speed_1;
wire rst;

// ==================================
// audio module

inout wire PS2_DATA;
inout wire PS2_CLK;
input wire clk;

output pmod_1;
output wire pmod_2;
output wire pmod_4;

parameter BEAT_FREQ_0 = 32'd1;	//one beat=1sec
parameter BEAT_FREQ_1 = 32'd4;	//one beat=0.5sec
parameter DUTY_BEST = 10'd512;    //duty cycle=50%

wire [31:0] freq;
wire [7:0] ibeatNum;
wire beatFreq;

assign pmod_2 = 1'd1;	//no gain(6dB)
assign pmod_4 = 1'd1;	//turn-on

//Generate beat speed
PWM_gen btSpeedGen ( .clk(clk), 
					 .reset(rst),
					 .freq(speed),
					 .duty(DUTY_BEST), 
					 .PWM(beatFreq)
);
	
//manipulate beat
PlayerCtrl playerCtrl_00 ( .clk(beatFreq),
						   .reset(rst),
						   .ibeat(ibeatNum),
						   .state(state)
);	
	
//Generate variant freq. of tones
Music music00 ( .ibeatNum(ibeatNum),
				.tone(freq)
);

// Generate particular freq. signal
PWM_gen toneGen ( .clk(clk), 
				  .reset(rst), 
				  .freq(freq),
				  .duty(DUTY_BEST), 
				  .PWM(pmod_1)
);

// ====================================

OnePulse op (
    .signal_single_pulse(rst),
    .signal(rst_sig),
    .clock(clk)
);

// ====================================

parameter [8:0] KEY_CODES_w = 9'h1d;
parameter [8:0] KEY_CODES_s = 9'h1b;
parameter [8:0] KEY_CODES_r = 9'h2d;
parameter [8:0] KEY_CODES_enter = 9'h5a;

reg [9:0] last_key;

wire shift_down;
wire [511:0] key_down;
wire [8:0] last_change;
wire been_ready;
    
KeyboardDecoder key_de (
    .key_down(key_down),
    .last_change(last_change),
    .key_valid(been_ready),
    .PS2_DATA(PS2_DATA),
    .PS2_CLK(PS2_CLK),
    .rst(rst),
    .clk(clk)
);

always @ (posedge clk, posedge rst) begin
    if (rst) begin
        state <= 1'b1;
        speed <= BEAT_FREQ_0;
        rst_sig <= 1'b0;
    end else begin
        state <= next_state_1;
        speed <= next_speed_1;
        rst_sig <= enter_press;
    end
end

always@(*) begin
    case (last_change)
        KEY_CODES_w : begin
            next_state = 1'b1;
            next_speed = speed;
            enter_press = 1'b0;
        end
        KEY_CODES_s : begin
            next_state = 1'b0;
            next_speed = speed;
            enter_press = 1'b0;
        end
        KEY_CODES_r : begin
            next_state = state;
            next_speed = speed == BEAT_FREQ_0 ? BEAT_FREQ_1 : BEAT_FREQ_0;
            enter_press = 1'b0;
        end
        KEY_CODES_enter : begin
            next_state = 1'b1;
            next_speed = BEAT_FREQ_0;
            enter_press = 1'b1;
        end
        default: begin
            next_state = state;
            next_speed = speed;
            enter_press = 1'b0;
        end
    endcase
end

always @ (*) begin
    if (been_ready && key_down[last_change] == 1'b1) begin
        next_state_1 = next_state;
        next_speed_1 = next_speed;
    end
    else begin
        next_state_1 = state;
        next_speed_1 = speed;
    end    
end

endmodule

module KeyboardDecoder(
    output reg [511:0] key_down,
    output wire [8:0] last_change,
    output reg key_valid,
    inout wire PS2_DATA,
    inout wire PS2_CLK,
    input wire rst,
    input wire clk
    );
    
    parameter [1:0] INIT			= 2'b00;
    parameter [1:0] WAIT_FOR_SIGNAL = 2'b01;
    parameter [1:0] GET_SIGNAL_DOWN = 2'b10;
    parameter [1:0] WAIT_RELEASE    = 2'b11;
    
    parameter [7:0] IS_INIT			= 8'hAA;
    parameter [7:0] IS_EXTEND		= 8'hE0;
    parameter [7:0] IS_BREAK		= 8'hF0;
    
    reg [9:0] key, next_key;		// key = {been_extend, been_break, key_in}
    reg [1:0] state, next_state;
    reg been_ready, been_extend, been_break;
    reg next_been_ready, next_been_extend, next_been_break;
    
    wire [7:0] key_in;
    wire is_extend;
    wire is_break;
    wire valid;
    wire err;
    
    wire [511:0] key_decode = 1 << last_change;
    assign last_change = {key[9], key[7:0]};
    
    KeyboardCtrl_0 inst (
        .key_in(key_in),
        .is_extend(is_extend),
        .is_break(is_break),
        .valid(valid),
        .err(err),
        .PS2_DATA(PS2_DATA),
        .PS2_CLK(PS2_CLK),
        .rst(rst),
        .clk(clk)
    );
    
    OnePulse op (
        .signal_single_pulse(pulse_been_ready),
        .signal(been_ready),
        .clock(clk)
    );
    
    always @ (posedge clk, posedge rst) begin
        if (rst) begin
            state <= INIT;
            been_ready  <= 1'b0;
            been_extend <= 1'b0;
            been_break  <= 1'b0;
            key <= 10'b0_0_0000_0000;
        end else begin
            state <= next_state;
            been_ready  <= next_been_ready;
            been_extend <= next_been_extend;
            been_break  <= next_been_break;
            key <= next_key;
        end
    end
    
    always @ (*) begin
        case (state)
            INIT:            next_state = (key_in == IS_INIT) ? WAIT_FOR_SIGNAL : INIT;
            WAIT_FOR_SIGNAL: next_state = (valid == 1'b0) ? WAIT_FOR_SIGNAL : GET_SIGNAL_DOWN;
            GET_SIGNAL_DOWN: next_state = WAIT_RELEASE;
            WAIT_RELEASE:    next_state = (valid == 1'b1) ? WAIT_RELEASE : WAIT_FOR_SIGNAL;
            default:         next_state = INIT;
        endcase
    end
    always @ (*) begin
        next_been_ready = been_ready;
        case (state)
            INIT:            next_been_ready = (key_in == IS_INIT) ? 1'b0 : next_been_ready;
            WAIT_FOR_SIGNAL: next_been_ready = (valid == 1'b0) ? 1'b0 : next_been_ready;
            GET_SIGNAL_DOWN: next_been_ready = 1'b1;
            WAIT_RELEASE:    next_been_ready = next_been_ready;
            default:         next_been_ready = 1'b0;
        endcase
    end
    always @ (*) begin
        next_been_extend = (is_extend) ? 1'b1 : been_extend;
        case (state)
            INIT:            next_been_extend = (key_in == IS_INIT) ? 1'b0 : next_been_extend;
            WAIT_FOR_SIGNAL: next_been_extend = next_been_extend;
            GET_SIGNAL_DOWN: next_been_extend = next_been_extend;
            WAIT_RELEASE:    next_been_extend = (valid == 1'b1) ? next_been_extend : 1'b0;
            default:         next_been_extend = 1'b0;
        endcase
    end
    always @ (*) begin
        next_been_break = (is_break) ? 1'b1 : been_break;
        case (state)
            INIT:            next_been_break = (key_in == IS_INIT) ? 1'b0 : next_been_break;
            WAIT_FOR_SIGNAL: next_been_break = next_been_break;
            GET_SIGNAL_DOWN: next_been_break = next_been_break;
            WAIT_RELEASE:    next_been_break = (valid == 1'b1) ? next_been_break : 1'b0;
            default:         next_been_break = 1'b0;
        endcase
    end
    always @ (*) begin
        next_key = key;
        case (state)
            INIT:            next_key = (key_in == IS_INIT) ? 10'b0_0_0000_0000 : next_key;
            WAIT_FOR_SIGNAL: next_key = next_key;
            GET_SIGNAL_DOWN: next_key = {been_extend, been_break, key_in};
            WAIT_RELEASE:    next_key = next_key;
            default:         next_key = 10'b0_0_0000_0000;
        endcase
    end

    always @ (posedge clk, posedge rst) begin
        if (rst) begin
            key_valid <= 1'b0;
            key_down <= 511'b0;
        end else if (key_decode[last_change] && pulse_been_ready) begin
            key_valid <= 1'b1;
            if (key[8] == 0) begin
                key_down <= key_down | key_decode;
            end else begin
                key_down <= key_down & (~key_decode);
            end
        end else begin
            key_valid <= 1'b0;
            key_down <= key_down;
        end
    end

endmodule

module OnePulse (
    output reg signal_single_pulse,
    input wire signal,
    input wire clock
    );
    
    reg signal_delay;

    always @(posedge clock) begin
        if (signal == 1'b1 & signal_delay == 1'b0)
            signal_single_pulse <= 1'b1;
        else
            signal_single_pulse <= 1'b0;
        signal_delay <= signal;
    end
endmodule

module Music (
	input [7:0] ibeatNum,	
	output reg [31:0] tone
);

always @(*) begin
	case (ibeatNum)
		8'd0 : tone = `C4;
		8'd1 : tone = `D4;
		8'd2 : tone = `E4;
		8'd3 : tone = `F4;
		8'd4 : tone = `G4;
		8'd5 : tone = `A4;
		8'd6 : tone = `B4;
		8'd7 : tone = `C5;
		8'd8 : tone = `D5;	
		8'd9 : tone = `E5;
		8'd10 : tone = `F5;
		8'd11 : tone = `G5;
		8'd12 : tone = `A5;
		8'd13 : tone = `B5;
		8'd14 : tone = `C6;
		default : tone = `sli;
	endcase
end

endmodule

module PWM_gen (
    input wire clk,
    input wire reset,
	input [31:0] freq,
    input [9:0] duty,
    output reg PWM
);

wire [31:0] count_max = 100_000_000 / freq;
wire [31:0] count_duty = count_max * duty / 1024;
reg [31:0] count;
    
always @(posedge clk, posedge reset) begin
    if (reset) begin
        count <= 0;
        PWM <= 0;
    end else if (count < count_max) begin
        count <= count + 1;
		if(count < count_duty)
            PWM <= 1;
        else
            PWM <= 0;
    end else begin
        count <= 0;
        PWM <= 0;
    end
end

endmodule

module PlayerCtrl (
	input clk,
	input reset,
	output reg [7:0] ibeat,
	input state
);
parameter BEATLEAGTH = 15;

always @(posedge clk, posedge reset) begin
	if (reset)
		ibeat <= 0;
	else if(state == 1'b1) begin
	   if(ibeat < 8'd14) ibeat <= ibeat + 1;
	   else ibeat <= 8'd14;
	end
	else begin
	   if(ibeat > 8'b0) ibeat <= ibeat - 1;
	   else ibeat <= 8'b0;
	end
end

endmodule