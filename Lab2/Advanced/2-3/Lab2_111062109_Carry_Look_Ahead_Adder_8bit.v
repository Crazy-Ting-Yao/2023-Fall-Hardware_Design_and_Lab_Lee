`timescale 1ns/1ps
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

module Carry_Look_Ahead_Generator_2bit(p1, p2, g1, g2, cin, cout1, cout2);
    input p1, p2, g1, g2, cin;
    output cout1, cout2;
    wire [5-1:0]temp;
    AND a1 (temp[0], p1, cin);
    OR o1 (cout1, g1, temp[0]);

    AND a2 (temp[1], p2, g1);
    AND a3 (temp[2], p2, p1);
    AND a4 (temp[3], cin, temp[2]);
    OR o2 (temp[4], temp[1], temp[3]);
    OR o3 (cout2, g2, temp[4]);
endmodule


module Carry_Look_Ahead_Generator_4bit(p, g, cin, cout, p03, g03);
    input [4-1:0] p, g;
    input cin;
    output [2:0]cout;
    output p03, g03;
    wire p01, p02;
    wire [13:0] temp;

    AND a1(p01, p[0], p[1]);
    AND a2(p02, p01, p[2]);
    AND a3(p03, p02, p[3]);

    AND a7(temp[0], p[0], cin);
    OR o1(cout[0], g[0], temp[0]);

    AND a8(temp[1], p01, cin);
    AND a9(temp[2], g[0], p[1]);
    OR o2(temp[3], g[1], temp[2]);
    OR o3(cout[1], temp[1], temp[3]);

    AND a10(temp[4], p02, cin);
    AND a11(temp[5], temp[3], p[2]);
    OR o5(temp[6], g[2], temp[5]);
    OR o6(cout[2], temp[4], temp[6]);

    AND a13(temp[7], temp[6], p[3]);
    OR o7(g03, g[3], temp[7]);
endmodule


module Carry_Look_Ahead_Adder_8bit(a, b, c0, s, c8);
    input [8-1:0] a, b;
    input c0;
    output [8-1:0] s;
    output c8;
    wire [8-1:0] p, g, c;
    wire [8-1:0] cout;
    wire p03, g03, p47, g47;
    XOR x1[7:0] (p, a, b);
    AND a1[7:0] (g, a, b);
    AND a2(cout[0], c0, c0);
    Carry_Look_Ahead_Generator_4bit c1 (p[3:0], g[3:0], c0, cout[3:1], p03, g03);
    Carry_Look_Ahead_Generator_4bit c2 (p[7:4], g[7:4], cout[4], cout[7:5], p47, g47);
    Carry_Look_Ahead_Generator_2bit c3 (p03, p47, g03, g47, c0, cout[4], c8);
    
    XOR x2[7:0] (s, cout, p);
endmodule
