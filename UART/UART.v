module UART #(
    parameter DATA_SIZE = 7,
    parameter CLK_FREQ_HZ = 50_000_000,
    parameter BAUD_RATE = 9600,
    parameter OVERSAMPLE = 16
)(
    input clk,
    input reset,
    output tx_line,
    input rx_line,
    input TX_START,

    input[DATA_SIZE-1:0] data_in,
    output[DATA_SIZE-1:0] data_out
);

wire bit_tick;
wire sample_tick;
wire bit_tick_one_and_half;

br_gen #(.CLK_FREQ_HZ(CLK_FREQ_HZ),
        .BAUD_RATE(BAUD_RATE),
        .OVERSAMPLE(OVERSAMPLE)) br_gen_inst(.clk(clk),
                                           .reset(reset),
                                           .bit_tick(bit_tick),
                                           .sample_tick(sample_tick),
                                           .bit_tick_one_and_half(bit_tick_one_and_half));

rx #(.DATA_SIZE(DATA_SIZE),
     .CLK_FREQ_HZ(CLK_FREQ_HZ),
     .BAUD_RATE(BAUD_RATE),
     .OVERSAMPLE(OVERSAMPLE)) rx_inst(.clk(clk),
                                      .reset(reset),
                                      .receive_line(rx_line),
                                      .data_out(data_out),
                                      .bit_tick(bit_tick),
                                      .sample_tick(sample_tick),
                                      .bit_tick_one_and_half(bit_tick_one_and_half));

tx #(.DATA_SIZE(DATA_SIZE),
     .CLK_FREQ_HZ(CLK_FREQ_HZ),
     .BAUD_RATE(BAUD_RATE),
     .OVERSAMPLE(OVERSAMPLE)) tx_inst(.clk(clk),
                                      .reset(reset),
                                      .pl(TX_START),
                                      .d_i(data_in),
                                      .data_out(tx_line),
                                      .bit_tick(bit_tick),
                                      .sample_tick(sample_tick),
                                      .bit_tick_one_and_half(bit_tick_one_and_half));




endmodule