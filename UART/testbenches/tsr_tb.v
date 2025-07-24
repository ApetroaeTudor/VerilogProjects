module tsr_tb;
reg clk;
reg reset;
reg[6:0] d_i;
reg bit_tick;
wire tx_busy;
reg tx_start;

wire data_out;


tsr #(.DATA_SIZE(7)) tsr_dut(.clk(clk),
                             .reset(reset),
                             .d_i(d_i),
                             .bit_tick(bit_tick),
                             .tx_busy(tx_busy),
                             .tx_start(tx_start),
                             .data_out(data_out));
always #5 clk=~clk;
always #16 bit_tick=~bit_tick;

initial
begin
    $dumpfile("waveform.vcd");
    $dumpvars(0,tsr_tb);
    clk=1'b0;
    reset=1'b1;
    d_i=7'b1111_101;
    bit_tick=1'b0;
    tx_start=1'b0;

    #10
    reset=1'b0;
    tx_start=1'b1;

    #1000
    $finish;

end


endmodule