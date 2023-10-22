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


module Round_Robin_FIFO_Arbiter(clk, rst_n, wen, a, b, c, d, dout, valid);
input clk;
input rst_n;
input [4-1:0] wen;
input [8-1:0] a, b, c, d;
output [8-1:0] dout;
output valid;

wire [8-1:0] douts[3:0];
wire [3:0] error;
reg valid;
reg [1:0] counter;
reg [2:0] fifo_out;
always @(posedge clk) begin
    if(!rst_n)begin
        counter <= 0;
        fifo_out <= 3'b100;
    end
    else begin
        counter <= counter + 1;
        fifo_out <= {1'b0, counter};
    end
end

always @ (error or fifo_out)begin
    if(fifo_out == 3'b100) valid = 1'b0;
    else if(wen[fifo_out[1:0]] || error[fifo_out[1:0]]) valid = 1'b0;
    else valid = 1'b1;
end

assign dout = valid ? douts[fifo_out[1:0]] : 8'd0;

FIFO_8 a_fifo(clk, rst_n, wen[0], (counter == 2'b00 && !wen[0]), a, douts[0], error[0]);
FIFO_8 b_fifo(clk, rst_n, wen[1], (counter == 2'b01 && !wen[1]), b, douts[1], error[1]);
FIFO_8 c_fifo(clk, rst_n, wen[2], (counter == 2'b10 && !wen[2]), c, douts[2], error[2]);
FIFO_8 d_fifo(clk, rst_n, wen[3], (counter == 2'b11 && !wen[3]), d, douts[3], error[3]);


endmodule
