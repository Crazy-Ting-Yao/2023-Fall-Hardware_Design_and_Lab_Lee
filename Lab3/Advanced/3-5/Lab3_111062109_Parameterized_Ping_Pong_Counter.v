`timescale 1ns/1ps

module Parameterized_Ping_Pong_Counter (clk, rst_n, enable, flip, max, min, direction, out);
input clk, rst_n;
input enable;
input flip;
input [4-1:0] max;
input [4-1:0] min;
output direction;
output [4-1:0] out;
wire _enable;
reg direction;
reg [4-1:0] out;
assign _enable = enable && !(out > max || out < min || (out == max && out == min));
always @(posedge clk) begin
    if(!rst_n)begin
        out <= min;
        direction <= 1;
    end
    else begin
        if(_enable) begin
            if(out==max) begin
                out <= out - 1;
                direction <= 1'b0;
            end
            else if(out==min) begin
                out <= out + 1;
                direction <= 1'b1;
            end
            else if(flip) begin
                out <= (direction) ? out - 1 : out + 1;
                direction <= ~direction;
            end
            else begin
                out <= (direction) ? out + 1 : out - 1;
                direction <= direction;
            end
        end
        else begin
            out <= out;
            direction <= direction;
        end
    end
end
endmodule
