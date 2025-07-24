module tx_tb;

reg clk;
reg reset;
reg pl;
reg [6:0] d_i;
reg bit_tick;
reg sample_tick;
reg bit_tick_one_and_half;

wire data_out;

always #5 clk=~clk;
always #16 bit_tick=~bit_tick;
always #10 sample_tick=~sample_tick;
always #240 bit_tick_one_and_half=~bit_tick_one_and_half;


tx #(.DATA_SIZE(7),
     .CLK_FREQ_HZ(50_000_000),
     .BAUD_RATE(9600),
     .OVERSAMPLE(16)) tx_dut(.clk(clk),
                             .reset(reset),
                             .pl(pl),
                             .d_i(d_i),
                             .data_out(data_out),
                             .bit_tick(bit_tick),
                             .sample_tick(sample_tick),
                             .bit_tick_one_and_half(bit_tick_one_and_half));

initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0,tx_tb);

    clk= 1'b0;
    reset=1'b1;
    pl=1'b0;
    d_i=7'b1010_111;
    bit_tick=1'b0;
    sample_tick=1'b0;
    bit_tick_one_and_half=1'b0;

    #10
    reset=1'b0;
    pl=1'b1;

    #1000
    $finish;

end

endmodule