`timescale 1ns/1ps
`include "Lab2_111062109_Decode_And_Execute.v"

module Decode_And_Execute_v;
reg [4-1:0] rs = 4'b0000;
reg [4-1:0] rt = 4'b0001;
reg [3-1:0] sel = 3'b000;
wire [4-1:0] rd;

Decode_And_Execute DAE (rs, rt, sel, rd);

initial begin
    $dumpfile("Decode_And_Execute.vcd");
    $dumpvars(0, Decode_And_Execute_v);
    repeat(30) begin
        #1 rs = rs + 1;
        rt = rt + 2;
        sel = sel + 1;
    end
    $finish;
end
endmodule