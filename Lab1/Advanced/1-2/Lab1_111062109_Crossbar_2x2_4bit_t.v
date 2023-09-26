`include "Lab1_111062109_Crossbar_2x2_4bit.v"
`timescale 1ns/1ps

module Crossbar_2x2_4bit_t;
reg [3:0] in1 = 4'b0100;
reg [3:0] in2 = 4'b0001;
reg ctl = 1'b0;
wire [3:0] o1, o2;

Crossbar_2x2_4bit C1(
    .in1 (in1),
    .in2 (in2),
    .control (ctl),
    .out1 (o1),
    .out2 (o2)
);


initial begin
    repeat (2 ** 2) begin
        #1 ctl = !ctl;
        in1 = in1 + 4'b1;
        in2 = in2 + 4'b1;
    end
    #1 $finish;
end
endmodule
