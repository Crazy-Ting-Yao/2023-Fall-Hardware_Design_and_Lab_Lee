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

module Mux_2x1_4bit(a, b, sel, f);
    input [4-1:0] a, b;
    input sel;
    output [4-1:0] f;

    wire not_sel;
    wire [4-1:0] newa, newb;
    not n1(not_sel, sel);
    and na1(newa[0], not_sel, a[0]);
    and na2(newa[1], not_sel, a[1]);
    and na3(newa[2], not_sel, a[2]);
    and na4(newa[3], not_sel, a[3]);
    and nb1(newb[0], sel, b[0]);
    and nb2(newb[1], sel, b[1]);
    and nb3(newb[2], sel, b[2]);
    and nb4(newb[3], sel, b[3]);
    or o1(f[0], newa[0], newb[0]);
    or o2(f[1], newa[1], newb[1]);
    or o3(f[2], newa[2], newb[2]);
    or o4(f[3], newa[3], newb[3]);

endmodule

module Crossbar_2x2_4bit(in1, in2, control, out1, out2);
input [4-1:0] in1, in2;
input control;
output [4-1:0] out1, out2;
wire [3:0] temp1, temp2, temp3, temp4;
wire ncontrol;

not notcontrol(ncontrol, control);
Dmux_1x2_4bit d1(.in(in1), .a(temp1), .b(temp2), .sel(control));
Dmux_1x2_4bit d2(.in(in2), .a(temp3), .b(temp4), .sel(ncontrol));

Mux_2x1_4bit m1(.a(temp1), .b(temp3), .sel(control), .f(out1));
Mux_2x1_4bit m2(.a(temp2), .b(temp4), .sel(ncontrol), .f(out2));

endmodule
