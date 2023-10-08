`timescale 1ns/1ps
`include "Lab2_111062109_Multiplier_4bit.v"
module Multiplier_4bit_t;
    reg [4-1:0] a = 4'b0000;
    reg [4-1:0] b = 4'b0000;
    wire [8-1:0] sum;
    
    Multiplier_4bit MUL (a, b, sum);

    initial begin
        $dumpfile("Multiplier_4bit_t.vcd");
        $dumpvars(0, Multiplier_4bit_t);
        repeat(16) begin
            repeat(16) begin
                #1 b = b + 1;
            end
            a = a + 1;
        end
    end
endmodule

