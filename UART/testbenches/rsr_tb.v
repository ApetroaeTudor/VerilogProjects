module rsr_tb;
reg clk;
reg reset;
wire [6:0] d_o;

reg bit_tick;
reg sample_tick;
reg bit_tick_one_and_half;
reg receive_line;


reg data_read_ack;
wire data_ready;
wire frame_error;

rsr #(.DATA_SIZE(7),
      .OVERSAMPLE(16)) rsr_dut(.clk(clk),
                               .reset(reset),
                               .d_o(d_o),
                               .bit_tick(bit_tick),
                               .sample_tick(sample_tick),
                               .bit_tick_one_and_half(bit_tick_one_and_half),
                               .receive_line(receive_line),
                               .data_read_ack(data_read_ack),
                               .data_ready(data_ready),
                               .frame_error(frame_error));

always #5 clk = ~clk;
always #160 bit_tick = ~bit_tick;
always #10 sample_tick = ~sample_tick;
always #240 bit_tick_one_and_half = ~bit_tick_one_and_half;

always #30 receive_line=~receive_line;

initial
begin
    $dumpfile("waveform.vcd");
    $dumpvars(0,rsr_tb);

    clk=1'b0;
    reset=1'b1;
    bit_tick=1'b0;
    bit_tick_one_and_half=1'b0;
    sample_tick=1'b0;
    receive_line=1'b0;

    data_read_ack=1'b0;

    #10
    reset=1'b0;
    data_read_ack=1'b1;

    #10000
    $finish;
    
end

endmodule