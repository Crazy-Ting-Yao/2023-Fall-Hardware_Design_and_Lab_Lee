`timescale 1ns/1ps

module Sliding_Window_Sequence_Detector (clk, rst_n, in, dec);
    input clk, rst_n;
    input in;
    output dec;

    parameter S0 = 3'd0, S1 = 3'd1, S2 = 3'd2, S3 = 3'd3, S4 = 3'd4, S5 = 3'd5, S6 = 3'd6, S7 = 3'd7;

    reg [2:0] state, next_state;

    always @(posedge clk) begin
        if(!rst_n) state <= S0;
        else state <= next_state;
    end

    always @(*) begin
        case(state)
        S0: next_state = in ? S1 : S0;
        S1: next_state = in ? S2 : S0;
        S2: next_state = in ? S3 : S0;
        S3: next_state = in ? S3 : S4;
        S4: next_state = in ? S1 : S5;
        S5: next_state = in ? S6 : S0;
        S6: next_state = in ? S7 : S5;
        S7: next_state = in ? S3 : S0;
        default: next_state = S0;
        endcase
    end
    assign dec = (state==S7 && in);
endmodule 