`timescale 1ns/1ps
`include "Lab2_111062109_Ripple_Carry_Adder.v"
module Ripple_Carry_Adder_v;
reg [8-1:0] a = 8'b00000000;
reg [8-1:0] b = 8'b00000000;
reg cin = 1'b0;
wire cout;
wire [8-1:0]sum;
reg error = 1'b0;
reg [9-1:0] testsum;

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
    repeat(2**8) begin
        repeat(2**8) begin
            repeat(2) begin
                cin = cin + 1;
                #1 testsum = a + b + cin;
                if({cout, sum} === testsum) begin
                    error = 1'b0;
                end
                else begin
                    error = 1'b1;
                end
                #1;
            end
            a = a + 1;
        end
        b = b + 1;
    end
    $finish;
end

endmodule
