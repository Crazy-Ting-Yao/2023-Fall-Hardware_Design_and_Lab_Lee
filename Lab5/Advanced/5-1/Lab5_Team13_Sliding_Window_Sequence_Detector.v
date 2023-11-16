`timescale 1ns/1ps

module Sliding_Window_Sequence_Detector (clk, rst_n, in, dec);
    input clk, rst_n;
    input in;
    output reg dec;

    reg [3:0] state;
    reg [3:0] nxt_state;

    parameter S0 = 3'b000; // _
    parameter S1 = 3'b001; // 1_
    parameter S2 = 3'b010; // 11_
    parameter S3 = 3'b011; // 110_
    parameter S4 = 3'b100; // 1100_
    parameter S5 = 3'b101; // 1100(10)*1_
    parameter S6 = 3'b110; // 1100(10)*10_
    parameter S7 = 3'b111; // 1100(10)*101_

    always @(posedge clk) begin
        if(rst_n == 1'b0) state <= S0;
        else state <= nxt_state;
    end

    always @(*) begin
        case ({state, in})
            {S0, 1'b0}: nxt_state = S0;
            {S0, 1'b1}: nxt_state = S1;
            {S1, 1'b0}: nxt_state = S0;
            {S1, 1'b1}: nxt_state = S2;
            {S2, 1'b0}: nxt_state = S3;
            {S2, 1'b1}: nxt_state = S2;
            {S3, 1'b0}: nxt_state = S4;
            {S3, 1'b1}: nxt_state = S1;
            {S4, 1'b0}: nxt_state = S0;
            {S4, 1'b1}: nxt_state = S5;
            {S5, 1'b0}: nxt_state = S6;
            {S5, 1'b1}: nxt_state = S2;
            {S6, 1'b0}: nxt_state = S7;
            {S6, 1'b1}: nxt_state = S5;
            {S7, 1'b0}: nxt_state = S0;
            {S7, 1'b1}: nxt_state = S1;
        endcase
    end

    always @(*) begin
        case ({state, in})
            {S7, 1'b1}: dec = 1'b1;
            default: dec = 1'b0;
        endcase
    end
endmodule