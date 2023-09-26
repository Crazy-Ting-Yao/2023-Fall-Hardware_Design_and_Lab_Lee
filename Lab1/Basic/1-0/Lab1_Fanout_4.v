`timescale 1ns/1ps

module Fanout_4(in, out);
    input in;
    output [3:0] out;
    wire node;
    not NOT1(node, in);
    not NOTX(out[0], out[1], out[2], out[3], node);
//    not NOT2(out[0], node);
//    not NOT3(out[1], node);
//    not NOT4(out[2], node);
//    not NOT5(out[3], node);
endmodule
