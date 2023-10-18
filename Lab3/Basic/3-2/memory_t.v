`timescale 1ns / 1ps
`include "memory.v"
module memory_t;
    reg clk;
    reg ren;
    reg wen;
    reg [6:0] addr;
    reg [7:0] din;
    wire [7:0] dout;

    memory uut (
        .clk(clk),
        .ren(ren),
        .wen(wen),
        .addr(addr),
        .din(din),
        .dout(dout)
    );

    initial begin
        $dumpfile("memory.vcd");
        $dumpvars(0, memory_t);
        clk = 0;
        ren = 0;
        wen = 0;
        addr = 0;
        din = 0;
        #10 wen = 1;
        addr = 7'd63;
        din = 8'd4;
        #10 addr = 7'd45;
        din = 8'd8;
        #10 addr = 7'd87;
        din = 8'd35;
        #10 addr = 7'd26;
        din = 8'd77;
        #10 addr = 7'd0;
        din = 8'd0;
        wen = 0;
        #30 ren = 1;
        addr = 7'd87;
        #10 addr = 7'd26;
        #10 addr = 7'd63;
        #10 addr = 7'd45;
        #10 ren = 0;
        addr = 7'd0;
        #30 $finish;
    end

    always begin
        #5 clk = ~clk;
    end
endmodule