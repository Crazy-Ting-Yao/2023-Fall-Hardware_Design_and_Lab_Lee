`timescale 1ns/1ps

module Crossbar_4x4_4bit_t;
reg [3:0] in1 = 4'b0001;
reg [3:0] in2 = 4'b0011;
reg [3:0] in3 = 4'b0101;
reg [3:0] in4 = 4'b0111;
reg [4:0] ctl = 5'b00000;
wire [3:0] o1, o2, o3, o4;

Crossbar_4x4_4bit C1(
    .in1 (in1), .in2 (in2), .in3 (in3), .in4 (in4),
    .control (ctl), 
    .out1 (o1), .out2 (o2), .out3 (o3), .out4 (o4)
);

initial begin
    repeat (2 ** 5) begin
        #1 ctl = ctl + 5'b00001;
        in1 = in1 + 4'b1;
        in2 = in2 + 4'b1;
        in3 = in3 + 4'b1;
        in4 = in4 + 4'b1;
    end
    #1 $finish;
end
endmodule