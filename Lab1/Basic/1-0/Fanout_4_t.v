`timescale 1ns/1ps
`include "Lab1_Fanout_4.v"
module Fanout_4_t;

    reg in = 1'b0;
    wire [3:0] out;

    // test instance instantiation
    Fanout_4 FO4(.in(in),.out(out));

    // uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
    // initial begin
    //      $fsdbDumpfile("FO4.fsdb");
    //      $fsdbDumpvars;
    // end

    initial begin
        #1 in = 1'b1;
        #1 in = 1'b0;
        #1 $finish;
    end

endmodule