`timescale 1ns / 1ps

module Music_t;
    reg clk = 1'b0;
    reg rst_n = 1'b0;
    reg btn_w = 1'b0, btn_s = 1'b0, btn_r = 1'b0;
    wire [4:0] tone;
    wire [31:0] freq;

    Tone_Generator tg (clk, rst_n, btn_w, btn_s, btn_r, tone);
    Freq_Decoder fd (tone, freq);

    always #5 clk = ~clk;

    initial begin
        $dumpfile("Music_t.vcd");
        $dumpvars(0, Music_t);

        @(negedge clk);
        rst_n = 1'b1;
        repeat (12) @(negedge clk);
        btn_s = 1'b1;
        @(negedge clk);
        btn_s = 1'b0;
        repeat (8) @(negedge clk);
        btn_w = 1'b1;
        @(negedge clk);
        btn_w = 1'b0;
        repeat (8) @(negedge clk);
        btn_r = 1'b1;
        @(negedge clk);
        btn_r = 1'b0;
        repeat (20) @(negedge clk);
        btn_s = 1'b1;
        @(negedge clk);
        btn_s = 1'b0;
        repeat (40) @(negedge clk);
        $finish;
    end
endmodule
