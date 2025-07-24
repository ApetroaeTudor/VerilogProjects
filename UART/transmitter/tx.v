module tx#(
    parameter DATA_SIZE = 7,
    parameter CLK_FREQ_HZ = 50_000_000,
    parameter BAUD_RATE = 9600,
    parameter OVERSAMPLE = 16
)(
    input clk,
    input reset,
    input pl,
    input[DATA_SIZE-1:0] d_i,
    output data_out,

    input bit_tick,
    input sample_tick,
    input bit_tick_one_and_half
);




wire tx_busy;
wire tx_start;
wire[DATA_SIZE-1:0] tdr_out;

tdr #(.DATA_SIZE(DATA_SIZE)) tdr_tx(.clk(clk),
                                    .pl(pl),
                                    .res(reset),
                                    .d_i(d_i),
                                    .tx_busy(tx_busy),
                                    .tx_start(tx_start),
                                    .d_o(tdr_out));

tsr #(.DATA_SIZE(DATA_SIZE)) tsr_tx(.clk(clk),
                                    .reset(reset),
                                    .d_i(tdr_out),
                                    .bit_tick(bit_tick),
                                    .tx_busy(tx_busy),
                                    .tx_start(tx_start),
                                    .data_out(data_out));




endmodule