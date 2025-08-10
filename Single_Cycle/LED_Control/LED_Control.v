module LED_Control(
    input i_clk,
    input i_rst_n,
    input [31:0] i_mem_link,

    output o_led_signal
);

    reg r_led_signal;
    assign o_led_signal = r_led_signal;

    always@(posedge i_clk)
    begin
        if(!i_rst_n)
        begin
            r_led_signal<=1'b0; // 1 is ON
        end
        else
        begin
            if(i_mem_link==32'd16_875_000) // approx 5 secs
            begin
                r_led_signal<=1'b1;
            end
            // the mem location is incremented every 8 clock cycles, at a frequency of 27MHZ
        end
    end

endmodule