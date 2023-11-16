`timescale 1ns / 1ps

module Sliding_t;
    reg clk = 1'b1;
    reg rst_n = 1'b1;
    reg in = 1'b0;
    wire dec;

    parameter [0:16] seq0 = 17'b11001001100101001;
    parameter len0 = 17;
    parameter [0:15] seq1 = 16'b0110001100100000;
    parameter len1 = 16;

    Sliding_Window_Sequence_Detector m (clk, rst_n, in, dec);

    always #5 clk = ~clk;

    integer i;

    initial begin
        $dumpfile("Sliding_t.vcd");
        $dumpvars(0, Sliding_t);
        
        @(negedge clk);
        rst_n = 1'b0;
        for (i = 0; i < len0; i++) begin
            @(negedge clk);
            rst_n = 1'b1;
            in = seq0[i];
        end

        @(negedge clk);
        rst_n = 1'b0;
        for (i = 0; i < len1; i++) begin
            @(negedge clk);
            rst_n = 1'b1;
            in = seq1[i];
        end

        $finish;
    end
endmodule