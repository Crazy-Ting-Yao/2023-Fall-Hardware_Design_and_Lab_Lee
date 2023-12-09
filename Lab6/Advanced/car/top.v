module Top(
    input CLK,

    input BTNC, // button reset
    input [15:0] SW,

    input JB4, // linetrack left
    input JB3, // linetrack center
    input JB2, // linetrack right

    input JA3, // sonic echo
    output JA4, // sonic trig
    
    output JC7, // motor ENA (right)
    output JC8, // motor IN1 (right)
    output JC9, // motor IN2 (right)
    output JC1, // motor ENB (left)
    output JC3, // motor IN3 (left)
    output JC2, // motor IN4 (left)

    output [15:0] LED,
    output [7:0] SEGD,
    output [3:0] SEGA
);
    /*
    SW[15]: sonic detection | 40cm(1)   | disabled(0)
    SW[14]: drive on        | black(1)  | white(0)
    SW[13]: motor speed     | fast(1)   | slow(0)
    SW[12]: car control     | manual(1) | auto(0)
    SW[11]: rotate on lost  | left(0)   | right(1)
    SW[10]:                 |           | 
    SW[9]:                  |           | 
    SW[8]:                  |           | 
    SW[7]:                  |           | 
    SW[6]:                  |           | 
    SW[5]:  motor left      | enable(1) | disable(0)
    SW[4]:                  | stop(00, 11)
    SW[3]:                  | forward(10), backward(01)
    SW[2]:  motor right     | enable(1) | disable(0)
    SW[1]:                  | stop(00, 11)
    SW[0]:                  | forward(01), backward(10)
    */

    wire rst_op, rst_pb;
    debounce db0(rst_pb, BTNC, CLK);
    onepulse op0(rst_pb, CLK, rst_op);

    wire [1:0] pwm; // {left, right}
    wire [1:0] state; // 00: stop, 01: turn right, 10: turn left, 11: go straight
    wire [2:0] mode;
    motor A(
        .clk(CLK),
        .rst(rst_op),
        .mode({SW[13], SW[12] ? 2'b11 : state[1:0]}), // SW[13] (0: slow, 1: fast)
        .pwm(pwm)
    );

    wire [19:0] dis;
    wire stop;

    sonic_top B(
        .clk(CLK), 
        .rst(rst_op), 
        .Echo(JA3), 
        .thres(SW[15]),
        .Trig(JA4),
        .stop(stop),
        .dis(dis)
    );
    
    tracker_sensor C(
        .clk(CLK), 
        .reset(rst_op), 
        .left_signal(JB4), 
        .right_signal(JB3),
        .mid_signal(JB2),
        .target(SW[14]), // 0: white, 1: black
        .state(state)
    );

    // control
    reg [1:0] left, right;
    assign {JC3, JC2} = left;
    assign {JC8, JC9} = right;
    assign {JC7, JC1} = pwm;

    always @(*) begin
        // [TO-DO] Use left and right to set your pwm
        if (SW[12]) begin // manual mode 
            left  = (stop | (!SW[5])) ? 2'b00 : SW[3:2];
            right = (stop | (!SW[4])) ? 2'b00 : SW[1:0];
        end else begin // auto mode
            if (stop) begin
                {left, right} = 4'b0000;
            end else begin
                if (state == 2'b00)
                    {left, right} = SW[11] ? 4'b1010 : 4'b0101;
                else
                    {left, right} = 4'b1001;
            end
        end
    end

    // debugging outputs
    assign LED = {
        {stop, 3'b0},
        {JB4, JB3, JB2, 1'b0},
        {2'b0, JC7, JC1},
        {4'b0}};

    wire [7:0] seg3, seg2, seg1, seg0;
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

