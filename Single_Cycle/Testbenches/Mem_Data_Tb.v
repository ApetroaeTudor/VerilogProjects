module Mem_Data_Tb;
reg t_r_clk;
reg t_r_rst;
reg t_r_mem_write;

reg [31:0] t_r_mem_addr;
reg [31:0] t_r_mem_data;


wire [31:0] t_w_mem_data;


Mem_Data DUT(.i_clk(t_r_clk),
             .i_rst(t_r_rst),
             .i_mem_write(t_r_mem_write),
             .i_mem_addr(t_r_mem_addr),
             .i_mem_data(t_r_mem_data),
             .o_mem_data(t_w_mem_data));

always #5 t_r_clk = ~t_r_clk;

integer i;


initial
begin
    $dumpfile("waveform.vcd");
    $dumpvars(0,Mem_Data_Tb);
    t_r_clk = 1'b0;
    t_r_rst=1'b1;

    #10
    t_r_rst=1'b0;

    for(i = 0; i < 116; i = i + 1)
    begin
        $display("Mem[%h] = %h ", i,DUT.r_mem_data[i]);
    end
    $display("\n\n\n\n");

    #10
    t_r_mem_write = 1'b1;
    t_r_mem_addr = 32'd8;
    t_r_mem_data = 32'hfefe_efef;

    #10

    for(i = 8; i < 13; i = i+ 1)
    begin
        $display("Mem[%h] = %h ", i,DUT.r_mem_data[i]);
    end

    #1000
    $finish;
end

endmodule