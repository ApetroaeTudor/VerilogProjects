module Single_Cycle_Tb;
reg t_r_enable_btn;
reg t_r_clk;
reg t_r_rst_n;

wire [31:0] t_w_mem_location_32h;

always #5 t_r_clk = ~t_r_clk;

Single_Cycle DUT(.i_enable_btn_d_s_o(t_r_enable_btn),
                 .i_clk(t_r_clk),
                 .i_rst_n(t_r_rst_n),
                 .o_mem_location_32h(t_w_mem_location_32h));

integer i;

initial
begin
    $dumpfile("waveform.vcd");
    $dumpvars(0,Single_Cycle_Tb);
    t_r_clk=1'b0;
    t_r_rst_n=1'b1;

    $monitor("Time=%0t | Mem=%h %h %h %h %h",
         $time,
         DUT.Data_Path_Inst.Mem_Data_Inst.r_mem_data[50],
         DUT.Data_Path_Inst.Mem_Data_Inst.r_mem_data[51],
         DUT.Data_Path_Inst.Mem_Data_Inst.r_mem_data[52],
         DUT.Data_Path_Inst.Mem_Data_Inst.r_mem_data[53]
);

    #10
    t_r_enable_btn=1'b1;
    
    #10
    t_r_enable_btn=1'b0;
    #100000
    $finish;
end
endmodule