module rx #(
    parameter DATA_SIZE = 7,
    parameter CLK_FREQ_HZ = 50_000_000,
    parameter BAUD_RATE = 9600,
    parameter OVERSAMPLE = 16
)(
    input clk,
    input reset,
    input receive_line,
    output[DATA_SIZE-1:0] data_out,

    input bit_tick,
    input sample_tick,
    input bit_tick_one_and_half
);

wire[DATA_SIZE-1:0] rst_out;
wire data_ready;
wire frame_error;

wire data_read_ack;

rsr #(.DATA_SIZE(DATA_SIZE),
      .OVERSAMPLE(OVERSAMPLE)) rsr_rx(.clk(clk),
                                      .reset(reset),
                                      .d_o(rst_out),
                                      .bit_tick(bit_tick),
                                      .sample_tick(sample_tick),
                                      .bit_tick_one_and_half(bit_tick_one_and_half),
                                      .receive_line(receive_line),
                                      .data_read_ack(data_read_ack),
                                      .data_ready(data_ready),
                                      .frame_error(frame_error));

rdr #(.DATA_SIZE(DATA_SIZE)) rdr_rx(.clk(clk),
                                    .res(reset),
                                    .d_i(rst_out),
                                    .data_read_ack(data_read_ack),
                                    .data_ready(data_ready),
                                    .frame_error(frame_error),
                                    .d_o(data_out));

endmodule