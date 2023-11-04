`timescale 1ns/1ps
`include "Lab4_111062109_Scan_Chain_Design.v"
module Scan_Chain_Design_t;
    reg clk;
    reg rst_n;
    reg scan_in;
    reg scan_en;
    wire scan_out;

    Scan_Chain_Design dut(clk, rst_n, scan_in, scan_en, scan_out);

    initial begin
        $dumpfile("Scan_Chain_Design.vcd");
        $dumpvars(0, Scan_Chain_Design_t);
        clk = 1'b0;
        rst_n = 1'b0;
        scan_in = 1'b0;
        scan_en = 1'b0;
        #10 rst_n = 1'b1;
        #10 scan_en = 1'b1;
        scan_in = 1'b1;
        #10 scan_in = 1'b0;
        #10 scan_in = 1'b1;
        #10 scan_in = 1'b0;
        #10 scan_in = 1'b1;
        #10 scan_in = 1'b0;
        #10 scan_in = 1'b1;
        #10 scan_in = 1'b0;
        #10 scan_en = 1'b0;
        #10 scan_en = 1'b1;
        #80 scan_en = 1'b0;
        #10 $finish;
    end

    always #5 clk = ~clk;

endmodule