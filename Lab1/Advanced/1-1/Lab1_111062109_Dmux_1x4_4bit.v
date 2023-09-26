`timescale 1ns/1ps
module Dmux_1x2_4bit(in, a, b, sel);
input [4-1:0] in;
input sel;
output [4-1:0] a, b;
wire nsel;

not notsel(nsel, sel);
and anda1(a[0], in[0], nsel);
and anda2(a[1], in[1], nsel);
and anda3(a[2], in[2], nsel);
and anda4(a[3], in[3], nsel);

and andb1(b[0], in[0], sel);
and andb2(b[1], in[1], sel);
and andb3(b[2], in[2], sel);
and andb4(b[3], in[3], sel);

endmodule


module Dmux_1x4_4bit(in, a, b, c, d, sel);
input [4-1:0] in;
input [2-1:0] sel;
output [4-1:0] a, b, c, d;

wire [4-1:0]temp1, temp2;

Dmux_1x2_4bit dmux1(in, temp1, temp2, sel[1]);
Dmux_1x2_4bit dmux2(temp1, a, b, sel[0]);
Dmux_1x2_4bit dmux3(temp2, c, d, sel[0]);

endmodule
