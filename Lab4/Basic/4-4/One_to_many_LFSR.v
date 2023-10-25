`timescale 1ns/1ps

module One_to_many_LFSR(rst_n, clk, out);
    input rst_n, clk;
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

    assign next_DFF = {DFF[6:4], DFF[7] ^ DFF[3], DFF[7] ^ DFF[2], DFF[7] ^ DFF[1], DFF[0], DFF[7]};
    assign out = DFF[7];
endmodule