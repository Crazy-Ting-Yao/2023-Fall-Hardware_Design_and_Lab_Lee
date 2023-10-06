`timescale 1ns/1ps
`include "Lab2_111062109_Ripple_Carry_Adder.v"
module Ripple_Carry_Adder_v;
reg [8-1:0] a = 8'b00000000;
reg [8-1:0] b = 8'b00000000;
reg cin = 1'b0;
wire cout;
wire [8-1:0]sum;

Ripple_Carry_Adder rca(
    .a (a), 
    .b (b), 
    .cin (cin),
    .cout (cout),
    .sum (sum)
);

initial begin
    $dumpfile("Ripple_Carry_Adder.vcd");
    $dumpvars(0, Ripple_Carry_Adder_v);
    repeat(20) begin
        #1
        a = $random;
        b = $random;
        cin = $random;
    end
end

endmodule
