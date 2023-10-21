`timescale 1ns/1ps

module Memory (clk, ren, wen, addr, din, dout);
input clk;
input ren, wen;
input [7-1:0] addr;
input [8-1:0] din;
output [8-1:0] dout;
reg [8-1:0] dout;
reg [7:0] My_Memory [127:0];

always @(posedge clk) begin
    if (ren) begin
        dout = My_Memory[addr];
    end
    else if (wen) begin
        My_Memory[addr] = din;
        dout = 0;
    end
    else begin
        dout = 0;
    end
end
endmodule

module Bank (clk, ren, wen, waddr, raddr, din, dout);
input clk;
input ren, wen;
input [9-1:0] waddr;
input [9-1:0] raddr;
input [8-1:0] din;
output reg [8-1:0] dout;
wire [8-1:0] douts [3:0];
reg [7-1:0] addrs [3:0];

always @(*) begin
    if(ren) begin
        addrs[raddr[8:7]] <= raddr[6:0];
        if(wen && (waddr[8:7] != raddr[8:7])) begin
            addrs[waddr[8:7]] <= waddr[6:0];
        end
    end
    else if(wen) begin
        addrs[waddr[8:7]] <= waddr[6:0];
    end
end

Memory M0(clk, (ren && (raddr[8:7]==2'b00)), (wen && (waddr[8:7]==2'b00)), addrs[0], din, douts[0]);
Memory M1(clk, (ren && (raddr[8:7]==2'b01)), (wen && (waddr[8:7]==2'b01)), addrs[1], din, douts[1]);
Memory M2(clk, (ren && (raddr[8:7]==2'b10)), (wen && (waddr[8:7]==2'b10)), addrs[2], din, douts[2]);
Memory M3(clk, (ren && (raddr[8:7]==2'b11)), (wen && (waddr[8:7]==2'b11)), addrs[3], din, douts[3]);

always @(douts[0], douts[1], douts[2], douts[3]) begin
    if(ren) begin
        dout = douts[raddr[8:7]];
    end
    else begin
        dout = 0;
    end
end

endmodule


module Multi_Bank_Memory (clk, ren, wen, waddr, raddr, din, dout);
input clk;
input ren, wen;
input [11-1:0] waddr;
input [11-1:0] raddr;
input [8-1:0] din;
output reg [8-1:0] dout;

wire [8-1:0] douts [3:0];
Bank B0(clk, (ren & (raddr[10:9]==2'b00)), (wen & (waddr[10:9]==2'b00)), waddr[8:0], raddr[8:0], din, douts[0]);
Bank B1(clk, (ren & (raddr[10:9]==2'b01)), (wen & (waddr[10:9]==2'b01)), waddr[8:0], raddr[8:0], din, douts[1]);
Bank B2(clk, (ren & (raddr[10:9]==2'b10)), (wen & (waddr[10:9]==2'b10)), waddr[8:0], raddr[8:0], din, douts[2]);
Bank B3(clk, (ren & (raddr[10:9]==2'b11)), (wen & (waddr[10:9]==2'b11)), waddr[8:0], raddr[8:0], din, douts[3]);

always @(douts[0], douts[1], douts[2], douts[3], posedge clk) begin
    if(ren) begin
        dout = douts[raddr[10:9]];
    end
    else begin
        dout = 0;
    end
end

endmodule
