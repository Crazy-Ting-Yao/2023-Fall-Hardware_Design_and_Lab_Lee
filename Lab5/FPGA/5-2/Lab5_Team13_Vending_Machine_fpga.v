module TOP(
    output wire [6:0] segs,
    output wire [3:0] AN,
    output wire [3:0] LED,
    inout wire PS2_DATA,
    inout wire PS2_CLK,
    input wire clk,
    input wire up_btn, down_btn, left_btn, right_btn, center_btn
    );
    parameter UP = 0, DOWN = 1, LEFT = 2, RIGHT = 3, CENTER = 4;
    parameter [8:0] KEY_CODES_A = {1'b0,8'h1C}; // A => 1C
    parameter [8:0] KEY_CODES_S = {1'b0,8'h1B}; // S => 1B
    parameter [8:0] KEY_CODES_D = {1'b0,8'h23}; // D => 23
    parameter [8:0] KEY_CODES_F = {1'b0,8'h2B}; // F => 2B
    wire [511:0] key_down;
    reg de_buttons [4:0], buttons [4:0];
    reg [6:0] total_money;
    reg count_down, next_count_down;
    wire btn_a_op, btn_s_op, btn_d_op, btn_f_op;
    reg [3:0] available_drinks;
    wire one_sec_clk;
    wire start_to_count_down;
    one_sec_clock osc (.clk(clk),.rst(start_to_count_down),.one_sec(one_sec_clk));
    KeyboardDecoder inst (
        .key_down(key_down),
        .last_change(last_change),
        .key_valid(key_valid),
        .PS2_DATA(PS2_DATA),
        .PS2_CLK(PS2_CLK),
        .rst(buttons[UP]),
        .clk(clk)
    );
    
    debounce db_up (clk, up_btn, de_buttons[UP]);
    debounce db_down (clk, down_btn, de_buttons[DOWN]);
    debounce db_left (clk, left_btn, de_buttons[LEFT]);
    debounce db_right (clk, right_btn, de_buttons[RIGHT]);
    debounce db_center (clk, center_btn, de_buttons[CENTER]);
    
    OnePulse op_up (buttons[UP], de_buttons[UP], clk);
    OnePulse op_down(buttons[DOWN], de_buttons[DOWN], clk);
    OnePulse op_left(buttons[LEFT], de_buttons[LEFT], clk);
    OnePulse op_right(buttons[RIGHT], de_buttons[RIGHT], clk);
    OnePulse op_center(buttons[CENTER], de_buttons[CENTER], clk);
    OnePulse op_a (btn_a_op, key_down[KEY_CODE_A], clk);
    OnePulse op_s (btn_s_op, key_down[KEY_CODE_S], clk);
    OnePulse op_d (btn_d_op, key_down[KEY_CODE_D], clk);
    OnePulse op_f (btn_f_op, key_down[KEY_CODE_F], clk);

    always @(posedge clk) begin
        if(buttons[UP]) begin
            total_money = 0;
            count_down = 0;
            start_to_count_down = 0;
        end
        else if(count_down) begin
            start_to_count_down = 0;
            if(one_sec_clk) begin
                total_money <= total_money - 5;
                count_down <= (total_money<6) ? 1 : 0;
            end
            else begin
                total_money <= total_money;
                count_down <= count_down;
            end
        end
        else if(buttons[DOWN]) begin
            if(total_money) begin
                start_to_count_down = 1;
                count_down = 1;
            end
            else begin
                start_to_count_down = 0;
                count_down = 0;
            end
        end
        else if(buttons[LEFT]) begin
            total_money = (total_money + 5 > 100) ? 100 : total_money + 5;
            start_to_count_down = 0;
        end
        else if(buttons[CENTER]) begin
            total_money = (total_money + 10 > 100) ? 100 : total_money + 10;
            start_to_count_down = 0;
        end
        else if(buttons[RIGHT]) begin
            total_money = (total_money + 50 > 100) ? 100 : total_money + 50;
            start_to_count_down = 0;
        end
        else if(btn_a_op) begin
            if(available_drinks[3]) begin
                total_money <= total_money - 80;
                count_down <= 1;
                start_to_count_down <= 1;
            end
            else begin
                total_money <= total_money;
                count_down <= 0;
                start_to_count_down <= 0;
            end
        end
        else if(btn_s_op) begin
            if(available_drinks[2]) begin
                total_money <= total_money - 30;
                count_down <= 1;
                start_to_count_down <= 1;
            end
            else begin
                total_money <= total_money;
                count_down <= 0;
                start_to_count_down <= 0;
            end
        end
        else if(btn_d_op) begin
            if(available_drinks[1]) begin
                total_money <= total_money - 25;
                count_down <= 1;
                start_to_count_down <= 1;
            end
            else begin
                total_money <= total_money;
                count_down <= 0;
                start_to_count_down <= 0;
            end
        end
        else if(btn_f_op) begin
            if(available_drinks[0]) begin
                total_money <= total_money - 20;
                count_down <= 1;
                start_to_count_down <= 1;
            end
            else begin
                total_money <= total_money;
                count_down <= 0;
                start_to_count_down <= 0;
            end
        end
        else begin
            total_money <= total_money;
            count_down <= 0;
            start_to_count_down <= 0;
        end
    end

    always @(*) begin
        if(total_money >= 80) available_drinks[3] = 1'b1;
        else available_drinks[3] = 1'b0;
        if(total_money >= 30) available_drinks[2] = 1'b1;
        else available_drinks[2] = 1'b0;
        if(total_money >= 25) available_drinks[1] = 1'b1;
        else available_drinks[1] = 1'b0;
        if(total_money >= 20) available_drinks[0] = 1'b1;
        else available_drinks[0] = 1'b0;
    end
    
    assign LED = count_down ? 4'b0000 : available_drinks;

