module clock_divider1(clk, rst, clk_out);
    input clk;
    input rst;
    output clk_out;
    reg [26-1:0] counter;

    always @(posedge clk) begin
        if(rst)  counter <= 0;
        else counter <= counter + 1;
    end
    assign clk_out = (~counter == 26'd0) ? 1:0;
endmodule

module clock_divider2(clk, rst, clk_out);
    input clk;
    input rst;
    output clk_out;
    reg [16-1:0] counter;

    always @(posedge clk) begin
        if(rst)  counter <= 0;
        else counter <= counter + 1;
    end
    assign clk_out = (~counter == 16'd0) ? 1:0;
endmodule

module debounce(clk, button, button_debounced);
    input clk;
    input button;
    output button_debounced;
    reg [15:0] counter;
    always @(posedge clk) begin
        counter[15:1] <= counter[14:0];
        counter[0] <= button;
    end
    assign button_debounced = (counter == ~16'd0) ? 1:0;
endmodule

module one_pulse(clk, signal, pulse);
    input clk;
    input signal;
    output reg pulse;
    reg A;
    always @(negedge clk) begin
        A <= signal;
        pulse <= signal & ~A;
    end
endmodule

module seven_segment(clk, clk_seg, rst, num, direction, AN, out);
    input clk, clk_seg, rst;
    input direction;
    input [4-1:0] num;
    output [4-1:0] AN;
    output [7-1:0] out;
    reg [7-1:0] out;
    reg [1:0] counter;
    reg [4-1:0] AN;

    always @(posedge clk) begin
        if(rst) counter <= 0;
        else if(clk_seg) counter <= counter + 1;
        else counter <= counter;
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
            default: out = 7'b1111111;
            endcase
        end
        2'b11: begin
            AN = 4'b0111;
            if(num > 4'b1001) out = 7'b1111001;
            else out = 7'b1000000;
        end
        default: begin
            AN = 4'b1111;
            out = 7'b1111111;
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
    wire _enable;
    wire clk_s, clk_seg;
    wire rst_debounced, rst_enable;
    wire flip_debounced, flip_enable;
    clock_divider1 cd1( .clk(clk), .rst(rst_enable), .clk_out(clk_s));
    clock_divider2 cd2( .clk(clk), .rst(rst_enable), .clk_out(clk_seg));
    debounce db(.clk(clk), .button(rst_n), .button_debounced(rst_debounced));
    debounce db2(.clk(clk), .button(flip), .button_debounced(flip_debounced));
    one_pulse op(.clk(clk), .signal(rst_debounced), .pulse(rst_enable));
    one_pulse op2(.clk(clk), .signal(flip_debounced), .pulse(flip_enable));
    seven_segment ss(.clk(clk), .clk_seg(clk_seg), .rst(rst_enable), .num(out), .direction(direction), .AN(AN), .out(segs));
    assign _enable = enable && !(out > max || out < min || (out == max && out == min));
    always @(posedge clk) begin
        if(rst_enable)begin
            out <= min;
            direction <= 1;
        end
        else if(_enable && clk_s) begin
            if(out===max) begin
                out <= out - 1;
                direction <= 1'b0;
            end
            else if(out===min) begin
                out <= out + 1;
                direction <= 1'b1;
            end
            else if(flip_enable) begin
                out <= (direction) ? out - 1 : out + 1;
                direction <= ~direction;
            end
            else begin
                direction <= direction;
                out <= (direction) ? out + 1 : out - 1;
            end
        end
        else if(flip_enable && _enable) begin
            direction <= ~direction;
            out <= out;
        end
        else begin
            direction <= direction;
            out <= out;
        end
    end
endmodule
