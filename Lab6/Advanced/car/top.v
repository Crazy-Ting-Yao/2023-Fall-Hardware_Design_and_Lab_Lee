module Top(
    input CLK,

    input BTNC, // button reset
    input [5:0] SW,

    input JB4, // linetrack left
    input JB3, // linetrack center
    input JB2, // linetrack right

    input JA3, // sonic echo
    output JA4, // sonic trig
    
    output JC7, // motor ENA (left)
    output JC8, // motor IN1 (left)
    output JC9, // motor IN2 (left)
    output JC1, // motor ENB (right)
    output JC3, // motor IN3 (right)
    output JC2, // motor IN4 (right)

    output [15:0] LED,
    output [7:0] SEGD,
    output [3:0] SEGA
);

    wire rst_op, rst_pb;
    debounce db0(rst_pb, BTNC, CLK);
    onepulse op0(rst_pb, CLK, rst_op);

    wire [1:0] pwm; // {left, right}
    motor A(
        .clk(CLK),
        .rst(rst_op),
        //.mode(),
        .pwm(pwm)
    );

    wire [19:0] dis;
    wire stop;

    sonic_top B(
        .clk(CLK), 
        .rst(rst_op), 
        .Echo(JA3), 
        .Trig(JA4),
        .stop(stop),
        .dis(dis)
    );
    
    // tracker_sensor C(
    //     .clk(CLK), 
    //     .reset(rst_op), 
    //     .left_signal(JB4), 
    //     .right_signal(JB3),
    //     .mid_signal(JB2)
    //     //.state()
    // );

    // debugging outputs
    wire [1:0] left, right;
    assign {JC8, JC9} = left;
    assign {JC3, JC2} = right;

    assign JC7 = SW[5] & pwm[1] & (!stop);
    assign JC1 = SW[4] & pwm[0] & (!stop);
    assign left = SW[3:2];
    assign right = SW[1:0];

    assign LED = {
        {JB4, JB3, JB2, 1'b0},
        {stop, 3'b0},
        {2'b0, JC7, JC1},
        {dis[19:16]}};

    wire [7:0] seg3, seg2, seg1, seg0;
    seg_map sm3(dis[15:12], seg3);
    seg_map sm2(dis[11: 8], seg2);
    seg_map sm1(dis[ 7: 4], seg1);
    seg_map sm0(dis[ 3: 0], seg0);
    // seg_map sm3(dis[19:16], seg3);
    // seg_map sm2(dis[15:12], seg2);
    // seg_map sm1(dis[11: 8], seg1);
    // seg_map sm0(dis[ 7: 4], seg0);
    seg_mux sm(CLK, seg3, seg2, seg1, seg0, SEGD, SEGA);

    // control
    always @(*) begin
        // [TO-DO] Use left and right to set your pwm
        //if(stop) {left, right} = ???;
        //else  {left, right} = ???;
    end

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

