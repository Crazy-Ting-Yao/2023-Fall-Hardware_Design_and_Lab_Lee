`timescale 1ns/1ps
`include "Lab4_111062109_Built_In_Self_Test.v"

module Built_In_Self_Test_t;
    reg clk;
    reg rst_n;
    reg scan_en;
    wire scan_in;
    wire scan_out;

    Built_In_Self_Test Built_In_Self_Test(clk, rst_n, scan_en, scan_in, scan_out);
    initial begin
        $dumpfile("Built_In_Self_Test_t.vcd");
        $dumpvars(0, Built_In_Self_Test_t);
        clk = 0;
        rst_n = 0;
        scan_en = 0;
        #10 rst_n = 1;
        scan_en = 1; 
        #80 scan_en = 0;
        #10 scan_en = 1;
        #80 scan_en = 0;
        #10 $finish;
    end

    always #5 clk = ~clk;
endmodule