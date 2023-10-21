`timescale 1ns/1ps
`include "Lab3_111062109_Round_Robin_FIFO_Arbiter.v"
module Round_Robin_FIFO_Arbiter_t;
    reg clk;
    reg rst_n;
    reg [8-1:0] a,b,c,d;
    reg [3:0] wen;
    wire [8-1:0] dout;
    wire valid;
    Round_Robin_FIFO_Arbiter uut (
        clk, rst_n, wen, a, b, c, d, dout, valid
    );
    initial begin
        $dumpfile("Round_Robin_FIFO_Arbiter.vcd");
        $dumpvars(0, Round_Robin_FIFO_Arbiter_t);
        clk = 0;
        rst_n = 0;
        wen = 4'b1111;
        @(negedge clk)
        rst_n = 1;
        a = 8'd87; b = 8'd56; c = 8'd9; d = 8'd13;
        @(negedge clk)
        wen = 4'b1000;
        a = 8'dx; b = 8'dx; c = 8'dx; d = 8'd85;
        @(negedge clk)
        wen = 4'b0100;
        a = 8'dx; b = 8'dx; c = 8'd139; d = 8'dx;
        @(negedge clk)
        wen = 4'b0000;
        a = 8'dx; b = 8'dx; c = 8'dx; d = 8'dx;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        wen = 4'b0001;
        a = 8'd51; b = 8'dx; c = 8'dx; d = 8'dx;
        @(negedge clk)
        wen = 4'b0000;
        a = 8'dx; b = 8'dx; c = 8'dx; d = 8'dx;
        #45 $finish;
    end

    always #5 clk = ~clk;
endmodule