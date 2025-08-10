module Control_Path(
    input [6:0] i_opcode,
    input [2:0] i_f3,
    input i_zero,
    input i_f7_bit6,

    output [1:0] o_res_src,

    output [1:0] o_pc_src,
    // 00 - PC+4 - normal
    // 01 - PC+Imm - jal / branch
    // 10 - Rs1+Imm - jalr


    output [2:0] o_alu_op,
    output o_reg_wr,
    output o_mem_wr,
    output [1:0] o_imm_ctl,
    output o_alu_src_b

);

wire w_j;
wire w_b;
wire [1:0] w_alu_ctl;

Control_Unit Control_Unit_Inst(.i_opcode(i_opcode),
                               .o_res_src(o_res_src),
                               .o_j(w_j),
                               .o_b(w_b),
                               .o_alu_ctl(w_alu_ctl),
                               .o_reg_wr(o_reg_wr),
                               .o_mem_wr(o_mem_wr),
                               .o_imm_ctl(o_imm_ctl),
                               .o_alu_src_b(o_alu_src_b));


ALU_Control ALU_Control_Inst(.i_alu_ctl(w_alu_ctl),
                             .i_f3(i_f3),
                             .i_f7_bit6(i_f7_bit6),
                             .o_alu_op(o_alu_op));


assign o_pc_src = (w_b && i_zero || (w_j && i_opcode==7'b110_1111))?2'b01: //  branch taken OR jal 
                  (w_j && i_opcode == 7'b110_0111)?2'b10: // jalr
                  2'b00; // pc+4, next instr 


endmodule