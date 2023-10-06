module Universal_Gate(out, a, b);
    input a,b;
    output out;
    wire temp;
    not n1(temp, b);
    and a1(out, a, temp);
endmodule