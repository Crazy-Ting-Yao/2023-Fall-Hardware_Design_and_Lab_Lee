`timescale 1ns / 1ps
`include "Lab3_111062109_Ping_Pong_Counter.v"

module Ping_Pong_Counter_v;
    reg clk, rst_n, enable;
    wire direction;
    wire [4-1:0] out;

    Ping_Pong_Counter Ping_Pong_Counter(clk, rst_n, enable, direction, out);

    initial begin
        $dumpfile("Ping_Pong_Counter.vcd");
        $dumpvars(0, Ping_Pong_Counter_v);
        clk = 1'b0;
        rst_n = 1'b0;
        enable = 1'b0;
        #10 rst_n = 1'b1;
        #10 enable = 1'b1;
        #100 enable = 1'b0;
        #20 enable = 1'b1;
        #400 rst_n = 1'b0;
        #10 rst_n = 1'b1;
        #100 enable = 1'b0;
        #10 $finish;
    end

    always #5 clk = ~clk;
endmodule