endmodule

module KeyboardDecoder(
    output reg [511:0] key_down,
    output wire [8:0] last_change,
    output reg key_valid,
    inout wire PS2_DATA,
    inout wire PS2_CLK,
    input wire rst,
    input wire clk
    );
    
    parameter [1:0] INIT			= 2'b00;
    parameter [1:0] WAIT_FOR_SIGNAL = 2'b01;
    parameter [1:0] GET_SIGNAL_DOWN = 2'b10;
    parameter [1:0] WAIT_RELEASE    = 2'b11;
    
    parameter [7:0] IS_INIT			= 8'hAA;
    parameter [7:0] IS_EXTEND		= 8'hE0;
    parameter [7:0] IS_BREAK		= 8'hF0;
    
    reg [9:0] key, next_key;		// key = {been_extend, been_break, key_in}
    reg [1:0] state, next_state;
    reg been_ready, been_extend, been_break;
    reg next_been_ready, next_been_extend, next_been_break;
    
    wire [7:0] key_in;
    wire is_extend;
    wire is_break;
    wire valid;
    wire err;
    
    wire [511:0] key_decode = 1 << last_change;
    assign last_change = {key[9], key[7:0]};
    
    KeyboardCtrl_0 inst (
        .key_in(key_in),
        .is_extend(is_extend),
        .is_break(is_break),
        .valid(valid),
        .err(err),
        .PS2_DATA(PS2_DATA),
        .PS2_CLK(PS2_CLK),
        .rst(rst),
        .clk(clk)
    );
    
    OnePulse op (
        .signal_single_pulse(pulse_been_ready),
        .signal(been_ready),
        .clock(clk)
    );
    
    always @ (posedge clk, posedge rst) begin
        if (rst) begin
            state <= INIT;
            been_ready  <= 1'b0;
            been_extend <= 1'b0;
            been_break  <= 1'b0;
            key <= 10'b0_0_0000_0000;
        end else begin
            state <= next_state;
            been_ready  <= next_been_ready;
            been_extend <= next_been_extend;
            been_break  <= next_been_break;
            key <= next_key;
        end
    end
    
    always @ (*) begin
        case (state)
            INIT:            next_state = (key_in == IS_INIT) ? WAIT_FOR_SIGNAL : INIT;
            WAIT_FOR_SIGNAL: next_state = (valid == 1'b0) ? WAIT_FOR_SIGNAL : GET_SIGNAL_DOWN;
            GET_SIGNAL_DOWN: next_state = WAIT_RELEASE;
            WAIT_RELEASE:    next_state = (valid == 1'b1) ? WAIT_RELEASE : WAIT_FOR_SIGNAL;
            default:         next_state = INIT;
        endcase
    end
    always @ (*) begin
        next_been_ready = been_ready;
        case (state)
            INIT:            next_been_ready = (key_in == IS_INIT) ? 1'b0 : next_been_ready;
            WAIT_FOR_SIGNAL: next_been_ready = (valid == 1'b0) ? 1'b0 : next_been_ready;
            GET_SIGNAL_DOWN: next_been_ready = 1'b1;
            WAIT_RELEASE:    next_been_ready = next_been_ready;
            default:         next_been_ready = 1'b0;
        endcase
    end
    always @ (*) begin
        next_been_extend = (is_extend) ? 1'b1 : been_extend;
        case (state)
            INIT:            next_been_extend = (key_in == IS_INIT) ? 1'b0 : next_been_extend;
            WAIT_FOR_SIGNAL: next_been_extend = next_been_extend;
            GET_SIGNAL_DOWN: next_been_extend = next_been_extend;
            WAIT_RELEASE:    next_been_extend = (valid == 1'b1) ? next_been_extend : 1'b0;
            default:         next_been_extend = 1'b0;
        endcase
    end
    always @ (*) begin
        next_been_break = (is_break) ? 1'b1 : been_break;
        case (state)
            INIT:            next_been_break = (key_in == IS_INIT) ? 1'b0 : next_been_break;
            WAIT_FOR_SIGNAL: next_been_break = next_been_break;
            GET_SIGNAL_DOWN: next_been_break = next_been_break;
            WAIT_RELEASE:    next_been_break = (valid == 1'b1) ? next_been_break : 1'b0;
            default:         next_been_break = 1'b0;
        endcase
    end
    always @ (*) begin
        next_key = key;
        case (state)
            INIT:            next_key = (key_in == IS_INIT) ? 10'b0_0_0000_0000 : next_key;
            WAIT_FOR_SIGNAL: next_key = next_key;
            GET_SIGNAL_DOWN: next_key = {been_extend, been_break, key_in};
            WAIT_RELEASE:    next_key = next_key;
            default:         next_key = 10'b0_0_0000_0000;
        endcase
    end

    always @ (posedge clk, posedge rst) begin
        if (rst) begin
            key_valid <= 1'b0;
            key_down <= 511'b0;
        end else if (key_decode[last_change] && pulse_been_ready) begin
            key_valid <= 1'b1;
            if (key[8] == 0) begin
                key_down <= key_down | key_decode;
            end else begin
                key_down <= key_down & (~key_decode);
            end
        end else begin
            key_valid <= 1'b0;
            key_down <= key_down;
        end
    end
endmodule

module OnePulse (
    output reg signal_single_pulse,
    input wire signal,
    input wire clock
    );
    
    reg signal_delay;

    always @(posedge clock) begin
        if (signal == 1'b1 & signal_delay == 1'b0)
            signal_single_pulse <= 1'b1;
        else
            signal_single_pulse <= 1'b0;
        signal_delay <= signal;
    end
endmodule

module debounce(clk, in, out);
    input in, clk;
    output out;
    reg [7:0] count;
    reg out;
    always @(posedge clk) begin
        if(!rst_n) count <= 0;
        else count = {count[6:0], in};
    end
    assign out = (~count == 8'd0);
endmodule

module sevenseg_display(clk, rst, money, AN, seg);
    input clk, rst;
    input [6:0] money;
    output reg [3:0] AN;
    output reg [6:0] seg;
    
    reg [18:0] counter;

    always @(posedge clk) begin
        if (rst)  counter <= 0;
        else  counter <= counter + 1;
    end
    reg [3:0] digit1, digit2;
    reg digit3;
    reg [6:0] seg1, seg2;
    sevenseg_decoder inst1 (digit1, seg1);
    sevenseg_decoder inst2 (digit2, seg2);
    always @(*) begin
        if(money==100) begin
            digit1 = 0;
            digit2 = 0;
            digit3 = 1;
        end
        else if(money>89) begin
            digit1 = money-90;
            digit2 = 9;
            digit3 = 0;
        end
        else if(money>79) begin
            digit1 = money-80;
            digit2 = 8;
            digit3 = 0;
        end
        else if(money>69) begin
            digit1 = money-70;
            digit2 = 7;
            digit3 = 0;
        end
        else if(money>59) begin
            digit1 = money-60;
            digit2 = 6;
            digit3 = 0;
        end
        else if(money>49) begin
            digit1 = money-50;
            digit2 = 5;
            digit3 = 0;
        end
        else if(money>39) begin
            digit1 = money-40;
            digit2 = 4;
            digit3 = 0;
        end
        else if(money>29) begin
            digit1 = money-30;
            digit2 = 3;
            digit3 = 0;
        end
        else if(money>19) begin
            digit1 = money-20;
            digit2 = 2;
            digit3 = 0;
        end
        else if(money>9) begin
            digit1 = money-10;
            digit2 = 1;
            digit3 = 0;
        end
        else begin
            digit1 = money;
            digit2 = 0;
            digit3 = 0;
        end
    end
    always @(*) begin
        case(counter[18:17])
        2'b00: begin
            AN <= 4'b1110;
            seg <= seg1;
        end
        2'b01: begin
            AN <= 4'b1101;
            if(money>9) seg <= seg2;
            else seg <= 7'b1111111;
        end
        2'b10: begin
            AN <= 4'b1011;
            if(digit3) seg <= 7'b1111001;
            else seg <= 7'b1111111;
        end
        default: begin
            AN <= 4'b0111;
            seg <= 7'b1111111;
        end
        endcase
    end

endmodule

module sevenseg_decoder(in, segs);
    input [3:0] in;
    output reg [6:0] segs;
    always @(*) begin
        case(in)
        4'b0000: segs = 7'b1000000;
        4'b0001: segs = 7'b1111001;
        4'b0010: segs = 7'b0100100;
        4'b0011: segs = 7'b0110000;
        4'b0100: segs = 7'b0011001;
        4'b0101: segs = 7'b0010010;
        4'b0110: segs = 7'b0000010;
        4'b0111: segs = 7'b1111000;
        4'b1000: segs = 7'b0000000;
        4'b1001: segs = 7'b0010000;
        default: segs = 7'b1111111;
        endcase
    end
endmodule

module one_sec_clock(clk, rst, one_sec);
    input clk, rst;
    output reg one_sec;
    reg [26:0] counter;

    always @(posedge clk) begin
        if (rst) begin
            counter <= 0; 
            one_sec <= 0;
        end
        else if(counter == 27'd100000000 - 1) begin
            counter <= 0;
            one_sec <= 1;
        end
        else begin
            counter <= counter + 1;
            one_sec <= 0;
        end
    end
endmodule