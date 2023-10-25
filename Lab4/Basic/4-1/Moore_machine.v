`timescale 1ns/1ps

module moore_machine(clk, in, rst_n, state);

input clk;
input in;
input rst_n;
output [3-1:0] state;
reg [3-1:0] state;
reg [3-1:0] next_state;

parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;
parameter S5 = 3'b101;

always @(posedge clk) begin
    if(!rst_n) begin
        state <= S0;
    end
    else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        S0: begin
            if(in) next_state = S2;
            else next_state = S1;
        end
        S1: begin
            if(in) next_state = S5;
            else next_state = S4;
        end
        S2: begin
            if(in) next_state = S3;
            else next_state = S1;
        end
        S3: begin
            if(in) next_state = S0;
            else next_state = S1;
        end
        S4: begin
            if(in) next_state = S5;
            else next_state = S4;
        end
        S5: begin
            if(in) next_state = S0;
            else next_state = S3;
        end
    endcase
end

endmodule