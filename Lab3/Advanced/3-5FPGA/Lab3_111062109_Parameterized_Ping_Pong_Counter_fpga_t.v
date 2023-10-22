`timescale 1ns/1ps
`include "Lab3_111062109_Parameterized_Ping_Pong_Counter_fpga.v" 

module Parameterized_Ping_Pong_Counter_t;
reg clk;
reg rst_n;
reg enable;
reg flip;
reg [4-1:0] max;
reg [4-1:0] min;
wire [4-1:0] AN;
wire [7-1:0] segs;

Parameterized_Ping_Pong_Counter_FPGA uut (
    .clk(clk), 
    .rst_n(rst_n), 
    .enable(enable), 
    .flip(flip), 
    .max(max), 
    .min(min), 
    .AN(AN),
    .segs(segs)
);

initial begin
    $dumpfile("Parameterized_Ping_Pong_Counter.vcd");
    $dumpvars(0, Parameterized_Ping_Pong_Counter_t);
    rst_n = 0;
    clk = 0;
    enable = 1;
    flip = 0;
    max = 4;
    min = 0;
    #100 rst_n = 1;
    #900 rst_n = 0;
    $finish;
    #200 rst_n = 1;
    #300 flip = 1;
    #100 flip = 0;
    #500 rst_n = 0;
    #10;
   
    /*
    #200 rst_n = 1;
    #300 flip = 1;
    #100 flip = 0;
    #100 flip = 1;
    #100 flip = 0;
    #300 rst_n = 0;
    
    #200 rst_n = 1;
    max = 3;
    #500 flip = 1;
    min = 1;
    #100 flip = 0;
    min = 3;
    #200 min = 2; max = 2;
    #300 min = 1; max = 3;
    #300 rst_n = 0;
    $finish;
    */
end

always #5 clk = ~clk;

endmodule