module Control_Unit_Tb;
reg [6:0] t_r_opcode;

wire [1:0] t_w_res_src;
wire t_w_j;
wire t_w_b;
wire [1:0] t_w_alu_ctl;
wire t_w_reg_wr;
wire t_w_mem_wr;
wire [1:0] t_w_imm_ctl;
wire t_w_alu_src_b;

Control_Unit DUT(.i_opcode(t_r_opcode),
                 .o_res_src(t_w_res_src),
                 .o_j(t_w_j),
                 .o_b(t_w_b),
                 .o_alu_ctl(t_w_alu_ctl),
                 .o_reg_wr(t_w_reg_wr),
                 .o_mem_wr(t_w_mem_wr),
                 .o_imm_ctl(t_w_imm_ctl),
                 .o_alu_src_b(t_w_alu_src_b));

initial
begin
    $dumpfile("waveform.vcd");
    $dumpvars(0,Control_Unit_Tb);
    t_r_opcode = 7'b011_0011;
    #10
    t_r_opcode = 7'b001_0011;
    #10
    t_r_opcode = 7'b000_0011;
    #10
    t_r_opcode = 7'b010_0011;
    #10
    t_r_opcode = 7'b110_0011;
    #10
    t_r_opcode = 7'b110_1111;
    #100
    $finish;
end

endmodule