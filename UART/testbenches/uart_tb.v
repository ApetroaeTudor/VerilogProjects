module uart_tb;
reg clk;
reg reset;
wire tx_line;
reg TX_START;

reg[6:0] data_in;
wire[6:0] data_out;

always #5 clk=~clk;

UART #(.DATA_SIZE(7),
       .CLK_FREQ_HZ(50_000_000),
       .BAUD_RATE(960000),
       .OVERSAMPLE(16)) UART_DUT(.clk(clk),
                                 .reset(reset),
                                 .tx_line(tx_line),
                                 .rx_line(tx_line),
                                 .TX_START(TX_START),
                                 .data_in(data_in),
                                 .data_out(data_out));

initial
begin
    $dumpfile("waveform.vcd");
    $dumpvars(0,uart_tb);
    clk=1'b0;
    reset=1'b1;
    TX_START=1'b0;
    #10
    $display("Value of localparam = %d",((50_000_000+9600/2)/9600) );
    reset=1'b0;
    TX_START=1'b1;
    data_in=7'b1010_111;
    #10
    TX_START=1'b0;
    #20000
    $finish;

end

endmodule