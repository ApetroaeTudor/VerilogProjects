`include "Constants.vh"
module Exception_Signals_Handler(
    input [31:0] i_pc_f,
    input [6:0] i_opcode_f,

    input [1:0] i_res_src_e,
    input i_reg_write_e,
    input [4:0] i_rd_e,
    input [31:0] i_alu_out_e,
    input i_mem_write_e,

    input i_reset_permission,
    input i_trap_permission,



    output [3:0] o_exception_code_f, 
    output [3:0] o_exception_code_e
);

wire w_pc_f_b20;
assign w_pc_f_b20 = i_pc_f[20];

wire w_pc_f_b19;
assign w_pc_f_b19 = i_pc_f[19];

wire w_pc_f_b18;
assign w_pc_f_b18 = i_pc_f[18];

wire w_tv_en = !i_pc_f[20] && !i_pc_f[19] && !i_pc_f[18];
wire w_rv_en = !i_pc_f[20] && !i_pc_f[19] && i_pc_f[18];
wire w_txt_en = !i_pc_f[20] && i_pc_f[19] && !i_pc_f[18];

assign o_exception_code_f = 
    ( i_pc_f[1:0] !=2'b00 )?`E_FETCH_ADDR_MISALIGNED:
    (i_opcode_f!=`OP_R_TYPE                          &&
      i_opcode_f!=`OP_I_TYPE_LW                      &&
      i_opcode_f!=`OP_I_TYPE_ADDI                    &&
      i_opcode_f!=`OP_I_TYPE_JALR                    &&
      i_opcode_f!=`OP_S_TYPE                         &&
      i_opcode_f!=`OP_J_TYPE                         &&
      i_opcode_f!=`OP_B_TYPE_BEQ                     &&
      i_opcode_f!=`OP_U_TYPE                         &&
      i_opcode_f!=`OP_NOP                            &&
      (!i_trap_permission && (i_opcode_f == `OP_I_TYPE_CSR)  ) || // invalid opcode
      (i_pc_f[20])                                                    || // pc access outside the instruction mem
      (!i_trap_permission  && w_tv_en)     ||
      (!i_reset_permission && w_rv_en)  )  ?`E_ILLEGAL_INSTR:`NO_E; // am comentat pc states ptc inca nu le-am stabilit
       // pc access outside the current allowed region


  assign o_exception_code_e=
      (!i_reset_permission && // isnt in reset
       i_reg_write_e            && // is a reg wr instr
       (!i_alu_out_e[20] ||        // the value written isnt an addr in stack segm
         i_alu_out_e[19] ||     
        !i_alu_out_e[18])       &&
       i_rd_e == `sp          // the destination is the stack pointer reg
       )?`E_SP_OUT_OF_RANGE:

    ( i_res_src_e == 2'b01 &&
      i_alu_out_e[1:0]!=2'b00)?`E_LOAD_ADDR_MISALIGNED:

    ( i_res_src_e == 2'b01 &&
      !i_alu_out_e[20] )?`E_LOAD_ACCESS_FAULT:

    ( i_mem_write_e &&
      i_alu_out_e[1:0]!=2'b00)?`E_STORE_ADDR_MISALIGNED:

    ( i_mem_write_e &&
      !i_alu_out_e[20] )?`E_STORE_ADDR_FAULT:`NO_E; 
    
endmodule