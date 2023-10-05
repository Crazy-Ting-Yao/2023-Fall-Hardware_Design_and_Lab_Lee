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

module Half_Adder(a, b, cout, sum);
input a, b;
output cout, sum;

XOR X1 (sum, a, b);
AND A1 (cout, a, b);
endmodule

module Full_Adder (a, b, cin, cout, sum);
input a, b, cin;
output cout, sum;
wire temp1;
Majority M1 (a, b, cin, cout);
XOR X1 (temp1, a, b);
XOR X2 (sum, temp1, cin);
endmodule

