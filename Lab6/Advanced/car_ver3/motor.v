module motor(
    input clk,
    input rst,
    input [2:0] mode,
    output [1:0] pwm,
    output [1:0] dir // 1: backward, 0: forward
);
    reg signed [9:0] next_left_motor, next_right_motor;
    reg signed [9:0] left_motor, right_motor;
    wire left_pwm, right_pwm;
    wire [11:0] period = 32'd4000;
    reg [11:0] count;
    wire [9:0] left_motor_abs, right_motor_abs;

    assign left_motor_abs = {1'b1, (left_motor[9]) ? ~left_motor[8:0] : left_motor[8:0]};
    assign right_motor_abs = {1'b1, (right_motor[9]) ? ~right_motor[8:0] : right_motor[8:0]};

    assign dir = {left_motor[9], right_motor[9]};

    PWM_gen pg0(clk, rst, left_motor_abs, count, left_pwm);
    PWM_gen pg1(clk, rst, right_motor_abs, count, right_pwm);
    
    always @(posedge clk, posedge rst) begin
        if (rst) count <= 32'b0;
        else count <= (count + 1 == period) ? 0 : count + 32'd1;
    end
    parameter signed full_speed = 10'sd511;
    parameter signed minimum_speed = -10'sd300;
    parameter signed increment = 10'sd50;
    parameter signed low_decrement = -10'sd100;
    parameter signed high_decrement = -10'sd200;
    always @(*) begin
        case (mode)
            3'b111: begin
                next_left_motor  = (left_motor > full_speed - increment) ? full_speed : left_motor + increment;
                next_right_motor = (right_motor  > full_speed - increment) ? full_speed : right_motor + increment;
            end
            3'b110: begin
                next_left_motor  = (left_motor + low_decrement > 10'sd0)  ? left_motor + low_decrement : 10'sd0;
                next_right_motor = (right_motor > full_speed - increment) ? full_speed : right_motor + increment;
            end
            3'b100: begin
                next_left_motor  = (left_motor + high_decrement > minimum_speed)  ? left_motor + high_decrement : minimum_speed;
                next_right_motor = (right_motor  > full_speed - increment) ? full_speed : right_motor + increment;
            end
            3'b011: begin
                next_left_motor  = (left_motor > full_speed - increment) ? full_speed : left_motor + increment;
                next_right_motor = (right_motor + low_decrement > 10'sd0) ? right_motor + low_decrement : 10'sd0;
            end
            3'b001: begin
                next_left_motor  = (left_motor > full_speed - increment) ? full_speed : left_motor + increment;
                next_right_motor = (right_motor + high_decrement > minimum_speed)  ? right_motor + high_decrement : minimum_speed;
            end
            3'b000: begin
                next_left_motor  = (left_motor  > right_motor) ? full_speed : minimum_speed;
                next_right_motor = (left_motor  > right_motor) ? minimum_speed : full_speed;
            end
            default: begin
                next_left_motor  = minimum_speed;
                next_right_motor = minimum_speed;
            end
        endcase
    end

    always @(posedge clk, posedge rst)begin
        if (rst) begin
            left_motor  <= full_speed;
            right_motor <= full_speed;
        end 
        else if (count == 0) begin
            left_motor  <= next_left_motor;
            right_motor <= next_right_motor;
        end
        else begin
            left_motor  <= left_motor;
            right_motor <= right_motor;
        end
    end
    assign pwm = {left_pwm, right_pwm};
endmodule

//generte PWM by input frequency & duty
module PWM_gen (
    input wire clk,
    input wire reset,
    input [9:0] duty,
    input [11:0] count,
    output reg PWM
);
    wire [11:0] count_duty = 32'd4000 * duty / 32'd1024;
    always @(posedge clk, posedge reset) begin
        if (reset) PWM <= 1'b0;
        else if(count < count_duty) PWM <= 1'b1;
        else PWM <= 1'b0;
    end
endmodule

