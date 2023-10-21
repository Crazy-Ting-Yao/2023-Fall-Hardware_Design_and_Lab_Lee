`timescale 1ns/1ps

module clock_divider(clk, clk_out);
input clk;
output clk_out;

reg clk_out;
reg [27-1:0] counter = 0;

always @(posedge clk) begin
    if(counter == 27'd100000000-1) begin
        counter <= 0;
        clk_out <= 1;
    end
    else begin
        counter <= counter + 1;
        clk_out <= 0;
    end
end
endmodule

module debounce(clk, button, button_debounced);
input clk;
input button;
output button_debounced;
reg [3:0] counter;
always @(posedge clk) begin
    counter <<= 1;
    counter[0] <= button;
end

and a1 (button_debounced, counter[0], counter[1], counter[2], counter[3]);
endmodule

module one_pulse(clk, signal, pulse);
input clk;
input signal;
output pulse;
reg pulse;
reg A;
always @(posedge clk) begin
    A <= signal;
    pulse <= signal & ~A;
end

endmodule

module seven_segment(clk, num, direction, AN, out);
    input clk;
    input direction;
    input [4-1:0] num;
    output reg [4-1:0] AN;
    output [7-1:0] out;
    reg [7-1:0] out;
    reg [3:0] counter;
    always @(num or direction) begin
        counter = 1;
    end
    always @(posedge clk) begin
        counter <<= 1;
        AN <= ~counter[3:0];
        if(counter[0] || counter[1]) begin
            if(direction) begin
                out <= ~7'b0011100;
            end
            else begin
                out <= ~7'b0100111;
            end
        end
        else if(counter[2]) begin
            case (num)
                0: out <= ~7'b0111111;
                1: out <= ~7'b0000110;
                2: out <= ~7'b1011011;
                3: out <= ~7'b1001111;
                4: out <= ~7'b1100110;
                5: out <= ~7'b1101101;
                6: out <= ~7'b1111101;
                7: out <= ~7'b0000111;
                8: out <= ~7'b1111111;
                9: out <= ~7'b1101111;
                10: out <= ~7'b0111111;
                11: out <= ~7'b0000110;
                12: out <= ~7'b1011011;
                13: out <= ~7'b1001111;
                14: out <= ~7'b1100110;
                15: out <= ~7'b1101101;
                16: out <= ~7'b1111101;
            endcase
        end
        else if(counter[3]) begin
            if(num > 9) out <= ~7'b0000110;
            else out <= ~7'b0000000;
        end
    end
endmodule

module Parameterized_Ping_Pong_Counter_FPGA (clk, rst_n, enable, flip, max, min, AN, segs);
input clk, rst_n;
input enable;
input flip;
input [4-1:0] max;
input [4-1:0] min;
output [4-1:0] AN;
output [7-1:0] segs;

reg direction;
reg [4-1:0] out;

wire clk_s;
wire rst_debounced, rst_enable;
wire flip_debounced, flip_enable;


clock_divider cd( .clk(clk), .clk_out(clk_s));
debounce db(.clk(clk), .button(rst_n), .button_debounced(rst_debounced));
debounce db2(.clk(clk), .button(flip), .button_debounced(flip_debounced));
one_pulse op(.clk(clk), .signal(rst_debounced), .pulse(rst_enable));
one_pulse op2(.clk(clk), .signal(flip_debounced), .pulse(flip_enable));
seven_segment ss(.clk(clk), .num(out), .direction(direction), .AN(AN), .out(segs));

always @(posedge clk_s) begin
    if(!rst_debounced)begin
        out <= min;
        direction <= 1;
    end
    else begin
        if(enable) begin
            if(out > max || out < min || ((out == max) && (out == min))) begin
                out <= out;
            end
            else begin
                if(flip_debounced) begin
                    out <= (direction) ? out - 1 : out + 1;
                    direction <= ~direction;
                end
                else if(out==max) begin
                    out <= out - 1;
                    direction <= 1'b0;
                end
                else if(out==min) begin
                    out <= out + 1;
                    direction <= 1'b1;
                end
                else begin
                    out <= (direction) ? out + 1 : out - 1;
                end
            end
        end
    end
end
endmodule
