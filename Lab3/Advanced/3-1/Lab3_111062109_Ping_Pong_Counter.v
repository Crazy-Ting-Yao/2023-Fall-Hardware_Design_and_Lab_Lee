`timescale 1ns/1ps

module Ping_Pong_Counter (clk, rst_n, enable, direction, out);
input clk, rst_n;
input enable;
output direction;
output [4-1:0] out;

reg [4-1:0] out;
reg direction;

always @(posedge clk)
begin
    if (rst_n == 1'b0) begin
        out <= 4'b0000;
        direction <= 1'b1;
    end
    else if (enable == 1'b1) begin
        if (direction == 1'b1) begin
            if (out == 4'b1111) begin
                out <= 4'b1110;
                direction <= 1'b0;
            end
            else begin
                out <= out + 1'b1;
                direction <= direction;
            end
        end
        else
        begin
            if (out == 4'b0000)begin
                out <= 4'b0001;
                direction <= 1'b1;
            end
            else begin 
                out <= out - 1'b1;
                direction <= direction;
            end
        end
    end
    else begin
        out <= out;
        direction <= direction;
    end
end
endmodule
