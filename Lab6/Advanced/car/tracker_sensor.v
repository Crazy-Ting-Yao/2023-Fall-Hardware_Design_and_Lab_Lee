`timescale 1ns/1ps

module tracker_sensor(clk, reset, left_signal, right_signal, mid_signal, target, state);
    input clk;
    input reset;
    input left_signal, right_signal, mid_signal;
    input target; // 0: white, 1: black
    output reg [1:0] state;

    parameter [1:0] stop               = 2'b00;
    parameter [1:0] turn_left          = 2'b10;
    parameter [1:0] turn_right         = 2'b01;
    parameter [1:0] go_straight        = 2'b11;

    wire sig_left, sig_right, sig_mid;
    assign sig_left  = left_signal  ^ target;
    assign sig_right = right_signal ^ target;
    assign sig_mid   = mid_signal   ^ target;

    // [TO-DO] Receive three signals and make your own policy.
    // Hint: You can use output state to change your action.
    reg [1:0] next_state;
    reg [26:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            state <= stop;
        end else begin
            if (counter == 8'd0) begin
                if (next_state == turn_left || next_state == turn_right)
                    counter <= 27'd40000000;
                else
                    counter <= 27'd0;
            end else begin
                counter <= counter - 1;
            end
            state <= (counter == 27'd0) ? next_state : state;
        end
    end

    always @(*) begin
        case ({sig_left, sig_mid, sig_right})
            3'b000: next_state <= stop;
            3'b001: next_state <= turn_right;
            3'b010: next_state <= go_straight;
            3'b011: next_state <= turn_right;
            3'b100: next_state <= turn_left;
            3'b101: next_state <= go_straight;
            3'b110: next_state <= turn_left;
            3'b111: next_state <= go_straight;
            default: next_state <= stop;
        endcase
    end
endmodule
