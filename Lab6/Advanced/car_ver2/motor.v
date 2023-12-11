module motor(
    input clk,
    input rst,
    input [2:0] mode,
    output [1:0] pwm
);
    reg [9:0] next_left_motor, next_right_motor;
    reg [9:0] left_motor, right_motor;
    wire left_pwm, right_pwm;

    PWM_gen pg0(clk, rst, left_motor, count, left_pwm);
    PWM_gen pg1(clk, rst, right_motor, count, right_pwm);
    
    wire [11:0] period = 32'd4000;
    reg [11:0] count;
        
    always @(posedge clk, posedge rst) begin
        if (rst) count <= 32'b0;
        else count <= (count + 1 == period) ? 0 : count + 32'd1;
    end

    always @(negedge count[11], posedge rst)begin
        if(rst)begin
            left_motor <= 10'd1023;
            right_motor <= 10'd1023;
        end 
        else begin
            case(mode)
            3'b111: begin
                left_motor <= (left_motor>10'd1000) ? 10'd1023 : left_motor + 10'd23;
                right_motor <= (right_motor>10'd1000) ? 10'd1023 : right_motor + 10'd23;
            end
            3'b110: begin
                left_motor <= (left_motor > 10'd10) ? left_motor - 10'd10 : 0;
                right_motor <= (right_motor> 10'd1003) ? 10'd1023 : right_motor + 10'd20;
            end
            3'b100: begin
                left_motor <= (left_motor > 10'd100) ? left_motor - 10'd100 : 0;
                right_motor <= (right_motor > 10'd1003) ? 10'd1023 : right_motor + 10'd20;
            end
            3'b011: begin
                left_motor <= (left_motor> 10'd1003) ? 10'd1023 : left_motor + 10'd20;
                right_motor <= (right_motor > 10'd10) ? right_motor - 10'd10 : 0;
            end
            3'b001: begin
                left_motor <= (left_motor > 10'd1003) ? 10'd1023 : left_motor + 10'd20;
                right_motor <= (right_motor > 10'd100) ? right_motor - 10'd100 : 0;
            end
            3'b000: begin
                left_motor <= (left_motor > right_motor) ? 10'd1023 : 0;
                right_motor <= (left_motor > right_motor) ? 0 : 10'd1023;
            end
            default: begin
                left_motor <= 10'd1023;
                right_motor <= 10'd1023;
            end
            endcase
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

