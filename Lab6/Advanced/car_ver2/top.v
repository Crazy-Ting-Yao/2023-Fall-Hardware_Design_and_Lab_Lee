module Top(
    input clk, 
    input rst, // BTNC
    input echo, // JA3
    input left_signal, // JB4
    input right_signal, // JB2
    input mid_signal,   // JB3
    input SW15, // SW15
    output trig,     // JA4
    output left_motor,  // JC1
    output [1:0]left, // JC3, JC2
    output right_motor, // JC7
    output [1:0]right, // JC9, JC8
    output [15:0] LED,
    output [7:0] SEGD,
    output [3:0] SEGA
);
    wire rst_op, rst_pb, stop, _stop;
    wire [2:0] state;
    wire [19:0] dis;
    debounce d0(rst_pb, rst, clk);
    onepulse d1(rst_pb, clk, rst_op);
    motor A(
        .clk(clk),
        .rst(rst_op | stop),
        .mode(state),
        .pwm({right_motor, left_motor})
    );
    sonic_top B(
        .clk(clk), 
        .rst(rst_op), 
        .Echo(echo), 
        .Trig(trig),
        .stop(_stop)
    );
    assign stop = _stop | (!SW15);
    assign state = stop ? 3'b000 : {left_signal, mid_signal, right_signal};
    assign left = (state==3'b000) ? 2'b00 : 2'b10;
    assign right = (state==3'b000) ? 2'b00 : 2'b10;

    wire [7:0] seg3, seg2, seg1, seg0;
    assign LED = {
        {stop, 3'b0},
        {left_signal, mid_signal, right_signal, 1'b0},
        {2'b0, right_motor, left_motor},
        {4'b0}};
    seg_map sm3(dis[19:16], seg3);
    seg_map sm2(dis[15:12], seg2);
    seg_map sm1(dis[11: 8], seg1);
    seg_map sm0(dis[ 7: 4], seg0);
    seg_mux sm(CLK, seg3, seg2, seg1, seg0, SEGD, SEGA);
endmodule

module debounce (pb_debounced, pb, clk);
    output pb_debounced; 
    input pb;
    input clk;
    reg [4:0] DFF;
    
    always @(posedge clk) begin
        DFF[4:1] <= DFF[3:0];
        DFF[0] <= pb; 
    end
    assign pb_debounced = (&(DFF)); 
endmodule

module onepulse (PB_debounced, clk, PB_one_pulse);
    input PB_debounced;
    input clk;
    output reg PB_one_pulse;
    reg PB_debounced_delay;

    always @(posedge clk) begin
        PB_one_pulse <= PB_debounced & (! PB_debounced_delay);
        PB_debounced_delay <= PB_debounced;
    end 
endmodule

