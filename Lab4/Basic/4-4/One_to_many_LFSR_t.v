`timescale 1ns/1ps
`include "One_to_many_LFSR.v"

module One_to_many_LFSR_t;
    reg clk, rst_n;
    wire out;
    One_to_many_LFSR One_to_many_LFSR(rst_n, clk, out);
    initial begin
        $dumpfile("One_to_many_LFSR.vcd");
        $dumpvars(0, One_to_many_LFSR);
        clk = 0;
        rst_n = 0;
        #10 rst_n = 1;
        #200 $finish;
    end
    always #5 clk = ~clk;
endmodule