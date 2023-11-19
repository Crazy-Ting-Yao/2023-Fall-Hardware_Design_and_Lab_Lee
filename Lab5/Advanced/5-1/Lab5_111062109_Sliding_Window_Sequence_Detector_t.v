`timescale 1ns/1ps
`include "Lab5_111062109_Sliding_Window_Sequence_Detector.v"

module Sliding_Window_Sequence_Detector_t;
    reg clk, rst_n, in;
    wire dec;

    Sliding_Window_Sequence_Detector SWSD(clk, rst_n, in, dec);

    parameter cyc = 10;
    integer i;
    reg [0:16] in_seq1 = 17'b1110_0111_1001_0111_0;
    reg [0:15] in_seq2 = 16'b0111_0111_0010_0000;

    initial begin
        $dumpfile("Sliding_Window_Sequence_Detector.vcd");
        $dumpvars(0, Sliding_Window_Sequence_Detector_t);
        clk = 0;
        rst_n = 0;
        in = 0;
        for(i = 0; i < 17; i = i + 1)begin
            #cyc rst_n = 1;
            in = in_seq1[i];
        end
        #cyc rst_n = 0;
        for(i = 0; i < 16; i = i + 1)begin
            #cyc rst_n = 1;
            in = in_seq2[i];
        end
        #cyc $finish;
    end
    always #5 clk = ~clk;
endmodule