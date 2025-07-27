module tb;

localparam WIDTH = 8;
localparam DEPTH = 16;
localparam ALMOST_FLAG_PERCENTAGE = 20;
localparam CLK_PERIOD = 10; 

reg r_clk;
reg r_rst;
reg r_rd_en;
wire [WIDTH-1:0] w_rd_data;
wire w_rd_valid;

wire [$clog2(DEPTH)-1:0] w_count;

reg r_wr_en;
reg [WIDTH-1:0] r_wr_data;
wire w_wr_valid;

wire w_f_flag;
wire w_e_flag;
wire w_af_flag;
wire w_ae_flag;


reg r_assertion;
assert a0(.clk(r_clk),
          .test(r_assertion));

FIFO #(.WIDTH(WIDTH),
       .DEPTH(DEPTH),
       .ALMOST_FLAG_PERCENTAGE(ALMOST_FLAG_PERCENTAGE)) FIFO_DUT(.i_clk(r_clk),
                                                                 .i_rst(r_rst),
                                                                 .i_rd_en(r_rd_en),
                                                                 .o_rd_data(w_rd_data),
                                                                 .o_rd_valid(w_rd_valid),
                                                                 .i_wr_en(r_wr_en),
                                                                 .i_wr_data(r_wr_data),
                                                                 .o_wr_valid(w_wr_valid),
                                                                 .o_e_flag(w_e_flag),
                                                                 .o_f_flag(w_f_flag),
                                                                 .o_af_flag(w_af_flag),
                                                                 .o_ae_flag(w_ae_flag),
                                                                 .o_count(w_count));
always #(CLK_PERIOD/2) r_clk = ~r_clk;

initial
begin
    $dumpfile("waveform.vcd");
    $dumpvars(0,tb);
    r_clk=1'b0;
    r_rst=1'b1;
    r_assertion=1;
    r_rd_en=0;
    r_wr_en=0;
    r_wr_data=0;

    #CLK_PERIOD
    r_rst=1'b0;
    r_wr_data = 1;
    r_wr_en=1'b1;
    
    #CLK_PERIOD
    r_wr_en=1'b0;
    r_assertion = (w_count==1)?1:0;

    #CLK_PERIOD
    r_rd_en=1'b1;

    #CLK_PERIOD
    r_rd_en=1'b0;
    r_assertion = (w_count==0)?1:0;

    #CLK_PERIOD
    r_rd_en=1'b1;

    #CLK_PERIOD
    r_rd_en=1'b0;
    r_assertion = (w_count==0)?1:0;

    repeat(20)
    begin
        r_wr_en=1'b1;
        $display("Count is %d",w_count);
        #CLK_PERIOD;
        // $display("Wr addr is %d", FIFO_DUT.r_wr_addr);
        // $display("Almost full flag is %d", w_af_flag);
        // $display("Almost empty flag is %d", w_ae_flag);
    end

    r_assertion = (w_count== (DEPTH-1))?1:0;
    r_wr_en=1'b0;
    $display("\n");

    repeat(20)
    begin
        r_rd_en=1'b1;
        $display("Count is %d",w_count);
        #CLK_PERIOD;
        // $display("Rd addr is %d", FIFO_DUT.r_rd_addr);
        // $display("Almost full flag is %d", w_af_flag);
        // $display("Almost empty flag is %d", w_ae_flag);

    end
    
    r_assertion = (w_count == 0)?1:0;
    r_rd_en=1'b0;


    $display("\n\n");
    #CLK_PERIOD
    r_rst=1'b1;
    #CLK_PERIOD
    r_rst=1'b0;

    #CLK_PERIOD
    r_wr_en=1'b1;
    $display("Write addr is %d",FIFO_DUT.r_wr_addr);
    $display("Data written is %d",r_wr_data);
    $display("Count is %d\n",w_count);

    #CLK_PERIOD
    r_wr_data=2;
    $display("Write addr is %d",FIFO_DUT.r_wr_addr);
    $display("Data written is %d",r_wr_data);
    $display("Count is %d\n",w_count);

    #CLK_PERIOD
    r_wr_en=1'b0;
    $display("Count is %d\n",w_count);

    #CLK_PERIOD
    r_rd_en=1'b1;
    $display("Read addr is %d",FIFO_DUT.r_rd_addr);
    $display("Data read is %d", w_rd_data);
    $display("Count is %d\n",w_count);

    #CLK_PERIOD
    $display("Read addr is %d",FIFO_DUT.r_rd_addr);
    $display("Data read is %d", w_rd_data);
    $display("Count is %d\n",w_count);

    #CLK_PERIOD
    $display("Read addr is %d",FIFO_DUT.r_rd_addr);
    $display("Data read is %d", w_rd_data);
    $display("Count is %d\n",w_count);

    #CLK_PERIOD
    r_rd_en=1'b0;

    r_assertion = (w_count==0)?1:0;

    $display("\n%d %d %d", FIFO_DUT.mem[0], FIFO_DUT.mem[1], FIFO_DUT.mem[2]);


    



   

    #(CLK_PERIOD*100)
    $finish;
end



endmodule