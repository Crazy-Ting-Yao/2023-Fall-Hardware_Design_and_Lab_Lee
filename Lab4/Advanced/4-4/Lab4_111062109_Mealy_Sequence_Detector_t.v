`timescale 1ns / 1ps
`include "Lab4_111062109_Mealy_Sequence_Detector.v"

module Mealy_Sequence_Detector_t;
    reg clk;
    reg rst_n;
    reg in;
    wire Dec;

    Mealy_Sequence_Detector Mealy_Sequence_Detector(clk, rst_n, in, Dec);

    initial begin
        $dumpfile("Mealy_Sequence_Detector_t.vcd");
        $dumpvars(0, Mealy_Sequence_Detector_t);
        clk = 0;
        rst_n = 0;
        in = 0;
        #10 rst_n = 1;
        #10 in = 1;
        #30 in = 0;
        #10 in = 1;
        #20 in = 0;
        #10 in = 1;
        #10 in = 0;
        #20 in = 1;
        #10 in = 0;
        #10 in = 1;
        #10 in = 0;
        #20 $finish;
    end
    always #5 clk = ~clk;
endmodule