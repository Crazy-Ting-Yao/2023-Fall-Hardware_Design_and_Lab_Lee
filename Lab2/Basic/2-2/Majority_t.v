`timescale 1ns/1ps
`include "Lab2_Majority.v"
module Majority_t;
reg a = 1'b0;
reg b = 1'b0;
reg c = 1'b0;
wire out;

Majority major(
    .a (a),
    .b (b),
    .c (c),
    .out (out)
);

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
// initial begin
//      $fsdbDumpfile("Majority.fsdb");
//      $fsdbDumpvars;
// end

initial begin
    $dumpfile("Majority.vcd");
    $dumpvars(0, Majority_t);
    repeat (2 ** 3) begin
        #1 {a, b, c} = {a, b, c} + 1'b1;
    end
    #1 $finish;
end
endmodule
