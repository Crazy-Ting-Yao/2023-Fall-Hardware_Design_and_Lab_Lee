`timescale 1ns/1ps

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

module Mux_4x1_4bit(a, b, c, d, sel, f);
input [4-1:0] a, b, c, d;
input [2-1:0] sel;
output [4-1:0] f;

wire [4-1:0] temp1, temp2;
Mux_2x1_4bit m1(a,b,sel[0],temp1);
Mux_2x1_4bit m2(c,d,sel[0],temp2);
Mux_2x1_4bit m3(temp1,temp2,sel[1],f);

endmodule
