`timescale 1ns/1ps
module Carry_Look_Ahead_Adder_8bit_t;
reg [8-1:0] a = 8'b00000000;
reg [8-1:0] b = 8'b00000001;
wire [8-1:0] sum;
reg cin = 1'b0;
wire cout;
reg error = 1'b0;
reg [9-1:0] testsum;
Carry_Look_Ahead_Adder_8bit adder (a,b,cin,sum,cout);

initial begin
    $dumpfile("Carry_Look_Ahead_Adder_8bit_t.vcd");
    $dumpvars(0, Carry_Look_Ahead_Adder_8bit_t);
    repeat(2**17) begin
        {a , b, cin} = {a, b, cin} + 1;
        #1 testsum = a + b + cin;
        if({cout, sum} === testsum) begin
            error = 1'b0;
        end
        else begin
            error = 1'b1;
        end
        #1;
    end
    $finish;
end
endmodule

