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
    output [1:0]right // JC9, JC8
);
    wire rst_op, rst_pb, stop, _stop;
    wire [2:0] state;
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
    assign state = stop ? 3'b111 : {!left_signal, !mid_signal, !right_signal};
    assign left = (state==3'b111) ? 2'b00 : 2'b10;
    assign right = (state==3'b111) ? 2'b00 : 2'b10;
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

