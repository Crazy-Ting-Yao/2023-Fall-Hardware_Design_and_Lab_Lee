`timescale 1ns/1ps

module Many_to_one_LFSR(clk, rst_n, out);
    input clk, rst_n;
    output out;
    reg [8-1:0] DFF;
    wire [8-1:0] next_DFF;
    wire temp1, temp2;
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