module rdr_tb;

reg[6:0] d_i;
reg res;
reg clk;

wire data_read_ack;
reg data_ready;
reg frame_error;
wire [6:0] d_o;

always #5 clk = ~clk;

rdr #(.DATA_SIZE(7)) rdr_dut(.clk(clk),
                             .res(res),
                             .d_i(d_i),
                             .data_read_ack(data_read_ack),
                             .data_ready(data_ready),
                             .frame_error(frame_error),
                             .d_o(d_o));

initial 
begin
    $dumpfile("waveform.vcd");
    $dumpvars(0,rdr_tb);
    clk=1'b0;
    res=1'b1;
    data_ready=1'b0;
    frame_error=1'b0;
    d_i=7'b1010_111;

    #10
    res=1'b0;
    data_ready=1'b1;
    frame_error=1'b0;

    #20
    res=1'b1;

    #10
    res=1'b0;
    data_ready=1'b1;
    frame_error=1'b1;

    #10
    res=1'b1;

    #10
    data_ready=1'b0;
    frame_error=1'b0;

    #60
    $finish;
    

end


endmodule