`timescale 1ns/1ps
module fanout(in, out);
    input in;
    output [3:0] out;
    wire temp;
    not n1(temp, in);
    not n2(out[0], temp);
    not n3(out[1], temp);
    not n4(out[2], temp);
    not n5(out[3], temp);
endmodule

module debounce(clk, in, out);
    input clk;
    input in;
    output out;

    reg [7:0] DFF;

    always @(negedge clk) DFF <= {DFF[6:0], in};

    assign out = (DFF == ~8'd0) ? 1 : 0;
endmodule

module one_pulse(clk, in, out);
    input clk;
    input in;
    output out;

    reg A;

    always @(negedge clk) A <= in;

    assign out = in & ~A;
endmodule

module seven_segs(clk, rst_n, scan_in, scan_out, a, b, AN, segs);
    input clk;
    input rst_n;
    input scan_in;
    input scan_out;
    input [3:0] a, b;
    output reg [3:0] AN;
    output reg [6:0] segs;

    wire clk_1000Hz;
    reg [19-1:0] clk_counter;
    reg [1:0] refresh_counter;
    assign clk_1000Hz = (~clk_counter == 19'b0) ? 1 : 0;
    always @(posedge clk) begin
        if(!rst_n) begin
            clk_counter <= 0;
            refresh_counter <= 0;
        end
        else begin
            clk_counter <= clk_counter + 1;
            if(clk_1000Hz) refresh_counter <= refresh_counter + 1;
            else refresh_counter <= refresh_counter;
        end
    end
    always @(*) begin
        case (refresh_counter)
            2'b00: begin
                AN = 4'b1110;
                if(scan_out) segs = 7'b1111001;
                else segs = 7'b1000000;
            end
            2'b01: begin
                AN = 4'b1101;
                case(b)
                    4'b0000: segs = 7'b1000000;
                    4'b0001: segs = 7'b1111001;
                    4'b0010: segs = 7'b0100100;
                    4'b0011: segs = 7'b0110000;
                    4'b0100: segs = 7'b0011001;
                    4'b0101: segs = 7'b0010010;
                    4'b0110: segs = 7'b0000010;
                    4'b0111: segs = 7'b1111000;
                    4'b1000: segs = 7'b0000000;
                    4'b1001: segs = 7'b0010000;
                    4'b1010: segs = 7'b0001000;
                    4'b1011: segs = 7'b0000011;
                    4'b1100: segs = 7'b1000110;
                    4'b1101: segs = 7'b0100001;
                    4'b1110: segs = 7'b0000110;
                    4'b1111: segs = 7'b0001110;
                endcase
            end
            2'b10: begin
                AN = 4'b1011;
                case(a)
                    4'b0000: segs = 7'b1000000;
                    4'b0001: segs = 7'b1111001;
                    4'b0010: segs = 7'b0100100;
                    4'b0011: segs = 7'b0110000;
                    4'b0100: segs = 7'b0011001;
                    4'b0101: segs = 7'b0010010;
                    4'b0110: segs = 7'b0000010;
                    4'b0111: segs = 7'b1111000;
                    4'b1000: segs = 7'b0000000;
                    4'b1001: segs = 7'b0010000;
                    4'b1010: segs = 7'b0001000;
                    4'b1011: segs = 7'b0000011;
                    4'b1100: segs = 7'b1000110;
                    4'b1101: segs = 7'b0100001;
                    4'b1110: segs = 7'b0000110;
                    4'b1111: segs = 7'b0001110;
                endcase                
            end
            2'b11: begin
                AN = 4'b0111;
                if(scan_in) segs = 7'b1111001;
                else segs = 7'b1000000;
            end
            default: begin
                AN = 4'b1111;
                segs = 7'b1111111;
            end
        endcase
    end

endmodule
module Scan_DFF(clk, d_clk, rst_n, scan_in, scan_en, data, out);
    input clk, d_clk;
    input rst_n;
    input scan_in;
    input scan_en;
    input data;
    output reg out;


    always @(posedge clk) begin
        if(!rst_n) begin
            out <= 1'b0;
        end
        else if(d_clk) begin
            if(scan_en) begin
                out <= scan_in;
            end
            else begin
                out <= data;
            end
        end
    end
endmodule

module Scan_Chain_Design(clk, d_clk, rst_n, scan_in, scan_en, scan_out, scanDFF);
    input clk, d_clk;
    input rst_n;
    input scan_in;
    input scan_en;
    output scan_out;
    output [7:0] scanDFF;
    wire [7:0] p;
    assign p = scanDFF[3:0] * scanDFF[7:4];

    Scan_DFF dff1(clk, d_clk, rst_n, scanDFF[1], scan_en, p[0], scanDFF[0]);
    Scan_DFF dff2(clk, d_clk, rst_n, scanDFF[2], scan_en, p[1], scanDFF[1]);
    Scan_DFF dff3(clk, d_clk, rst_n, scanDFF[3], scan_en, p[2], scanDFF[2]);
    Scan_DFF dff4(clk, d_clk, rst_n, scanDFF[4], scan_en, p[3], scanDFF[3]);
    Scan_DFF dff5(clk, d_clk, rst_n, scanDFF[5], scan_en, p[4], scanDFF[4]);
    Scan_DFF dff6(clk, d_clk, rst_n, scanDFF[6], scan_en, p[5], scanDFF[5]);
    Scan_DFF dff7(clk, d_clk, rst_n, scanDFF[7], scan_en, p[6], scanDFF[6]);
    Scan_DFF dff8(clk, d_clk, rst_n, scan_in, scan_en, p[7], scanDFF[7]);
    
    assign scan_out = scanDFF[0];
endmodule

module Many_To_One_LFSR(clk, d_clk, rst_n, LFSR_rst, out);
    input clk, d_clk;
    input rst_n;
    input [7:0] LFSR_rst;
    output out;
    reg [8-1:0] DFF;
    wire [8-1:0] next_DFF;
    always @(posedge clk) begin
        if(!rst_n) begin
            DFF <= LFSR_rst;
        end
        else if(d_clk) begin
            DFF <= next_DFF;
        end
    end
    assign next_DFF = {DFF[6:0] , (DFF[7] ^ DFF[3]) ^ (DFF[1] ^ DFF[2])};
    assign out = DFF[7];
endmodule

module Built_In_Self_Test_fpga(clk, d_clk, rst, LFSR_rst, scan_en, scanDFF, AN, segs);
    input clk, d_clk;
    input rst;
    input [7:0] LFSR_rst;
    input scan_en;
    output [7:0] scanDFF;
    output [3:0] AN;
    output [6:0] segs;
    wire scan_in;
    wire scan_out;
    wire [3:0] fanout_clks;
    wire rst_debounced, rst_pulse, rst_n;
    wire d_clk_debounced, d_clk_pulse;
    debounce DB(fanout_clks[0], rst, rst_debounced);
    one_pulse OP(fanout_clks[0], rst_debounced, rst_pulse);
    assign rst_n = ~rst_pulse;
    debounce DB2(fanout_clks[1], d_clk, d_clk_debounced);
    one_pulse OP2(fanout_clks[1], d_clk_debounced, d_clk_pulse);
    Many_To_One_LFSR MTOL(fanout_clks[1], d_clk_pulse, rst_n, LFSR_rst, scan_in);
    Scan_Chain_Design SCD(fanout_clks[2], d_clk_pulse, rst_n, scan_in, scan_en, scan_out, scanDFF);
    seven_segs SS(fanout_clks[3], rst_n, scan_in, scan_out, scanDFF[7:4], scanDFF[3:0], AN, segs);
    fanout FAN(clk, fanout_clks);
endmodule
