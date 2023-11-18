`timescale 1ns/1ps

module Greatest_Common_Divisor (clk, rst_n, start, a, b, done, gcd);
    input clk, rst_n;
    input start;
    input [15:0] a;
    input [15:0] b;
    output done;
    output [15:0] gcd;

    parameter WAIT = 2'b00;
    parameter CAL = 2'b01;
    parameter FINISH = 2'b10;

    reg [1:0] state, next_state;
    reg [15:0] a_tmp, b_tmp;
    reg [15:0] next_a, next_b;
    reg [15:0] gcd, next_gcd;

    reg delay_one_cycle;
    always @(posedge clk) begin
        if(!rst_n)begin
            state <= WAIT;
            delay_one_cycle <= 0;
            gcd <= 0;
        end
        else begin
            state <= next_state;
            gcd <= next_gcd;
            if(next_state==FINISH) delay_one_cycle <= ~delay_one_cycle;
            else delay_one_cycle <= 0;
        end
        a_tmp <= next_a;
        b_tmp <= next_b;
    end

    always @(*) begin
        case(state)
        WAIT: begin
            if(start) next_state = CAL;
            else next_state = WAIT;
        end
        CAL: begin
            if(a_tmp == 0 || b_tmp == 0) next_state = FINISH;
            else next_state = CAL;
        end
        FINISH: begin
            if(delay_one_cycle) next_state = FINISH;
            else next_state = WAIT;
        end
        default: begin
            next_state = WAIT;
        end
        endcase
    end

    always @(*) begin
        case(state)
        WAIT: begin
            next_a = a;
            next_b = b;
        end
        CAL: begin
            if(a_tmp>b_tmp) begin
                next_a = a_tmp - b_tmp;
                next_b = b_tmp;
            end
            else begin
                next_a = a_tmp;
                next_b = b_tmp - a_tmp;
            end
        end
        FINISH: begin
            next_a = a_tmp;
            next_b = b_tmp;
        end
        default: begin
            next_a = a_tmp;
            next_b = b_tmp;
        end
        endcase
    end

    assign done = (state==FINISH);

    always @(*) begin
        if(next_state==FINISH) 
            next_gcd = a_tmp ? a_tmp : b_tmp;
        else 
            next_gcd = 0;
    end
endmodule
