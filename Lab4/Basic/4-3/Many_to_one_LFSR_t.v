`timescale 1ns/1ps
`include "Many_to_one_LFSR.v"

module Many_to_one_LFSR_t;
    reg clk, rst_n;
    wire out;
    Many_to_one_LFSR Many_to_one_LFSR(clk, rst_n, out);
    initial begin
        $dumpfile("Many_to_one_LFSR.vcd");
        $dumpvars(0, Many_to_one_LFSR);
        clk = 0;
        rst_n = 0;
        #10 rst_n = 1;
        #200 $finish;
    end
    always #5 clk = ~clk;
endmodule