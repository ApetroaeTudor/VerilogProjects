module Reg_File_Tb;
reg t_r_clk;
reg t_r_rst;
reg t_r_reg_write;

reg [4:0] t_r_rd_addr_1;
reg [4:0] t_r_rd_addr_2;
reg [4:0] t_r_wr_addr;

reg [31:0] t_r_wr_data;

wire [31:0] t_w_rd_data_1;
wire [31:0] t_w_rd_data_2;

always #5 t_r_clk = ~t_r_clk;

Reg_File DUT(.i_clk(t_r_clk),
             .i_rst(t_r_rst),
             .i_reg_write(t_r_reg_write),
             .i_rd_addr_1(t_r_rd_addr_1),
             .i_rd_addr_2(t_r_rd_addr_2),
             .i_wr_addr(t_r_wr_addr),
             .i_wr_data(t_r_wr_data),
             .o_rd_data_1(t_w_rd_data_1),
             .o_rd_data_2(t_w_rd_data_2));

integer i;
initial
begin
    $dumpfile("waveform.vcd");
    $dumpvars(0,Reg_File_Tb);
    t_r_clk = 1'b0;
    t_r_rst = 1'b1;

    #10
    t_r_rst = 1'b0;
    t_r_wr_addr = 32'd7;
    t_r_wr_data = 32'hfefe_efef;
    t_r_reg_write = 1'b1;

    #10
    t_r_reg_write = 1'b0;
    for(i=0;i<32;i=i+1)
    begin
        $display("Regs[%0d] = %h", i,DUT.r_registers[i]);
    end

    #1000
    $finish;

end


endmodule