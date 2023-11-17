`timescale 1ns/1ps
`include "Lab5_111062109_Traffic_Light_Controller.v"

module Traffic_Light_Controller_t;
    reg clk, rst_n, lr_has_car;
    wire [2:0] hw_light, lr_light;

    Traffic_Light_Controller TLC(clk, rst_n, lr_has_car, hw_light, lr_light);
    parameter cyctime = 10;
    initial begin
        $dumpfile("Traffic_Light_Controller.vcd");
        $dumpvars(0, Traffic_Light_Controller_t);
        clk = 0;
        rst_n = 0;
        lr_has_car = 0;
        #cyctime rst_n = 1;
        #(cyctime*40) lr_has_car = 1;
        #(cyctime*80) lr_has_car = 0;
        #(cyctime*200) lr_has_car = 1;
        #(cyctime*280) lr_has_car = 0;
        #(cyctime*10) $finish;
    end
    always #5 clk = ~clk;
endmodule