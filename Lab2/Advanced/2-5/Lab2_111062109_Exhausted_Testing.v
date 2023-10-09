`timescale 1ns/1ps
`include "Ripple_Carry_Adder.v"
module Exhausted_Testing(a, b, cin, error, done);
output [4-1:0] a, b;
output cin;
output error;
output done;

// input signal to the test instance.
reg [4-1:0] a = 4'b0000;
reg [4-1:0] b = 4'b0000;
reg cin = 1'b0;

// initial value for the done and error indicator: not done, no error
reg done = 1'b0;
reg error = 1'b0;

// output from the test instance.
wire [4-1:0] sum;
wire cout;

// instantiate the test instance.
Ripple_Carry_Adder rca(
    .a (a), 
    .b (b), 
    .cin (cin),
    .cout (cout),
    .sum (sum)
);

reg [4:0] testsum;

initial begin
    repeat(16) begin
        repeat(16) begin
            repeat(2) begin
                #1 testsum = a + b + cin; 
                if ({cout, sum} === testsum ) begin //check if the sum is correct
                    error = 1'b0; //correct -> error = 0
                end
                else begin
                    error = 1'b1; //incorrect -> error = 1
                end
                #4 cin = !cin; //freeze 4 ns, then toggle cin
            end
            b = b + 1; //increment b by 1
        end
        a = a + 1; //increment a by 1
    end
    done = 1'b1; //all test cases are done
    #1 error = 1'b0; //reset error to 0 (there might be errors in the last test case)
    #4 done = 1'b0; //reset done to 0
end

endmodule
