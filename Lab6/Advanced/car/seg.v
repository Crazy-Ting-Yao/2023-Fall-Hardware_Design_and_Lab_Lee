module seg_mux(clk, in3, in2, in1, in0, segd, sega);
    input clk;
    input [7:0] in3, in2, in1, in0;
    output reg [7:0] segd;
    output reg [3:0] sega;

    reg [1:0] cnt;

    wire dclk;
    clock_div cd(clk, dclk);

    always @(posedge clk) begin
        if (dclk) cnt <= cnt + 1'b1;
    end

    always @(*) begin
        case (cnt)
            2'd0: begin segd = in0; sega = 4'b1110; end
            2'd1: begin segd = in1; sega = 4'b1101; end
            2'd2: begin segd = in2; sega = 4'b1011; end
            2'd3: begin segd = in3; sega = 4'b0111; end
            default: begin segd = 8'b11111111; sega = 4'b1111; end
        endcase
    end
endmodule

module seg_map(in, seg);
    input [3:0] in;
    output reg [7:0] seg;

    always @(*) begin
        case (in)
            4'h0: seg = 8'b11000000;
            4'h1: seg = 8'b11111001;
            4'h2: seg = 8'b10100100;
            4'h3: seg = 8'b10110000;
            4'h4: seg = 8'b10011001;
            4'h5: seg = 8'b10010010;
            4'h6: seg = 8'b10000010;
            4'h7: seg = 8'b11111000;
            4'h8: seg = 8'b10000000;
            4'h9: seg = 8'b10010000;
            4'hA: seg = 8'b10001000;
            4'hb: seg = 8'b10000011;
            4'hC: seg = 8'b11000110;
            4'hd: seg = 8'b10100001;
            4'hE: seg = 8'b10000110;
            4'hF: seg = 8'b10001110;
        endcase
    end
endmodule

module clock_div(clk, dclk);
    input clk;
    output dclk;

    reg [17:0] cnt;

    always @(posedge clk) begin
        cnt <= cnt + 1'b1;
    end

    assign dclk = (~|(cnt));
endmodule