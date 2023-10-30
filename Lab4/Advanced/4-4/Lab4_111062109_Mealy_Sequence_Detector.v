`timescale 1ns/1ps

module Mealy_Sequence_Detector (clk, rst_n, in, dec);
    input clk, rst_n;
    input in;
    output dec;

    parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101, S6 = 3'b110, S7 = 3'b111;

    reg [2:0] state, next_state;
    reg dec;

    reg [1:0] count;

    always @(posedge clk) begin
        if(!rst_n) begin
            state <= S0;
            count <= 2'b00;
            dec <= 0;
        end
        else begin
            if(count == 2'b11) begin
                count <= 2'b00;
                state <= S0;
            end
            else begin
                count <= count + 1;
                state <= next_state;
            end
        end
    end
    always @(*) begin
        case (state)
            S0: begin
                dec = 0;
                next_state = in ? S1 : S4;
            end
            S1: begin
                dec = 0;
                next_state = in ? S6 : S2;
            end
            S2: begin
                dec = 0;
                next_state = in ? S0 : S3;
            end
            S3: begin
                next_state = S0;
                dec = in;
            end
            S4: begin
                dec = 0;
                next_state = in ? S5 : S0;
            end
            S5: begin
                dec = 0;
                next_state = in ? S3 : S0;
            end
            S6: begin
                dec = 0;
                next_state = in ? S7 : S0;
            end
            S7: begin
                next_state = S0;
                dec = !in;
            end
        endcase
    end
endmodule
