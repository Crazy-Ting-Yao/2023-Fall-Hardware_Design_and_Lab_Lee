module Top (
    input CLK,
    inout PS2_CLK, PS2_DAT,
    output AUD_SIG, AUD_GAIN, AUD_SHUT
    );

    assign AUD_GAIN = 1'b1;
    assign AUD_SHUT = 1'b1;

    parameter [8:0] KEY_CODE_W = 9'b0_0001_1101;     // 0x1D
    parameter [8:0] KEY_CODE_S = 9'b0_0001_1011;     // 0x1B
    parameter [8:0] KEY_CODE_R = 9'b0_0010_1101;     // 0x2D
    parameter [8:0] KEY_CODE_ENTER = 9'b0_0101_1010; // 0x5A
    
    wire [511:0] key_down;
    wire [8:0] last_change;
    wire been_ready;
    
    KeyboardDecoder key_de (
        .key_down(key_down),
        .last_change(last_change),
        .key_valid(been_ready),
        .PS2_DATA(PS2_DAT),
        .PS2_CLK(PS2_CLK),
        .rst(1'b0),
        .clk(CLK)
    );

    wire btn_w, btn_s, btn_r, btn_enter;
    assign btn_w = key_down[KEY_CODE_W];
    assign btn_s = key_down[KEY_CODE_S];
    assign btn_r = key_down[KEY_CODE_R];
    assign btn_enter = key_down[KEY_CODE_ENTER];

    wire btn_w_op, btn_s_op, btn_r_op, btn_enter_op;
    One_Pulse op_w (btn_w_op, btn_w, CLK);
    One_Pulse op_s (btn_s_op, btn_s, CLK);
    One_Pulse op_r (btn_r_op, btn_r, CLK);
    One_Pulse op_enter (btn_enter_op, btn_enter, CLK);
    wire rst_n = ~btn_enter_op;

    wire [4:0] tone;
    Tone_Generator tg (CLK, rst_n, btn_w, btn_s, btn_r, tone);

    wire [31:0] freq;
    Freq_Decoder fd (tone, freq);

    PWM_gen pwm (CLK, ~rst_n, freq, 10'd512, AUD_SIG);
endmodule

// Music
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

module Freq_Decoder (
    input [4:0] tone,
    output reg [31:0] freq 
    );

    always @(*) begin
        case (tone)
            5'd00: freq = 32'd262;      // C4
            5'd01: freq = 32'd294;      // D4
            5'd02: freq = 32'd330;      // E4
            5'd03: freq = 32'd349;      // F4
            5'd04: freq = 32'd392;      // G4
            5'd05: freq = 32'd440;      // A4
            5'd06: freq = 32'd494;      // B4
            5'd07: freq = 32'd262 << 1; // C5
            5'd08: freq = 32'd294 << 1;
            5'd09: freq = 32'd330 << 1;
            5'd10: freq = 32'd349 << 1;
            5'd11: freq = 32'd392 << 1;
            5'd12: freq = 32'd440 << 1;
            5'd13: freq = 32'd494 << 1;
            5'd14: freq = 32'd262 << 2; // C6
            5'd15: freq = 32'd294 << 2;
            5'd16: freq = 32'd330 << 2;
            5'd17: freq = 32'd349 << 2;
            5'd18: freq = 32'd392 << 2;
            5'd19: freq = 32'd440 << 2;
            5'd20: freq = 32'd494 << 2;
            5'd21: freq = 32'd262 << 3; // C7
            5'd22: freq = 32'd294 << 3;
            5'd23: freq = 32'd330 << 3;
            5'd24: freq = 32'd349 << 3;
            5'd25: freq = 32'd392 << 3;
            5'd26: freq = 32'd440 << 3;
            5'd27: freq = 32'd494 << 3;
            5'd28: freq = 32'd262 << 4; // C8
            default : freq = 32'd20000;	//Do-dummy
        endcase
    end
endmodule

module Tone_Generator (
    input clk, rst_n,
    input btn_w, btn_s, btn_r,
    output reg [4:0] tone // C4 (0) ~ C8 (28)
    );

    parameter tone_max = 5'b11100; // 28
    parameter tone_min = 5'b00000; // 0

    reg dir; // 0: up, 1: down
    reg rate; // 0: 1s, 1: 0.5s

    wire dclk_2hz;
    reg toggle_2hz;
    wire dclk_1hz = toggle_2hz & dclk_2hz;
    Clock_Divider #(.D(100_000_000 / 2), .B(26)) cd_2hz (clk, rst_n, dclk_2hz);
    
    always @(posedge clk) begin
        if (~rst_n) begin
            toggle_2hz <= 1'b0;
            tone <= 5'b00000;
            dir <= 1'b0;
            rate <= 1'b0;
        end
        else begin 
            dir <= (btn_w) ? 1'b0 : (btn_s) ? 1'b1 : dir;
            if (btn_r) rate <= ~rate;
            if (dclk_2hz) toggle_2hz <= ~toggle_2hz;
            if (rate ? dclk_2hz : dclk_1hz) begin
                if (dir) begin // down
                    if (tone > tone_min) tone <= tone - 1;
                end else begin // up
                    if (tone < tone_max) tone <= tone + 1;
                end
            end
        end
    end
endmodule

// Utility
module Clock_Divider #(parameter D = 10000, B = 14) (
    input clk, rst_n,
    output dclk
    );
    
    reg [B-1:0] cnt;
    assign dclk = (cnt == (D - 1));
    
    always @ (posedge clk, negedge rst_n) begin
        if (~rst_n) begin
            cnt <= 0;
        end else begin
            if (cnt == D - 1) begin
                cnt <= 0;
            end else begin
                cnt <= cnt + 1;
            end
        end
    end
endmodule

module One_Pulse (
    output reg signal_op,
    input wire signal,
    input wire clk
    );
    
    reg delay;

    always @(posedge clk) begin
        signal_op <= (signal & ~delay);
        delay <= signal;
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
    
    One_Pulse op (
        .signal_op(pulse_been_ready),
        .signal(been_ready),
        .clk(clk)
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