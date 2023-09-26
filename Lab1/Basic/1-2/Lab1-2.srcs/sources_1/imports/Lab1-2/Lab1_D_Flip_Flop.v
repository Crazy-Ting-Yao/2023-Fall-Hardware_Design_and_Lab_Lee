`timescale 1ns/1ps

module D_Flip_Flop(clk, d, q);
input clk;
input d;
output q;
wire not_clk, temp;
not nclk(not_clk, clk);

D_Latch Master(not_clk, d, temp);
D_Latch Slave(clk, temp, q);
endmodule

module D_Latch(e, d, q);
input e;
input d;
output q;

wire node1, node2, notd, notq;
not nd(notd, d);
nand nand1(node1, d, e);
nand nand2(node2, notd, e);
nand nand3(notq, node1, q);
nand nand4(q, node2, notq);

endmodule