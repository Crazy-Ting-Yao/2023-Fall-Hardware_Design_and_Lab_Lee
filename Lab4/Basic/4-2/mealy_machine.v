`timescale 1ns/1ps

module mealy_machine(clk, in, rst_n, state, out);
    input clk, in, rst_n;
    output [3-1:0] state;
    output out;
    reg out;
    reg [3-1:0] state;
    reg [3-1:0] next_state;
    parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101;
    
    always @(posedge clk) begin
        if(!rst_n) begin
            state <= S0;
        end
        else begin
            state <= next_state;
        end
    end
    
    always @(*) begin
        case (state)
            S0: begin
                if(in) begin
                    next_state = S2;
                    out = 1;
                end
                else begin
                    next_state = S0;
                    out = 0;
                end
            end
            S1: begin
                out = 1;
                if(in) next_state = S4; 
                else next_state = S0;
            end
            S2: begin
                if(in) begin
                    next_state = S1;
                    out = 0;
                end
                else begin
                    next_state = S5;
                    out = 1;
                end
            end
            S3: begin
                if(in) begin
                    next_state = S2;
                    out = 0;
                end
                else begin
                    next_state = S3;
                    out = 1;
                end
            end
            S4: begin
                out = 1;
                if(in) next_state = S4;
                else next_state = S2;
            end
            S5: begin
                out = 0;
                if(in) next_state = S4;
                else next_state = S3;
            end
        endcase
    end
endmodule