`timescale 1ns/1ps

module FIFO_8(clk, rst_n, wen, ren, din, dout, error);
input clk;
input rst_n;
input wen, ren;
input [8-1:0] din;
output [8-1:0] dout;
output error;

reg [8-1:0] memory [7:0];
reg [8-1:0] dout;
reg error;
reg [7:0] dontcare;
reg [2:0] write_pointer;
reg [2:0] read_pointer;
reg full;
always @(posedge clk) begin
    if(rst_n == 1'b0) begin
        write_pointer <= 0;
        read_pointer <= 0;
        error <= 0;
        dout <= 0;
        full <= 0;
    end
    else begin
        if(ren == 1'b1) begin
            if(write_pointer == read_pointer && full == 0) begin
                error <= 1;
                dout <= dontcare;
            end
            else begin
                dout <= memory[read_pointer];
                read_pointer <= read_pointer + 1;
                error <= 0;
                full <= 0;
            end
        end
        else if(wen == 1'b1) begin
            if(full) begin
                error <= 1;
                dout <= dontcare;
            end
            else begin
                memory[write_pointer] <= din;
                write_pointer <= write_pointer + 1;
                dout <= dontcare;
                error <= 0;
                if(write_pointer + 1 == read_pointer || (write_pointer == 7 && read_pointer == 0)) begin
                    full <= 1;
                end
            end
        end
        else begin
            error <= 0;
            dout <= dontcare;
        end
    end
end



endmodule
