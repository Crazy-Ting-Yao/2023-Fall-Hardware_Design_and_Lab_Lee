`timescale 1ns/1ps

module Moore (clk, rst_n, in, out, state);
input clk, rst_n;
input in;
output [2-1:0] out;
output [3-1:0] state;
reg [3-1:0] state;
reg [3-1:0] next_state;
reg [2-1:0] out;
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
        S0: out = 2'b11;
        S1: out = 2'b01;
        S2: out = 2'b11;
        S3: out = 2'b10;
        S4: out = 2'b10;
        S5: out = 2'b00;
    endcase
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

`timescale 1ns/1ps
