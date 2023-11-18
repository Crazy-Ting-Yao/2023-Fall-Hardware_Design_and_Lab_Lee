`timescale 1ns/1ps 

module Booth_Multiplier_4bit(clk, rst_n, start, a, b, p);
    input clk;
    input rst_n; 
    input start;
    input signed [3:0] a, b;
    output signed [7:0] p;
    reg signed [8:0] A, next_A;
    reg signed [8:0] S, next_S;
    reg signed [8:0] temp_p, next_temp_p;

    parameter WAIT = 2'b00, CAL = 2'b01, FINISH = 2'b10;

    reg [1:0] state, next_state;
    
    reg [1:0] counter, next_counter;
    
    always @ (posedge clk) begin
        if (!rst_n)begin
            state <= WAIT;
            counter <= 0;
        end
        else begin 
            state <= next_state;
            counter <= next_counter;
        end
    end

    always @(*) begin
        case(state)
        WAIT: next_counter = 0;
        CAL: next_counter = counter + 1;
        FINISH: next_counter = ~counter;
        endcase
    end

    always @(*) begin
        case(state)
        WAIT: begin
            if (start) next_state = CAL;
            else next_state = WAIT;
        end
        CAL: begin
            if (counter == 2'b11) next_state = FINISH;
            else next_state = CAL;
        end
        FINISH: begin
            if (counter == 2'b11) next_state = WAIT;
            else next_state = FINISH;
        end
        endcase
    end

    always @(posedge clk) begin
        if(!rst_n) begin
            A <= 0;
            S <= 0;
            temp_p <= 0;
        end
        else begin
            A <= next_A;
            S <= next_S;
            temp_p <= next_temp_p;
        end
    end

    always @(*) begin
        if(state==WAIT && start) begin
            next_A = {a, 5'b00000};
            next_S = {~a, 5'b00000} + 6'b100000;
        end
        else begin
            next_A = A;
            next_S = S;
        end
    end

    always @(*) begin
        case(state)
        WAIT: begin
            if(start) next_temp_p = {4'b0000, b, 1'b0};
            else next_temp_p = 0;
        end
        CAL: begin
            case(temp_p[1:0])
            2'b00: next_temp_p = temp_p>>>1;
            2'b01: next_temp_p = (temp_p+A)>>>1;
            2'b10: next_temp_p = (temp_p+S)>>>1;
            2'b11: next_temp_p = temp_p>>>1;
            endcase
        end
        endcase
    end
    
    assign p = (state==FINISH) ? temp_p[8:1] : 8'd0;
    
endmodule
