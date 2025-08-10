module PC_Tb;
reg t_r_clk;
reg t_r_rst;
reg [31:0] t_r_next_pc;
wire [31:0] t_w_pc;

PC DUT(.i_clk(t_r_clk),
       .i_rst(t_r_rst),
       .i_next_pc(t_r_next_pc),
       .o_pc(t_w_pc));

always #5 t_r_clk = ~t_r_clk;

initial
begin
    $dumpfile("waveform.vcd");
    $dumpvars(0,PC_Tb);
    t_r_clk = 1'b0;
    t_r_rst = 1'b1;
    t_r_next_pc = 32'h64;
    
    #10
    t_r_rst=1'b0;
    repeat(4)
    begin
        $display("PC[%h] = %h",t_r_next_pc,DUT.o_pc);
        t_r_next_pc = t_r_next_pc+32'h4;
        #10;
    end


    #1000
    $finish;

end

endmodule