module Top (CLK, BTNU, BTND, BTNC, BTNR, AUD_SIG, AUD_GAIN, AUD_SHUT);
    input CLK;
    input BTNU, BTND, BTNC, BTNR;
    output AUD_SIG, AUD_GAIN, AUD_SHUT;

    assign AUD_GAIN = 1'b1;
    assign AUD_SHUT = 1'b1;

    wire btn_r, btn_s, btn_w, rst;
    Button_Handler bh_r (CLK, BTNR, btn_r);
    Button_Handler bh_s (CLK, BTND, btn_s);
    Button_Handler bh_w (CLK, BTNU, btn_w);
    Button_Handler bh_rst (CLK, BTNC, rst);

    wire [4:0] tone;
    Tone_Generator tg (CLK, ~rst, btn_w, btn_s, btn_r, tone);

    wire [31:0] freq;
    Freq_Decoder fd (tone, freq);

    PWM_gen pwm (CLK, rst, freq, 10'd512, AUD_SIG);
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
    
    reg [B:0] cnt;
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

module Button_Handler(clk, in, out);
    input clk, in;
    output reg out;

    reg [3:0] debreg;
    reg delay;

    wire deb = &debreg;

    always @(posedge clk) begin
        debreg <= {debreg[2:0], in};
        out <= deb && !delay;
        delay <= deb;
    end
endmodule

// module Keyboard_Handler (
//     output reg [511:0] key_down,
//     output wire [8:0] last_change,
//     output reg key_valid,
//     inout wire PS2_DATA,
//     inout wire PS2_CLK,
//     input wire rst,
//     input wire clk
//     );
//     // targets:
//     //   W     1D
//     //   S     1B
//     //   R     2D
//     //   ENTER 5A
//     wire key_in, is_extend, is_break, valid, err;
//     // KeyboardCtrl_0 inst (
//     //     .key_in(key_in),
//     //     .is_extend(is_extend),
//     //     .is_break(is_break),
//     //     .valid(valid),
//     //     .err(err),
//     //     .PS2_DATA(PS2_DATA),
//     //     .PS2_CLK(PS2_CLK),
//     //     .rst(rst),
//     //     .clk(clk)
//     // );
// endmodule