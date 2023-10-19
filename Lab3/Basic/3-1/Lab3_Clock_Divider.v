`timescale 1ns/1ps

module Clock_Divider (clk, rst_n, sel, clk1_2, clk1_4, clk1_8, clk1_3, dclk);
input clk, rst_n;
input [2-1:0] sel;
output clk1_2;
output clk1_4;
output clk1_8;
output clk1_3;
output dclk;
reg clk1_2, clk1_3, clk1_4, clk1_8;
reg dclk;
reg counter_2 = 1'b0;
reg [1:0] counter_3 = 2'b00;
reg [1:0] counter_4 = 2'b00;
reg [2:0] counter_8 = 3'b000;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk1_2 <= 1'b1;
        clk1_3 <= 1'b1;
        clk1_4 <= 1'b1;
        clk1_8 <= 1'b1;
        counter_2 <= 1'b0;
        counter_3 <= 2'b00;
        counter_4 <= 2'b00;
        counter_8 <= 3'b000;
    end
    else begin
        if (counter_2 == 1'b1) begin
            clk1_2 <= 1;
            counter_2 <= 0;
        end
        else begin
            clk1_2 <= 0;
            counter_2 <= 1;
        end
        if (counter_3 == 2'b10) begin
            clk1_3 <= 1;
            counter_3 <= 2'b00;
        end
        else begin
            clk1_3 <= 0;
            counter_3 <= counter_3 + 1'b1;
        end
        if (counter_4 == 2'b11) begin
            clk1_4 <= 1;
            counter_4 <= 2'b00;
        end
        else begin
            clk1_4 <= 0;
            counter_4 <= counter_4 + 1'b1;
        end
        if (counter_8 == 3'b111) begin
            clk1_8 <= 1;
            counter_8 <= 3'b000;
        end
        else begin
            clk1_8 <= 0;
            counter_8 <= counter_8 + 1'b1;
        end
    end
end
always @(*) begin
    case (sel)
        2'b00: begin
            dclk = clk1_3;
        end
        2'b01: begin
            dclk = clk1_2;
        end
        2'b10: begin
            dclk = clk1_4;
        end
        2'b11: begin
            dclk = clk1_8;
        end
    endcase
end
endmodule