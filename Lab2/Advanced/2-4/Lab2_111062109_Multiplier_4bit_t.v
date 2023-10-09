`timescale 1ns/1ps
module Multiplier_4bit_t;
reg [4-1:0] a = 4'b0000;
reg [4-1:0] b = 4'b0000;
wire [8-1:0] sum;
reg error = 1'b0;
reg [8-1:0] testsum;
Multiplier_4bit MUL (a, b, sum);

initial begin
    repeat(2**4) begin
        repeat(2**4) begin
            a = a + 1;
            #1;
            testsum = a * b;
            if(sum === testsum)begin
                error = 1'b0;
            end
            else begin
                error = 1'b1;
            end
            #1;
        end
    b = b + 1;
    end
$finish;
end
endmodule

