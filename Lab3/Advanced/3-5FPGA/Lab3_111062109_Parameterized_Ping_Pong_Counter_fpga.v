module clock_divider1(clk, rst, clk_out);
input clk;
input rst;
output clk_out;

reg clk_out;
reg [27-1:0] counter = 0;

always @(posedge clk) begin
    if(rst) begin
        counter <= 0;
        clk_out <= 0;
    end
    else begin
        if(counter == 2**26-1) begin
            counter <= 0;
            clk_out <= 1;
        end
        else begin
            counter <= counter + 1;
            clk_out <= 0;
        end
    end
end
endmodule

module clock_divider2(clk, rst, clk_out);
input clk;
input rst;
output clk_out;

reg clk_out;
reg [16-1:0] counter = 0;

always @(posedge clk) begin
    if(rst) begin
        counter <= 0;
        clk_out <= 0;
    end
    else begin
        if(counter == 2**16-1) begin
            counter <= 0;
            clk_out <= 1;
        end
        else begin
            counter <= counter + 1;
            clk_out <= 0;
        end
    end
end
endmodule

module debounce(clk, button, button_debounced);
input clk;
input button;
output button_debounced;
reg [3:0] counter;
always @(posedge clk) begin
    counter[3:1] <= counter[2:0];
    counter[0] <= button;
end

and a1 (button_debounced, counter[0], counter[1], counter[2], counter[3]);
endmodule

module one_pulse(clk, signal, pulse);
input clk;
input signal;
output reg pulse;
reg A = 0;
always @(posedge clk) begin
    A <= signal;
    pulse <= signal & ~A;
end

endmodule

module seven_segment(clk, num, direction, AN, out);
    input clk;
    input direction;
    input [4-1:0] num;
    output [4-1:0] AN;
    output [7-1:0] out;
    reg [7-1:0] out;
    reg [1:0] counter = 0;
    reg [4-1:0] AN;

    always @(negedge clk) begin
        counter <= counter + 1;
    end

    always @(*)begin
        case (counter)
        2'b00: begin
            AN = 4'b1110;
            if(direction == 1'b1) out = 7'b1011100;
            else out = 7'b1100011;
        end
        2'b01: begin
            AN = 4'b1101;
            if(direction == 1'b1) out = 7'b1011100;
            else out = 7'b1100011;
        end
        2'b10: begin
            AN = 4'b1011;
            case (num)
            4'b0000: out = 7'b1000000;
            4'b0001: out = 7'b1111001;
            4'b0010: out = 7'b0100100;
            4'b0011: out = 7'b0110000;
            4'b0100: out = 7'b0011001;
            4'b0101: out = 7'b0010010;
            4'b0110: out = 7'b0000010;
            4'b0111: out = 7'b1111000;
            4'b1000: out = 7'b0000000;
            4'b1001: out = 7'b0010000;
            4'b1010: out = 7'b1000000;
            4'b1011: out = 7'b1111001;
            4'b1100: out = 7'b0100100;
            4'b1101: out = 7'b0110000;
            4'b1110: out = 7'b0011001;
            4'b1111: out = 7'b0010010;
            endcase
        end
        2'b11: begin
            AN = 4'b0111;
            if(num > 4'b1001) out = 7'b1111001;
            else out = 7'b1000000;
        end
        endcase
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

wire clk_s, clk_seg;
wire rst_debounced, rst_enable;
wire flip_debounced, flip_enable;
clock_divider1 cd1( .clk(clk), .rst(rst_enable), .clk_out(clk_s));
clock_divider2 cd2( .clk(clk), .rst(rst_enable), .clk_out(clk_seg));
debounce db(.clk(clk), .button(rst_n), .button_debounced(rst_debounced));
debounce db2(.clk(clk), .button(flip), .button_debounced(flip_debounced));
one_pulse op(.clk(clk), .signal(rst_debounced), .pulse(rst_enable));
one_pulse op2(.clk(clk), .signal(flip_debounced), .pulse(flip_enable));
seven_segment ss(.clk(clk_seg), .num(out), .direction(direction), .AN(AN), .out(segs));
always @(posedge clk) begin
    if(rst_enable)begin
        out <= min;
        direction <= 1;
    end
    else if(flip_enable) begin
        direction <= ~direction;
    end
    else if(enable && clk_s) begin
        if(out > max || out < min || ((out == max) && (out == min))) begin
            out <= out;
        end
        else begin
            if(flip_enable) begin
                out <= (direction) ? out - 1 : out + 1;
                direction <= ~direction;
            end
            else if(out===max) begin
                out <= out - 1;
                direction <= 1'b0;
            end
            else if(out===min) begin
                out <= out + 1;
                direction <= 1'b1;
            end
            else begin
                out <= (direction) ? out + 1 : out - 1;
            end
        end
    end
end
endmodule
