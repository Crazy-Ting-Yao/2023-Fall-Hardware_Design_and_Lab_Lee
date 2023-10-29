`timescale 1ns/1ps

module priority_encoder_4bit(in, out);
    input [15:0] in;
    output reg [3:0] out;
    always @(*) begin
        if(in[15]) out = 4'b1111;
        else if(in[14]) out = 4'b1110;
        else if(in[13]) out = 4'b1101;
        else if(in[12]) out = 4'b1100;
        else if(in[11]) out = 4'b1011;
        else if(in[10]) out = 4'b1010;
        else if(in[9]) out = 4'b1001;
        else if(in[8]) out = 4'b1000;
        else if(in[7]) out = 4'b0111;
        else if(in[6]) out = 4'b0110;
        else if(in[5]) out = 4'b0101;
        else if(in[4]) out = 4'b0100;
        else if(in[3]) out = 4'b0011;
        else if(in[2]) out = 4'b0010;
        else if(in[1]) out = 4'b0001;
        else out = 4'b0000;
    end
endmodule

module Content_Addressable_Memory(clk, wen, ren, din, addr, dout, hit);
    input clk;
    input wen, ren;
    input [7:0] din;
    input [3:0] addr;
    output [3:0] dout;
    output hit;

    reg [7:0] memory [15:0];
    wire [15:0] match;
    reg [3:0] dout;
    reg hit;
    wire [3:0] temp_dout;
    priority_encoder_4bit match_encoder(match, temp_dout);

    assign match[0] = memory[0] === din;
    assign match[1] = memory[1] === din;
    assign match[2] = memory[2] === din;
    assign match[3] = memory[3] === din;
    assign match[4] = memory[4] === din;
    assign match[5] = memory[5] === din;
    assign match[6] = memory[6] === din;
    assign match[7] = memory[7] === din;
    assign match[8] = memory[8] === din;
    assign match[9] = memory[9] === din;
    assign match[10] = memory[10] === din;
    assign match[11] = memory[11] === din;
    assign match[12] = memory[12] === din;
    assign match[13] = memory[13] === din;
    assign match[14] = memory[14] === din;
    assign match[15] = memory[15] === din;

    always @(posedge clk) begin
        if(ren) begin
            dout <= temp_dout;
            hit <= (match != 16'd0);
        end
        else if(wen) begin
            memory[addr] <= din;
            hit <= 1'b0;
            dout <= 4'b0000;
        end
        else begin
            hit <= 1'b0;
            dout <= 4'b0000;
        end
    end
endmodule
