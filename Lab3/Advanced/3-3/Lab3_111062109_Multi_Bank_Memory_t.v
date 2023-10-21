`timescale 1ns/1ps
`include "Lab3_111062109_Multi_Bank_Memory.v"

module Multi_Bank_Memory_t;
reg clk, ren, wen;
reg [11-1:0] waddr, raddr;
reg [8-1:0] din;
wire [8-1:0] dout;

Multi_Bank_Memory UUT(clk, ren, wen, waddr, raddr, din, dout);

initial begin
    clk = 0;
    $dumpfile("Multi_Bank_Memory_t.vcd");
    $dumpvars(0, Multi_Bank_Memory_t);
    @(negedge clk)
    waddr = {4'b0000, 7'd87};
    din = 8'd87;
    ren = 1'b0;
    wen = 1'b1;
    @(negedge clk)
    ren = 1'b0;
    wen = 1'b0;
    @(negedge clk)
    raddr = {4'b0000, 7'd87};
    ren = 1'b1;
    wen = 1'b0;
    @(negedge clk)
    waddr = {4'b0101, 7'd15};
    din = 8'd85;
    ren = 1'b1;
    wen = 1'b1;
    @(negedge clk)
    waddr = {4'b0101, 7'd25};
    raddr = {4'b0101, 7'd15};
    din = 8'd100;
    @(negedge clk)
    waddr = {4'b1010, 7'd127};
    raddr = {4'b0101, 7'd25};
    din = 8'd77;
    @(negedge clk)
    raddr = {4'b1110, 7'd127};
    ren = 1'b1;
    wen = 1'b0;
    @(negedge clk)
    ren = 1'b0;
    @(negedge clk)
    $finish;
end

always #5 clk = ~clk;

endmodule