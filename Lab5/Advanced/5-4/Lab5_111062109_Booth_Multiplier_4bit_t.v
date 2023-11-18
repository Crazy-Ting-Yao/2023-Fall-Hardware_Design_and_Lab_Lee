`timescale 1ns / 1ps
`include "Lab5_111062109_Booth_Multiplier_4bit.v"

module Booth_Multiplier_4bit_t;
    reg clk, rst_n, start;
    reg signed [3:0] a, b; 
    wire signed [7:0] p;

    Booth_Multiplier_4bit BM4(clk, rst_n, start, a, b, p);

    reg signed [3:0] a_set [3:0];
    reg signed [3:0] b_set [3:0];
    integer i;
    parameter cyc = 10;
    initial begin
        $dumpfile("Booth_Multiplier_4bit.vcd");
        $dumpvars(0, Booth_Multiplier_4bit_t);
        {a_set[0], b_set[0]} = {4'd5, 4'd3};
        {a_set[1], b_set[1]} = {4'd4, -4'd4};
        {a_set[2], b_set[2]} = {-4'd7, 4'd5};
        {a_set[3], b_set[3]} = {-4'd2, -4'd6};
        clk = 0;
        rst_n = 0;
        start = 0;
        #cyc rst_n = 1;
        for(i = 0; i < 4; i = i + 1) begin
            a = a_set[i];
            b = b_set[i];
            start = 1;
            #cyc start = 0;
            #(4*cyc);
            $display("a = %d, b = %d, p = %d", a, b, p);
            #(2*cyc);
        end
        $finish;
    end

    always #5 clk = ~clk;
endmodule