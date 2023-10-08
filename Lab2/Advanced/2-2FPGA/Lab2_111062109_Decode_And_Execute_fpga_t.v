`timescale 1ns/1ps
`include "Lab2_111062109_Decode_And_Execute_fpga.v"

module Decode_And_Execute_fpga_v;
reg [4-1:0] rs = 4'b0000;
reg [4-1:0] rt = 4'b0000;
reg [3-1:0] sel = 3'b000;
wire [6:0] regs;
wire [4-1:0] AN;


Decode_And_Execute_FPGA DAEF (rs, rt, sel, AN, regs);

initial begin
    $dumpfile("Decode_And_Execute_fpga.vcd");
    $dumpvars(0, Decode_And_Execute_fpga_v);
    repeat(8) begin
        repeat(10) begin
            #1 rs = rs + 1;
            rt = rt + 2;
        end
        sel = sel + 1;
    end
    $finish;
end
endmodule