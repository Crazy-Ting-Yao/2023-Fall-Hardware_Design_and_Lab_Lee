`timescale 1ns/1ps
`include "Lab2_111062109_Carry_Look_Ahead_Adder_8bit.v"
module Carry_Look_Ahead_Adder_8bit_t;
reg [8-1:0] a = 8'b00000000;
reg [8-1:0] b = 8'b00000001;
wire [8-1:0] sum;
reg cin = 1'b0;
wire cout;

Carry_Look_Ahead_Adder_8bit adder (a,b,cin,sum,cout);

initial begin
    $dumpfile("Carry_Look_Ahead_Adder_8bit_t.vcd");
    $dumpvars(0, Carry_Look_Ahead_Adder_8bit_t);
    repeat(20) begin
        #1 a = $random;
        b = $random;
        cin = $random;
    end
    $finish;
end

endmodule