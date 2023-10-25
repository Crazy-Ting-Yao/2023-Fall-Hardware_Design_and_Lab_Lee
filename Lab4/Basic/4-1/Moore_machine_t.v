`timescale 1ns / 1ps
`include "Moore_machine.v"

module Moore_machine_t;
    reg clk, rst_n, in;
    wire [3-1:0] state;
    
    moore_machine moore_machine(clk, in, rst_n, state);

    initial begin
        $dumpfile("moore_machine.vcd");
        $dumpvars(0, moore_machine);
        clk = 0;
        rst_n = 0;
        in = 0;
        #10 rst_n = 1;
        repeat (10) begin
            #10 in = $random % 2;
        end
        #10 rst_n = 0;
        #10 in = 1;
        #10 rst_n = 1;
        repeat (20) begin
            #10 in = $random % 2;
        end
        #10 $finish;
    end

    always #5 clk = ~clk;
endmodule