`timescale 1ns/1ps
`include "Universal_Gate.v"

module Uni_NOT(out, in);
    input in;
    output out;
    Universal_Gate u1(.out(out), .a(1'b1), .b(in));
endmodule

module Uni_NOR(out, a, b);
    input a, b;
    output out;
    wire temp;
    Universal_Gate u1(.out(temp), .a(1'b1), .b(a));
    Universal_Gate u2(.out(out), .a(temp), .b(b));
endmodule

module Uni_AND(out, a, b);
    input a, b;
    output out;
    wire temp;
    Universal_Gate u1(.out(temp), .a(1'b1), .b(a));
    Universal_Gate u2(.out(out), .a(b), .b(temp));
endmodule

module Uni_OR(out, a, b);
    input a, b;
    output out;
    wire temp1, temp2;
    Universal_Gate u1(.out(temp1), .a(1'b1), .b(a));
    Universal_Gate u2(.out(temp2), .a(temp1), .b(b));
    Universal_Gate u3(.out(out), .a(1'b1), .b(temp2));
endmodule

module Uni_NAND(out, a, b);
    input a, b;
    output out;
    wire temp1, temp2;
    Universal_Gate u1(.out(temp1), .a(1'b1), .b(a));
    Universal_Gate u2(.out(temp2), .a(b), .b(temp1));
    Universal_Gate u3(.out(out), .a(1'b1), .b(temp2));
endmodule

module Uni_XOR(out, a, b);
    input a, b;
    output out;
    wire temp1, temp2, temp3, temp4;
    Universal_Gate u1(.out(temp1), .a(a), .b(b));
    Universal_Gate u2(.out(temp2), .a(b), .b(a));
    Universal_Gate u3(.out(temp3), .a(1'b1), .b(temp1));
    Universal_Gate u4(.out(temp4), .a(temp3), .b(temp2));
    Universal_Gate u5(.out(out), .a(1'b1), .b(temp4));
endmodule

module Uni_XNOR(out, a, b);
    input a, b;
    output out;
    wire temp1, temp2, temp3;
    Universal_Gate u1(.out(temp1), .a(a), .b(b));
    Universal_Gate u2(.out(temp2), .a(b), .b(a));
    Universal_Gate u3(.out(temp3), .a(1'b1), .b(temp1));
    Universal_Gate u4(.out(out), .a(temp3), .b(temp2));
endmodule

module Mux_2x1_1bit(out, a, b, sel);
    input a, b;
    input sel;
    output out;
    wire not_sel;
    wire newa, newb;
    Uni_NOT N1(not_sel, sel);
    Uni_AND A1(newa, not_sel, a);
    Uni_AND A2(newb, sel, b);
    Uni_OR O1(out, newa, newb);
endmodule

module Mux_8x1_1bit(out, a, b, c, d, e, f, g, h, sel);
    input a, b, c, d, e, f, g, h;
    input [2:0]sel;
    output out;
    wire temp1, temp2, temp3, temp4, temp5, temp6;
    Mux_2x1_1bit M1(temp1, a, b, sel[0]);
    Mux_2x1_1bit M2(temp2, c, d, sel[0]);
    Mux_2x1_1bit M3(temp3, e, f, sel[0]);
    Mux_2x1_1bit M4(temp4, g, h, sel[0]);
    Mux_2x1_1bit M5(temp5, temp1, temp2, sel[1]);
    Mux_2x1_1bit M6(temp6, temp3, temp4, sel[1]);
    Mux_2x1_1bit M7(out, temp5, temp6, sel[2]);
endmodule

module Majority(out, a, b, c);
    input a, b, c;
    output out;
    wire temp1, temp2, temp3, temp4, temp5, temp6;
    Uni_AND A1 (temp1, a, b);
    Uni_AND A2 (temp2, a, c);
    Uni_AND A3 (temp3, b, c);
    Uni_OR O1 (temp4, temp1, temp2);
    Uni_OR O2 (out, temp4, temp3);
endmodule

module Full_Adder (cout, sum, a, b, cin);
    input a, b, cin;
    output cout, sum;
    wire temp1;
    Majority M1 (cout, a, b, cin);
    Uni_XOR X1 (temp1, a, b);
    Uni_XOR X2 (sum, temp1, cin);
endmodule

module ADD(sum, a, b, cin);
    input [4-1:0] a, b;
    input cin;
    wire cout;
    output [4-1:0] sum;
    wire [4-1-1:0] tempcin;
    Full_Adder F1 (tempcin[0], sum[0], a[0], b[0], cin);
    Full_Adder F2 (tempcin[1], sum[1], a[1], b[1], tempcin[0]);
    Full_Adder F3 (tempcin[2], sum[2], a[2], b[2], tempcin[1]);
    Full_Adder F4 (cout, sum[3], a[3], b[3], tempcin[2]);
endmodule

module SUB(sum, a, b);
    input [4-1:0] a, b;
    output [4-1:0] sum;
    wire [4-1-1:0] tempcin;
    wire [4-1:0]tempb;
    Uni_NOT N1 (tempb[0], b[0]);
    Uni_NOT N2 (tempb[1], b[1]);
    Uni_NOT N3 (tempb[2], b[2]);
    Uni_NOT N4 (tempb[3], b[3]);
    ADD A1 (sum, a, tempb, 1'b1);
endmodule

module BITWISE_OR(out, a, b);
    input [4-1:0] a, b;
    output [4-1:0] out;
    Uni_OR O1 (out[0], a[0], b[0]);
    Uni_OR O2 (out[1], a[1], b[1]);
    Uni_OR O3 (out[2], a[2], b[2]);
    Uni_OR O4 (out[3], a[3], b[3]);
endmodule

module BITWISE_AND(out, a, b);
    input [4-1:0] a, b;
    output [4-1:0] out;
    Uni_AND A1 (out[0], a[0], b[0]);
    Uni_AND A2 (out[1], a[1], b[1]);
    Uni_AND A3 (out[2], a[2], b[2]);
    Uni_AND A4 (out[3], a[3], b[3]);
endmodule

module RT_ARI_RIGHT_SHIFT(out, in);
    input [4-1:0] in;
    output [4-1:0] out;
    Uni_AND A1(out[0], in[1], 1'b1);
    Uni_AND A2(out[1], in[2], 1'b1);
    Uni_AND A3(out[2], in[3], 1'b1);
    Uni_AND A4(out[3], in[3], 1'b1);
endmodule

module RS_CIR_LEFT_SHIFT(out, in);
    input [4-1:0] in;
    output [4-1:0] out;
    Uni_AND A1(out[0], in[3], 1'b1);
    Uni_AND A2(out[1], in[0], 1'b1);
    Uni_AND A3(out[2], in[1], 1'b1);
    Uni_AND A4(out[3], in[2], 1'b1);
endmodule

module COMPARE_EQ(out, a, b);
    input [4-1:0] a, b;
    output [4-1:0] out;
    wire [4-1:0] XNs;
    wire temp0, temp1;
    Uni_XNOR XN1 (XNs[0], a[0], b[0]);
    Uni_XNOR XN2 (XNs[1], a[1], b[1]);
    Uni_XNOR XN3 (XNs[2], a[2], b[2]);
    Uni_XNOR XN4 (XNs[3], a[3], b[3]);
    Uni_AND A1 (temp0, XNs[0], XNs[1]);
    Uni_AND A2 (temp1, XNs[2], XNs[3]);
    Uni_AND A3 (out[0], temp0, temp1);
    Uni_NOT U1(out[1], 1'b0);
    Uni_NOT U2(out[2], 1'b0);
    Uni_NOT U3(out[3], 1'b0);
endmodule

module COMPARE_LT(out, a, b);
    input [4-1:0] a, b;
    output [4-1:0]out;
    wire [4-1:0] nota;
    wire [4-1:0] eq;
    wire [4-1:0] bg;
    wire temp1, temp2, temp3, temp4, temp5;
    Uni_NOT N1 (nota[0], a[0]);
    Uni_NOT N2 (nota[1], a[1]);
    Uni_NOT N3 (nota[2], a[2]);
    Uni_NOT N4 (nota[3], a[3]);

    //Uni_XNOR XN1 (eq[0], a[0], b[0]);
    Uni_XNOR XN2 (eq[1], a[1], b[1]);
    Uni_XNOR XN3 (eq[2], a[2], b[2]);
    Uni_XNOR XN4 (eq[3], a[3], b[3]);

    Uni_AND A1 (bg[0], nota[0], b[0]);
    Uni_AND A2 (bg[1], nota[1], b[1]);
    Uni_AND A3 (bg[2], nota[2], b[2]);
    Uni_AND A4 (bg[3], nota[3], b[3]);

    Uni_AND A5 (temp0, eq[1], bg[0]);
    Uni_OR O1 (temp1, bg[1], temp0);
    Uni_AND A6 (temp2, eq[2], temp1);
    Uni_OR O2 (temp3, bg[2], temp2);
    Uni_AND A7 (temp4, eq[3], temp3);
    Uni_OR O3 (out[0], bg[3], temp4);
    Uni_NOT U1(out[1], 1'b0);
    Uni_NOT U2(out[2], 1'b1);
    Uni_NOT U3(out[3], 1'b0);
endmodule

module Mux_8x1_4bit(out, a, b, c, d, e, f, g, h, sel);
    input [4-1:0] a, b, c, d, e, f, g, h;
    input [2:0]sel;
    output [4-1:0] out;
    Mux_8x1_1bit M1 (out[0], a[0], b[0], c[0], d[0], e[0], f[0], g[0], h[0], sel);
    Mux_8x1_1bit M2 (out[1], a[1], b[1], c[1], d[1], e[1], f[1], g[1], h[1], sel);   
    Mux_8x1_1bit M3 (out[2], a[2], b[2], c[2], d[2], e[2], f[2], g[2], h[2], sel);
    Mux_8x1_1bit M4 (out[3], a[3], b[3], c[3], d[3], e[3], f[3], g[3], h[3], sel);
endmodule

module Decode_And_Execute(rs, rt, sel, rd);
    input [4-1:0] rs, rt;
    input [3-1:0] sel;
    output [4-1:0] rd;
    wire [4-1:0]a, b, c, d, e, f, g, h;
    SUB S1 (a, rs, rt);
    ADD A1 (b, rs, rt, 1'b0);
    BITWISE_OR O1 (c, rs, rt);
    BITWISE_AND A2 (d, rs, rt);
    RT_ARI_RIGHT_SHIFT R1 (e, rt);
    RS_CIR_LEFT_SHIFT L1 (f, rs);
    COMPARE_LT LT1 (g, rs, rt);
    COMPARE_EQ EQ1 (h, rs, rt);
    Mux_8x1_4bit M1 (rd, a, b, c, d, e, f, g, h, sel);
endmodule
