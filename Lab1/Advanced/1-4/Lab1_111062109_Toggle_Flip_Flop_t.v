`include "Lab1_111062109_Toggle_Flip_Flop.v"
`timescale 1ns/1ps

module Toggle_Flip_Flop_t;
reg clk = 1'b0;
reg t=1'b0;
wire q;
reg rst_n=1'b0;
// generate clk
always#(1) clk = ~clk;


Toggle_Flip_Flop T1(
    clk, q, t, rst_n
);



initial begin
    $dumpfile("Toggle_Flip_Flop.vcd");
    $dumpvars(0, Toggle_Flip_Flop_t);
    #2 rst_n=1'b1;
    repeat (2 ** 2) begin
        @(negedge clk) t = 1'b1;
        @(negedge clk) t = 1'b0;
    end
    @(negedge clk) $finish;
end
endmodule
