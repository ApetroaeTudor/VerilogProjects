module Sync(
    input i_clk,
    input i_signal,
    output o_signal
);
    reg r_out_signal = 1'b0;
    reg r_intermediary_signal = 1'b0;

    assign o_signal = r_out_signal;


    always@(posedge i_clk)
    begin
        r_intermediary_signal<=i_signal;
        r_out_signal<=r_intermediary_signal;
    end

endmodule