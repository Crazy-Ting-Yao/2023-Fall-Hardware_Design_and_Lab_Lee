`timescale 1ns/1ps
`include "Lab4_111062109_Content_Addressable_Memory.v"

module Content_Addressable_Memory_t;
    reg clk;
    reg wen, ren;
    reg [7:0] din;
    reg [3:0] addr;
    wire [3:0] dout;
    wire hit;

    Content_Addressable_Memory uut(clk, wen, ren, din, addr, dout, hit);
    initial begin
        $dumpfile("Content_Addressable_Memory_t.vcd");
        $dumpvars(0, Content_Addressable_Memory_t);
        clk = 0;
        wen = 0;
        ren = 0;
        din = 0;
        addr = 0;
        @(negedge clk)
        wen = 1;
        din = 8'd4;
        addr = 4'd0;
        @(negedge clk)
        din = 8'd8;
        addr = 4'd7;
        @(negedge clk)
        din = 8'd35;
        addr = 4'd15;
        @(negedge clk)
        din = 8'd8;
        addr = 4'd9;
        @(negedge clk)
        din = 8'd8;
        addr = 4'd5;
        @(negedge clk)
        wen = 0;
        din = 8'd0;
        addr = 4'd0;
        #25;
        @(negedge clk)
        ren = 1;
        din = 8'd4;
        @(negedge clk)
        din = 8'd8;
        @(negedge clk)
        din = 8'd35;
        @(negedge clk)
        din = 8'd87;
        @(negedge clk)
        din = 8'd45;
        @(negedge clk)
        ren = 0;
        din = 8'd0;
        #30 $finish;
    end

    always #5 clk = ~clk;
endmodule