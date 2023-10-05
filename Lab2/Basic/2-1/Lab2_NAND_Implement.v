`timescale 1ns/1ps

module NOT(out, a);
    input a;
    output out;
    nand n1 (out, a, a);
endmodule

module AND(out, a, b);
    input a, b;
    output out;
    wire temp;
    nand n1 (temp, a, b);
    nand n2 (out, temp, temp);
endmodule

module OR(out, a, b);
    input a, b;
    output out;
    wire temp1, temp2;
    nand n1 (temp1, a, a);
    nand n2 (temp2, b, b);
    nand n3 (out, temp1, temp2);
endmodule

module NOR(out, a, b);
    input a, b;
    output out;
    wire temp1, temp2, temp3;
    nand n1 (temp1, a, a);
    nand n2 (temp2, b, b);
    nand n3 (temp3, temp1, temp2);
    nand n4 (out, temp3, temp3);
endmodule

module XOR(out, a, b);
    input a, b;
    output out;
    wire temp1, temp2, na, nb;
    nand n1 (na, a, a);
    nand n2 (nb, b, b);
    nand n3 (temp1, na, b);
    nand n4 (temp2, nb, a);
    nand n5 (out, temp1, temp2);
endmodule

module XNOR(out, a, b);
    input a, b;
    output out;
    wire temp1, temp2, na, nb;
    nand n1 (na, a, a);
    nand n2 (nb, b, b);
    nand n3 (temp1, na, nb);
    nand n4 (temp2, b, a);
    nand n5 (out, temp1, temp2);
endmodule

module Mux_2x1_1bit(a, b, sel, out);
    input a, b;
    input sel;
    output out;
    wire not_sel;
    wire newa, newb;
    NOT N1(not_sel, sel);
    AND A1(newa, not_sel, a);
    AND A2(newb, sel, b);
    OR O1(out, newa, newb);
endmodule

module Mux_8x1_1bit(a, b, c, d, e, f, g, h, sel, out);
    input a, b, c, d, e, f, g, h;
    input [2:0]sel;
    output out;
    wire temp1, temp2, temp3, temp4, temp5, temp6;
    Mux_2x1_1bit M1(a, b, sel[0], temp1);
    Mux_2x1_1bit M2(c, d, sel[0], temp2);
    Mux_2x1_1bit M3(e, f, sel[0], temp3);
    Mux_2x1_1bit M4(g, h, sel[0], temp4);
    Mux_2x1_1bit M5(temp1, temp2, sel[1], temp5);
    Mux_2x1_1bit M6(temp3, temp4, sel[1], temp6);
    Mux_2x1_1bit M7(temp5, temp6, sel[2], out);
endmodule

module NAND_Implement (a, b, sel, out);
    input a, b;
    input [3-1:0] sel;
    output out;
    wire my_NAND, my_AND, my_OR, my_NOR, my_XOR, my_XNOR, my_NOT;
    nand SEL0(my_NAND, a, b);
    AND SEL1(my_AND, a, b);
    OR SEL2(my_OR, a, b);
    NOR SEL3(my_NOR, a, b);
    XOR SEL4(my_XOR, a, b);
    XNOR SEL5(my_XNOR, a, b);
    NOT SEL6(my_NOT, a);
    Mux_8x1_1bit BM1(my_NAND, my_AND, my_OR, my_NOR, my_XOR, my_XNOR, my_NOT, my_NOT, sel, out);
endmodule
