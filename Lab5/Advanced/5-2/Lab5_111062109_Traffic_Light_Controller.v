`timescale 1ns/1ps

module Traffic_Light_Controller (clk, rst_n, lr_has_car, hw_light, lr_light);
    input clk, rst_n;
    input lr_has_car;
    output [2:0] hw_light;
    output [2:0] lr_light;
    reg [2:0] hw_light, lr_light;
    parameter S0 = 3'd0, S1 = 3'd1, S2 = 3'd2, S3 = 3'd3, S4 = 3'd4, S5 = 3'd5;
    reg [2:0] current_state, next_state;
    reg [6:0] counter, next_counter;
    always @(posedge clk) begin
        if(!rst_n)begin
            current_state <= S0;
            counter <= 7'd0;
        end
        else begin
            current_state <= next_state;
            counter <= next_counter;
        end
    end

    always @(*) begin
        case(current_state) 
        S0: begin
            if(counter<69) begin
                next_state = S0;
                next_counter = counter + 1;
            end
            else begin
                if(lr_has_car)begin
                    next_state = S1;
                    next_counter = 7'd0;
                end
                else begin
                    next_state = S0;
                    next_counter = 7'd69;
                end
            end
        end
        S1: begin
            if(counter<24) begin
                next_state = S1;
                next_counter = counter + 1;
            end
            else begin
                next_state = S2;
                next_counter = 7'd0;
            end
        end
        S2: begin
            next_state = S3;
            next_counter = 7'd0;
        end
        S3: begin
            if(counter<69)begin
                next_state = S3;
                next_counter = counter + 1;
            end
            else begin
                next_state = S4;
                next_counter = 7'd0;
            end
        end
        S4: begin
            if(counter<24)begin
                next_state = S4;
                next_counter = counter + 1;
            end
            else begin
                next_state = S5;
                next_counter = 7'd0;
            end
        end
        S5: begin
            next_state = S0;
            next_counter = 7'd0;
        end
        endcase
    end

    always @(current_state) begin
        case (current_state)
        S0: begin
            hw_light = 3'b100;
            lr_light = 3'b001;
        end
        S1: begin
            hw_light = 3'b010;
            lr_light = 3'b001;
        end
        S2: begin
            hw_light = 3'b001;
            lr_light = 3'b001;
        end
        S3: begin
            hw_light = 3'b001;
            lr_light = 3'b100;
        end
        S4: begin
            hw_light = 3'b001;
            lr_light = 3'b010;
        end
        S5: begin
            hw_light = 3'b001;
            lr_light = 3'b001;
        end
        endcase
    end
endmodule