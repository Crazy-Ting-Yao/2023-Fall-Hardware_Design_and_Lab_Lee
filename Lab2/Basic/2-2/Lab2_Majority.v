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