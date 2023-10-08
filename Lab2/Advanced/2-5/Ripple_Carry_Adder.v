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

module Ripple_Carry_Adder(a, b, cin, cout, sum);
    input [4-1:0] a, b;
    input cin;
    output cout;
    wire eater;
    output [4-1:0] sum;
    wire [3-1:0] tempcin;
    Full_Adder F1 (a[0], b[0], cin, tempcin[0], sum[0]);
    Full_Adder F2 (a[1], b[1], tempcin[0], tempcin[1], sum[1]);
    Full_Adder F3 (a[2], b[2], tempcin[0], tempcin[2], sum[2]);
    Full_Adder F4 (a[3], b[3], tempcin[2], cout, sum[3]);
endmodule