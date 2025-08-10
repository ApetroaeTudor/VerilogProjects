module Debounce(
    input i_clk,
    input i_btn,
    output reg o_btn
);

    // 10ms at 27MHz requires 270,000 cycles
    // Need 18-bit counter (2^18 = 262144)
    parameter DEBOUNCE_LIMIT = 18'd270000;
    
    reg [17:0] r_debounce_counter = 0;
    reg r_btn_intermediary = 0;

    always@(posedge i_clk)
    begin
        if (i_btn != r_btn_intermediary) begin
            r_debounce_counter <= 0;
            r_btn_intermediary <= i_btn;
        end
        else if (r_debounce_counter < DEBOUNCE_LIMIT) begin
            
            r_debounce_counter <= r_debounce_counter + 1;
        end
        else begin

            o_btn <= r_btn_intermediary;
        end
    end
endmodule