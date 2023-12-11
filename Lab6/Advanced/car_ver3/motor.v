module motor(
    input clk,
    input rst,
    input [2:0] mode,
    output [1:0] pwm,
    output [1:0] dir // 1: backward, 0: forward
);
    reg signed [10:0] next_left_motor, next_right_motor;
    reg signed [10:0] left_motor, right_motor;
    wire left_pwm, right_pwm;
    wire [11:0] period = 32'd4000;
    reg [11:0] count;
    wire [9:0] left_motor_abs, right_motor_abs;

    assign left_motor_abs = (left_motor[10]) ? ~left_motor[9:0] + 10'b1 : left_motor[9:0];
    assign right_motor_abs = (right_motor[10]) ? ~right_motor[9:0] + 10'b1 : right_motor[9:0];

    assign dir = {left_motor[10], right_motor[10]};

    PWM_gen pg0(clk, rst, left_motor_abs, count, left_pwm);
    PWM_gen pg1(clk, rst, right_motor_abs, count, right_pwm);
    
    always @(posedge clk, posedge rst) begin
        if (rst) count <= 32'b0;
        else count <= (count + 1 == period) ? 0 : count + 32'd1;
    end

    always @(*) begin
        case (mode)
            3'b111: begin
                next_left_motor  = (left_motor  > 11'sd1000) ? 11'sd1023 : left_motor  + 11'sd23;
                next_right_motor = (right_motor > 11'sd1000) ? 11'sd1023 : right_motor + 11'sd23;
            end
            3'b110: begin
                next_left_motor  = (left_motor  > 11'sd0)   ? left_motor - 11'sd100 : -11'sd100;
                next_right_motor = (right_motor > 11'sd1003) ? 11'sd1023 : right_motor + 11'sd20;
            end
            3'b100: begin
                next_left_motor  = (left_motor  > -11'sd100)  ? left_motor - 11'sd200 : -11'sd800;
                next_right_motor = (right_motor > 11'sd1003) ? 11'sd1023 : right_motor + 11'sd20;
            end
            3'b011: begin
                next_left_motor  = (left_motor  > 11'sd1003) ? 11'sd1023 : left_motor  + 11'sd20;
                next_right_motor = (right_motor > 11'sd0)   ? right_motor - 11'sd100 : -11'sd100;
            end
            3'b001: begin
                next_left_motor  = (left_motor  > 11'sd1003) ? 11'sd1023 : left_motor  + 11'sd20;
                next_right_motor = (right_motor > -11'sd100)  ? right_motor - 11'sd200 : -11'sd800;
            end
            3'b000: begin
                next_left_motor  = (left_motor  > right_motor) ? 11'sd1023 : 11'sd0;
                next_right_motor = (left_motor  > right_motor) ? 11'sd0 : 11'sd1023;
            end
            default: begin
                next_left_motor  = -11'sd750;
                next_right_motor = -11'sd750;
            end
        endcase
    end

    always @(negedge count[11], posedge rst)begin
        if (rst) begin
            left_motor  <= 11'sd1023;
            right_motor <= 11'sd1023;
        end 
        else begin
            left_motor  <= next_left_motor;
            right_motor <= next_right_motor;
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

