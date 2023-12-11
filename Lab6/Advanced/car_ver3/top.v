module Top(
    input clk, 
    input rst, // BTNC
    input echo, // JA3
    input left_signal, // JB4
    input right_signal, // JB2
    input mid_signal,   // JB3
    input SW15, // SW15
    input SW14, // SW14
    output trig,     // JA4
    output left_motor,  // JC1
    output [1:0]left, // JC3, JC2
    output right_motor, // JC7
    output [1:0] right, // JC9, JC8
    output [15:0] LED
);
    wire rst_op, rst_pb, stop;
    wire [2:0] state;
    wire [19:0] dis;
    wire left_dir, right_dir;
    debounce d0(rst_pb, rst, clk);
    onepulse d1(rst_pb, clk, rst_op);
    motor A(
        .clk(clk),
        .rst(rst_op | stop),
        .mode(state),
        .pwm({left_motor, right_motor}),
        .dir({left_dir, right_dir})
    );
    sonic_top B(
        .clk(clk), 
        .rst(rst_op), 
        .Echo(echo),
        .thres(SW14),
        .Trig(trig),
        .stop(stop)
    );
    assign state = {left_signal, mid_signal, right_signal};
    assign left  = (stop | (!SW15)) ? 2'b00 : (left_dir  ? 2'b01 : 2'b10);
    assign right = (stop | (!SW15)) ? 2'b00 : (right_dir ? 2'b01 : 2'b10);

    // debugging signals
    assign LED[15:0] = {
        {stop, 3'b0},
        {state, 1'b0},
        {4'b0},
        {~left_dir, left_dir, right_dir, ~right_dir}
    };
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
