`timescale 1ns/1ps
`include "Lab2_111062109_Decode_And_Execute.v"

module Decode_And_Execute_v;
reg [4-1:0] rs = 4'b0000;
reg [4-1:0] rt = 4'b0001;
reg [3-1:0] sel = 3'b000;
wire [4-1:0] rd;
reg [4-1:0] test;
reg error = 1'b0;
Decode_And_Execute DAE (rs, rt, sel, rd);

initial begin
    $dumpfile("Decode_And_Execute.vcd");
    $dumpvars(0, Decode_And_Execute_v);
    repeat(2**4) begin
        repeat(2**4) begin
            rt = rt + 1;
            #1;
            test = rs - rt;
            if(test === rd)begin
                error = 1'b0;
            end
            else begin
                error = 1'b1;
            end
            #1;
        end
        rs = rs + 1;
    end
    sel = 3'b001;
    repeat(2**4) begin
        repeat(2**4) begin
            rt = rt + 1;
            #1;
            test = rs + rt;
            if(test === rd)begin
                error = 1'b0;
            end
            else begin
                error = 1'b1;
            end
            #1;
        end
        rs = rs + 1;
    end
    sel = 3'b010;
    repeat(2**4) begin
        repeat(2**4) begin
            rt = rt + 1;
            #1;
            test = rs | rt;
            if(test === rd)begin
                error = 1'b0;
            end
            else begin
                error = 1'b1;
            end
            #1;
        end
        rs = rs + 1;
    end
    sel = 3'b011;
    repeat(2**4) begin
        repeat(2**4) begin
            rt = rt + 1;
            #1;
            test = rs & rt;
            if(test === rd)begin
                error = 1'b0;
            end
            else begin
                error = 1'b1;
            end
            #1;
        end
        rs = rs + 1;
    end
    sel = 3'b100;
    repeat(2**4) begin
        rt = rt + 1;
        #1;
        test = {rt[3], rt[3:1]};
        if(test === rd)begin
            error = 1'b0;
        end
        else begin
            error = 1'b1;
        end
        #1;
    end
    sel = 3'b101;
    repeat(2**4) begin
        rs = rs + 1;
        #1;
        test = {rs[2:0], rs[3]};
        if(test === rd)begin
            error = 1'b0;
        end
        else begin
            error = 1'b1;
        end
        #1;
    end
    sel = 3'b110;
    repeat(2**4) begin
        repeat(2**4) begin
            rt = rt + 1;
            #1;
            test = {3'b101, (rs<rt?1'b1:1'b0)};
            if(test === rd)begin
                error = 1'b0;
            end
            else begin
                error = 1'b1;
            end
            #1;
        end
        rs = rs + 1;
    end
    sel = 3'b111;
    repeat(2**4) begin
        repeat(2**4) begin
            rt = rt + 1;
            #1;
            test = {3'b111, (rs===rt ? 1'b1 : 1'b0)};
            if(test === rd)begin
                error = 1'b0;
            end
            else begin
                error = 1'b1;
            end
            #1;
        end
        rs = rs + 1;
    end
    $finish;
end
endmodule