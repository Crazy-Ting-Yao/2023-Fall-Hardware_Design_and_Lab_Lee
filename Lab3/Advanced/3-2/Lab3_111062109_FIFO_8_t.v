`timescale 1ns/1ps
`include "Lab3_111062109_FIFO_8.v"
module FIFO_8_t;
reg clk, rst_n, wen, ren;
reg [8-1:0] din;
wire [8-1:0] dout;
wire error;

FIFO_8 UUT(clk, rst_n, wen, ren, din, dout, error);

initial begin
    $dumpfile("Lab3_111062109_FIFO_8_t.vcd");
    $dumpvars(0, Lab3_111062109_FIFO_8_t);
    clk = 0;
    rst_n = 0;
    wen = 0;
    ren = 1;
    din = 0;
    #10 rst_n = 1;
    #10 wen = 1;
    ren = 0;
    din = 8'd56;
    #10 din = 8'd11;
    #10 din = 8'd42;
    #10 din = 8'd10;
    #10 din = 8'd23;
    #10 din = 8'd20;
    #10 din = 8'd6;
    #10 din = 8'd85;
    #10 din = 8'd45;
    ren = 1;
    #10 din = 8'd12;
    ren = 0;
    #10 din = 8'd77;
    #10 wen = 0;
    #10 $finish;
end

always #5 clk = ~clk;
endmodule