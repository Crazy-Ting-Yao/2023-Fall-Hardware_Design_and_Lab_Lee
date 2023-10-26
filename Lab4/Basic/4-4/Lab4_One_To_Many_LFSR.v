`timescale 1ns/1ps

module One_TO_Many_LFSR(clk, rst_n, out);
    input clk;
    input rst_n;
    output reg [8-1:0] out;
    wire [8-1:0] next_DFF;

    always @(posedge clk) begin
        if(!rst_n) begin
            out <= 8'b10111101;
        end
        else begin
            out <= next_DFF;
        end
    end

    assign next_DFF = {out[6:4], out[7] ^ out[3], out[7] ^ out[2], out[7] ^ out[1], out[0], out[7]};
endmodule
