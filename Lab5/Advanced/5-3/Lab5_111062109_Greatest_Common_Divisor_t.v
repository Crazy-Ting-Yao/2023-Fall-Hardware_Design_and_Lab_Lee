`timescale 1ns/1ps
`include "Lab5_111062109_Greatest_Common_Divisor.v"

module Greatest_Common_Divisor_t;
    reg clk, rst_n, start;
    reg [15:0] a, b;
    wire done;
    wire [15:0] gcd;

    Greatest_Common_Divisor dut(clk, rst_n, start, a, b, done, gcd);

    parameter cyc = 10;

    initial begin
        $dumpfile("Greatest_Common_Divisor.vcd");
        $dumpvars(0, Greatest_Common_Divisor_t);
        clk = 0;
        rst_n = 0;
        start = 0;
        #cyc rst_n = 1;
        #cyc start = 1;
        a = 15'd18;
        b = 15'd12;
        #cyc start = 0;
        a = 15'd15;
        b = 15'd8;
        #(10*cyc) start = 1;
        #cyc start = 0;
        #(20*cyc) a = 15'd12;
        b = 15'd0;
        start = 1;
        #cyc start = 0;
        #(5*cyc) a = 15'd0;
        b = 15'd4;
        start = 1;
        #cyc start = 0;
        #(5*cyc) $finish;
    end

    always #5 clk = ~clk;
endmodule