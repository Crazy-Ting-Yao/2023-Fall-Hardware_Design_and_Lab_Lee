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

module Majority(a, b, c, out);
    input a, b, c;
    output out;
    wire temp1, temp2, temp3, temp4, temp5, temp6;
    AND A1 (temp1, a, b);
    AND A2 (temp2, a, c);
    AND A3 (temp3, b, c);
    OR O1 (temp4, temp1, temp2);
    OR O2 (out, temp4, temp3);
endmodule

module Full_Adder (a, b, cin, cout, sum);
    input a, b, cin;
    output cout, sum;
    wire temp1;
    Majority M1 (a, b, cin, cout);
    XOR X1 (temp1, a, b);
    XOR X2 (sum, temp1, cin);
endmodule

module Half_Adder(a, b, cout, sum);
    input a, b;
    output cout, sum;

    XOR X1 (sum, a, b);
    AND A1 (cout, a, b);
endmodule

module Adder_4bit(a, b, sum, lastbit);
    input [4-1:0] a, b;
    output lastbit;
    output [4-1:0] sum;
    wire [4-1-1:0] tempcin;
    Half_Adder H1 (a[0], b[0], tempcin[0], lastbit);
    Full_Adder F2 (a[1], b[1], tempcin[0], tempcin[1], sum[0]);
    Full_Adder F3 (a[2], b[2], tempcin[1], tempcin[2], sum[1]);
    Full_Adder F4 (a[3], b[3], tempcin[2], sum[3], sum[2]);
endmodule

module Multiplier_4x1bit(a, b, p);
    input [4-1:0] a;
    input b;
    output [4-1:0] p;
    AND A1 (p[0], a[0], b);
    AND A2 (p[1], a[1], b);
    AND A3 (p[2], a[2], b);
    AND A4 (p[3], a[3], b);
endmodule

module Multiplier_4bit(a, b, p);
    input [4-1:0] a, b;
    output [8-1:0] p;
    wire [4:0] ab0;
    wire [4-1:0] ab1, ab2, ab3;
    wire [4-1:0] addtemp1, addtemp2;
    Multiplier_4x1bit M1 (a, b[0], ab0[3:0]);
    Multiplier_4x1bit M2 (a, b[1], ab1);
    Multiplier_4x1bit M3 (a, b[2], ab2);
    Multiplier_4x1bit M4 (a, b[3], ab3);
    AND A1 (p[0], ab0[0], ab0[0]);
    AND A2 (ab0[4], 1'b0, 1'b0);
    Adder_4bit AD1 (ab0[4:1], ab1, addtemp1, p[1]);
    Adder_4bit AD2 (addtemp1, ab2, addtemp2, p[2]);
    Adder_4bit AD3 (addtemp2, ab3, p[7:4], p[3]);
endmodule
