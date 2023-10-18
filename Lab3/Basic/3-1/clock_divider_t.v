`timescale 1ns / 1ps
`include "clock_divider.v"
module clock_divider_t;
    reg clk;
    reg rst;
    reg [1:0] sel;
    wire clk1_2;
    wire clk1_3;
    wire clk1_4;
    wire clk1_8;
    wire dclk;

    clock_divider uut (
        .clk(clk),
        .rst(rst),
        .sel(sel),
        .clk1_2(clk1_2),
        .clk1_3(clk1_3),
        .clk1_4(clk1_4),
        .clk1_8(clk1_8),
        .dclk(dclk)
    );

    initial begin
        $dumpfile("clock_divider.vcd");
        $dumpvars(0, clock_divider_t);
        clk = 0;
        rst = 0;
        sel = 0;
        #10 rst = 1;
        #10 sel = 1;
        #10 sel = 0;
        #10 sel = 2;
        #10 sel = 3;
        #10 $finish;
    end

    always begin
        #2 clk = ~clk;
    end
endmodule