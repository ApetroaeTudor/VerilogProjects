module uart_double_tb;

localparam DATA_SIZE = 7;
localparam CLK_FREQ_HZ = 50_000_000;
localparam BAUD_RATE = 960000;
localparam OVERSAMPLE = 16;

reg clk;
reg reset;
reg[DATA_SIZE-1:0] d_i;
wire[DATA_SIZE-1:0] d_o;

wire line;
reg start_signal;

UART #(.DATA_SIZE(DATA_SIZE),
       .CLK_FREQ_HZ(CLK_FREQ_HZ),
       .BAUD_RATE(BAUD_RATE),
       .OVERSAMPLE(OVERSAMPLE)) UART_SENDER(.clk(clk),
                                            .reset(reset),
                                            .tx_line(line),
                                            .rx_line(1'b0),
                                            .TX_START(start_signal),
                                            .data_in(d_i),
                                            .data_out());

UART #(.DATA_SIZE(DATA_SIZE),
       .CLK_FREQ_HZ(CLK_FREQ_HZ),
       .BAUD_RATE(BAUD_RATE),
       .OVERSAMPLE(OVERSAMPLE)) UART_RECEIVER(.clk(clk),
                                              .reset(reset),
                                              .tx_line(),
                                              .rx_line(line),
                                              .TX_START(1'b0),
                                              .data_in({DATA_SIZE{1'b0}}),
                                              .data_out(d_o));


always #5 clk = ~clk;

initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0,uart_double_tb);
    reset=1'b1;
    clk=1'b0;

    #10
    start_signal=1'b1;
    reset=1'b0;
    d_i=7'b1010_111;

    #20000
    $finish;

end


endmodule