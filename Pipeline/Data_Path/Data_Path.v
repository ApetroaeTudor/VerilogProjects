module Data_Path(
    input i_clk,
    input i_rst,
    input i_clk_en,

    input i_pc_wr_en_h,
    input i_if_id_flush_h,
    input i_if_id_stall_h,
    input i_id_ex_flush_h,

    input [1:0] i_fw_a_e,
    input [1:0] i_fw_b_e,
    input i_fw_a_d,
    input i_fw_b_d,

    // -----------------------------------------
    // input [1:0] i_pc_src_e, // 00 - pcp4, 01 - imm, 10 - rs1+imm
    input i_reg_write_d,
    input [1:0] i_result_src_d,
    input i_mem_write_d,
    input i_jmp_d,
    input i_branch_d,
    input [2:0] i_alu_ctl_d,
    input i_alu_src_d,
    input [1:0] i_imm_src_d, // outputs from Control Path
    // -----------------------------------------

    output [6:0] o_opcode_d,
    output [2:0] o_f3_d,
    output o_f7_b6_d,


    output [4:0] o_rs1_d,
    output [4:0] o_rs2_d,
    output [4:0] o_rs1_e,
    output [4:0] o_rs2_e,
    output [4:0] o_rd_e,
    output [4:0] o_rd_m,
    output [4:0] o_rd_w,

    output o_res_src_b0_e,
    output [1:0] o_pc_src_e

);

    wire [31:0] w_pc_in_f;
    wire [31:0] w_pc_out_f;
    wire [31:0] w_pc_p4_f;


    wire [31:0] w_instr_d;
    wire [31:0] w_pc_d;
    wire [31:0] w_pc_p4_d;
    wire [31:0] w_imm_32b_d;
    wire [31:0] w_regs_do1_d;
    wire [31:0] w_regs_do2_d;
    wire [31:0] w_haz_do1_d;
    wire [31:0] w_haz_do2_d;
    

    
    wire [31:0] w_alu_out_e;
    wire [4:0] w_rs1_e;
    wire [4:0] w_rs2_e;
    wire [4:0] w_rd_e;
    wire [31:0] w_pc_p4_e;
    wire [31:0] w_imm_32b_e;
    wire [31:0] w_regs_do1_e;
    wire [31:0] w_regs_do2_e;
    wire w_reg_write_e;
    wire [1:0] w_result_src_e;
    wire w_mem_write_e;
    wire w_jmp_e;
    wire w_branch_e;
    wire [2:0] w_alu_ctl_e;
    wire w_alu_src_e;
    wire [31:0] w_haz_rs1_e;
    wire [31:0] w_haz_rs2_e;
    wire [31:0] w_alu_op_b_e;
    wire w_zero_e;
    wire [6:0] w_opcode_e;
    wire [1:0] w_pc_src_e;


    wire [31:0] w_alu_out_m;
    wire [4:0] w_rd_m;
    wire [31:0] w_haz_b_m;
    wire [31:0] w_pc_p4_m;
    wire w_reg_wr_m;
    wire [1:0] w_result_src_m;
    wire w_mem_write_m;
    wire [31:0] w_mem_out_m;



    wire [4:0] w_rd_w;    
    wire [31:0] w_result_w;
    wire w_reg_write_w;
    wire [31:0] w_alu_out_w;
    wire [31:0] w_mem_out_w;
    wire [31:0] w_pc_p4_w;
    wire [1:0] w_result_src_w;


    // IF ------------------------------------------------------------

   
    PC PC_Inst(.i_clk(i_clk),
               .i_clk_en(i_clk_en),
               .i_wr_en(i_pc_wr_en_h),
               .i_rst(i_rst),
               .i_di(w_pc_in_f),
               .o_do(w_pc_out_f));



    assign w_pc_p4_f = w_pc_out_f + 32'd4;


    assign w_pc_in_f = (w_pc_src_e == 2'b00)?w_pc_p4_f: // pcp4;
                       (w_pc_src_e == 2'b01)?w_imm_32b_e: // imm
                       (w_pc_src_e == 2'b10)?w_alu_out_e:32'b0; // rs1+imm


    wire [31:0] w_instr_f;
    Mem_Instr Mem_Instr_Inst(.i_rst(i_rst),
                             .i_adr(w_pc_out_f),
                             .o_instr(w_instr_f));


    // ~IF ------------------------------------------------------------

    

    IF_ID IF_ID_Inst(.i_clk(i_clk),
                     .i_rst(i_rst),
                     .i_clk_en(i_clk_en),
                     .i_if_id_stall(i_if_id_stall_h),
                     .i_if_id_flush(i_if_id_flush_h),
                     .i_instr_f(w_instr_f),
                     .i_pc_p4_f(w_pc_p4_f),
                     .o_instr_d(w_instr_d),
                     .o_pc_p4_d(w_pc_p4_d));

    // ID ------------------------------------------------------------

    assign o_opcode_d = w_instr_d[6:0]; 
    assign o_f3_d = w_instr_d[14:12];
    assign o_f7_b6_d = w_instr_d[30];


    Reg_File Reg_File_Inst(.i_clk(i_clk),
                           .i_clk_enable(i_clk_en),
                           .i_rst(i_rst),
                           .i_reg_write(w_reg_write_w),
                           .i_rd_addr_1(w_instr_d[19:15]),
                           .i_rd_addr_2(w_instr_d[24:20]),
                           .i_wr_addr(w_rd_w),
                           .i_wr_data(w_result_w),
                           .o_rd_data_1(w_regs_do1_d),
                           .o_rd_data_2(w_regs_do2_d));

    Imm_32 Imm_32_Inst(.i_imm_ctl(i_imm_src_d),
                       .i_instr_bits(w_instr_d[31:7]),
                       .o_extended_imm(w_imm_32b_d));

    assign o_rs1_d = w_instr_d[19:15];
    assign o_rs2_d = w_instr_d[24:20];

    // ~ID ------------------------------------------------------------



    assign w_haz_do1_d = (i_fw_a_d == 1'b0)?w_regs_do1_d:w_result_w;
    assign w_haz_do2_d = (i_fw_b_d == 1'b0)?w_regs_do2_d:w_result_w;
    ID_EX ID_EX_Inst(.i_clk(i_clk),
                     .i_rst(i_rst),
                     .i_clk_en(i_clk_en),
                     .i_id_ex_flush(i_id_ex_flush_h),
                     
                     .i_rs1_d(w_instr_d[19:15]),
                     .i_rs2_d(w_instr_d[24:20]),
                     .i_rd_d(w_instr_d[11:7]),
                     .i_pc_p4_d(w_pc_p4_d),
                     .i_imm32_d(w_imm_32b_d),
                     .i_regs_do1_d(w_haz_do1_d),
                     .i_regs_do2_d(w_haz_do2_d),
                        
                     .i_reg_wr_d(i_reg_write_d),
                     .i_result_src_d(i_result_src_d),
                     .i_mem_write_d(i_mem_write_d),
                     .i_jmp_d(i_jmp_d),
                     .i_branch_d(i_branch_d),
                     .i_alu_ctl_d(i_alu_ctl_d),
                     .i_alu_src_d(i_alu_src_d),
                     .i_opcode_d(w_instr_d[6:0]),
                     
                     .o_rs1_e(w_rs1_e),
                     .o_rs2_e(w_rs2_e),
                     .o_rd_e(w_rd_e),
                     .o_pc_p4_e(w_pc_p4_e),
                     .o_imm32_e(w_imm_32b_e),
                     .o_regs_do1_e(w_regs_do1_e),
                     .o_regs_do2_e(w_regs_do2_e),
                     
                     .o_reg_wr_e(w_reg_write_e),
                     .o_result_src_e(w_result_src_e),
                     .o_mem_write_e(w_mem_write_e),
                     .o_jmp_e(w_jmp_e),
                     .o_branch_e(w_branch_e),
                     .o_alu_ctl_e(w_alu_ctl_e),
                     .o_alu_src_e(w_alu_src_e),
                     .o_opcode_e(w_opcode_e));

    // EX ------------------------------------------------------------

    assign o_res_src_b0_e = w_result_src_e[0];
    assign o_pc_src_e = w_pc_src_e;

    assign o_rs1_e = w_rs1_e;
    assign o_rs2_e = w_rs2_e;
    assign o_rd_e = w_rd_e;

    assign w_haz_rs1_e = (i_fw_a_e==2'b01)?w_result_w:
                         (i_fw_a_e==2'b10)?w_alu_out_m:w_regs_do1_e;
    assign w_haz_rs2_e = (i_fw_b_e==2'b01)?w_result_w:
                         (i_fw_b_e==2'b10)?w_alu_out_m:w_regs_do2_e;
    assign w_alu_op_b_e = (w_alu_src_e==1'b0)?w_haz_rs2_e:w_imm_32b_e;


    assign w_pc_src_e =
    ((w_zero_e && w_branch_e) || (w_jmp_e && w_opcode_e == 7'b110_1111)) ? 2'b01:
    (w_jmp_e && w_opcode_e == 7'b110_0111)?2'b10:
    2'b00; 

    ALU_Main ALU_Main_Inst(.i_op_a(w_haz_rs1_e),
                           .i_op_b(w_alu_op_b_e),
                           .i_alu_op(w_alu_ctl_e),
                           .o_zero(w_zero_e),
                           .o_alu_out(w_alu_out_e));

    // ~EX ------------------------------------------------------------

    EX_MEM EX_MEM_Inst(.i_clk(i_clk),
                       .i_rst(i_rst),
                       .i_clk_en(i_clk_en),
                       
                       .i_rd_e(w_rd_e),
                       .i_alu_out_e(w_alu_out_e),
                       .i_haz_b_e(w_haz_rs2_e),
                       .i_pc_p4_e(w_pc_p4_e),
                       
                       .i_reg_wr_e(w_reg_write_e),
                       .i_result_src_e(w_result_src_e),
                       .i_mem_write_e(w_mem_write_e),
                       
                       .o_rd_m(w_rd_m),
                       .o_alu_out_m(w_alu_out_m),
                       .o_haz_b_m(w_haz_b_m),
                       .o_pc_p4_m(w_pc_p4_m),
                       .o_reg_wr_m(w_reg_wr_m),
                       .o_result_src_m(w_result_src_m),
                       .o_mem_write_m(w_mem_write_m));

    // MEM ------------------------------------------------------------

    Mem_Data Mem_Data_Inst(.i_clk(i_clk),
                           .i_clk_enable(i_clk_en),
                           .i_rst(i_rst),
                           .i_mem_write(w_mem_write_m),
                           .i_mem_addr(w_alu_out_m),
                           .i_mem_data(w_haz_b_m),
                           .o_mem_data(w_mem_out_m));

    assign o_rd_m = w_rd_m;

    // ~MEM ------------------------------------------------------------

    MEM_WB MEM_WB_Inst(.i_clk(i_clk),
                       .i_rst(i_rst),
                       .i_clk_en(i_clk_en),
                       
                       .i_alu_out_m(w_alu_out_m),
                       .i_mem_out_m(w_mem_out_m),
                       .i_rd_m(w_rd_m),
                       .i_pc_p4_m(w_pc_p4_m),
                       .i_reg_wr_m(w_reg_wr_m),
                       .i_result_src_m(w_result_src_m),
                       
                       .o_alu_out_w(w_alu_out_w),
                       .o_mem_out_w(w_mem_out_w),
                       .o_rd_w(w_rd_w),
                       .o_pc_p4_w(w_pc_p4_w),
                       .o_reg_wr_w(w_reg_write_w),
                       .o_result_src_w(w_result_src_w));

    // w ------------------------------------------------------------


    assign w_result_w = 
    (w_result_src_w==2'b00)?w_alu_out_w:
    (w_result_src_w==2'b01)?w_mem_out_w:
    (w_result_src_w==2'b10)?w_pc_p4_w:32'b0;

    assign o_rd_w = w_rd_w;

    // ~w ------------------------------------------------------------









endmodule