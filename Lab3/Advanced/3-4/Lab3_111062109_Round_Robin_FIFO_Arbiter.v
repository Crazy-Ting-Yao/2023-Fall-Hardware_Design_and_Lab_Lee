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

always @(*) begin
    if(ren == 1'b1) begin
        if(wen == 1'b0) begin
            if(write_pointer == read_pointer && full == 0) begin
                error = 1;
                dout = dontcare;
            end
            else begin
                error = 0;
                dout = memory[read_pointer];
            end
        end
        else begin
            error = 1;
            dout = dontcare;
        end
    end
end

always @(posedge clk) begin
    if(rst_n == 1'b0) begin
        write_pointer <= 0;
        read_pointer <= 0;
        error <= 0;
        dout <= 0;
        full <= 0;
    end
    else begin
        if(wen == 1'b1) begin
            if(!full) begin
                memory[write_pointer] <= din;
                write_pointer <= write_pointer + 1;
                if(write_pointer + 1 == read_pointer || (write_pointer == 7 && read_pointer == 0)) begin
                    full <= 1;
                end
            end
        end
        else if (ren == 1'b1 && error == 0) begin
            read_pointer <= read_pointer + 1;
            full <= 0;
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
reg dout;
wire [8-1:0] douts [3:0];
reg valid;
reg [1:0] cnt;
wire [3:0] errors;

FIFO_8 FIFO_a(clk, rst_n, wen[0], (cnt==2'b00), a, douts[0], errors[0]);
FIFO_8 FIFO_b(clk, rst_n, wen[1], (cnt==2'b01), b, douts[1], errors[1]);
FIFO_8 FIFO_c(clk, rst_n, wen[2], (cnt==2'b10), c, douts[2], errors[2]);
FIFO_8 FIFO_d(clk, rst_n, wen[3], (cnt==2'b11), d, douts[3], errors[3]);

always @(posedge clk) begin
    if(!rst_n) begin
        cnt <= 2'b00;
        dout <= 8'b0;
        valid <= 0;
    end
    else begin
        cnt <= cnt + 1;
        if(errors[cnt] == 1'b1) begin
            valid <= 0;
            dout <= 0;
        end
        else begin
            valid <= 1;
            dout <= douts[cnt];
        end
    end
end

endmodule
