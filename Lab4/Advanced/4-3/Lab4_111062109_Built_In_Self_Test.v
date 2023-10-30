`timescale 1ns/1ps

module Scan_DFF(clk, rst_n, scan_in, scan_en, data, out);
    input clk;
    input rst_n;
    input scan_in;
    input scan_en;
    input data;
    output reg out;


    always @(posedge clk) begin
        if(!rst_n) begin
            out <= 1'b0;
        end
        else begin
            if(scan_en) begin
                out <= scan_in;
            end
            else begin
                out <= data;
            end
        end
    end
endmodule

module Scan_Chain_Design(clk, rst_n, scan_in, scan_en, scan_out);
    input clk;
    input rst_n;
    input scan_in;
    input scan_en;
    output scan_out;

    
    wire [3:0] a, b;
    wire [7:0] p;
    assign p = a * b;

    Scan_DFF dff1(clk, rst_n, b[1], scan_en, p[0], b[0]);
    Scan_DFF dff2(clk, rst_n, b[2], scan_en, p[1], b[1]);
    Scan_DFF dff3(clk, rst_n, b[3], scan_en, p[2], b[2]);
    Scan_DFF dff4(clk, rst_n, a[0], scan_en, p[3], b[3]);
    Scan_DFF dff5(clk, rst_n, a[1], scan_en, p[4], a[0]);
    Scan_DFF dff6(clk, rst_n, a[2], scan_en, p[5], a[1]);
    Scan_DFF dff7(clk, rst_n, a[3], scan_en, p[6], a[2]);
    Scan_DFF dff8(clk, rst_n, scan_in, scan_en, p[7], a[3]);
    
    assign scan_out = b[0];

endmodule

module Many_To_One_LFSR(clk, rst_n, out);
    input clk;
    input rst_n;
    output out;
    reg [8-1:0] DFF;
    wire [8-1:0] next_DFF;
    always @(posedge clk) begin
        if(!rst_n) begin
            DFF <= 8'b10111101;
        end
        else begin
            DFF <= next_DFF;
        end
    end
    assign next_DFF = {DFF[6:0] , (DFF[7] ^ DFF[3]) ^ (DFF[1] ^ DFF[2])};
    assign out = DFF[7];
endmodule

module Built_In_Self_Test(clk, rst_n, scan_en, scan_in, scan_out);
    input clk;
    input rst_n;
    input scan_en;
    output scan_in;
    output scan_out;

    Many_To_One_LFSR MTOL(clk, rst_n, scan_in);
    Scan_Chain_Design SCD(clk, rst_n, scan_in, scan_en, scan_out);

endmodule
