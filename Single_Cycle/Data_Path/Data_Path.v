module Data_Path(
    input i_clk,
    input i_rst,

    input [1:0] i_res_src,
    input [1:0] i_pc_src,
    input [2:0] i_alu_op,
    input i_reg_wr,
    input i_mem_wr,
    input [1:0] i_imm_ctl,
    input i_alu_src_b,
    input i_clk_enable,

    output [6:0] o_opcode,
    output o_f7_bit6,
    output [2:0] o_f3,
    output o_zero,

    output [31:0] o_mem_location_32h
);

    wire [31:0] w_pc_in;
    wire [31:0] w_pc_out;
    PC PC_Inst(.i_clk(i_clk),
               .i_clk_enable(i_clk_enable),
               .i_rst(i_rst),
               .i_next_pc(w_pc_in),
               .o_pc(w_pc_out));

    wire [31:0] w_mem_instruction_out;
    Mem_Instruction Mem_Instruction_Inst(.i_rst(i_rst),
                                         .i_pc(w_pc_out),
                                         .o_instr(w_mem_instruction_out));
    
    assign o_opcode = w_mem_instruction_out[6:0];
    assign o_f7_bit6 = w_mem_instruction_out[30];
    assign o_f3 = w_mem_instruction_out[14:12];


    wire [31:0] w_regs_data_in;
    wire [31:0] w_regs_data_out_1;
    wire [31:0] w_regs_data_out_2;
    Reg_File Reg_File_Inst(.i_clk(i_clk),
                           .i_clk_enable(i_clk_enable),
                           .i_rst(i_rst),
                           .i_reg_write(i_reg_wr),
                           .i_rd_addr_1(w_mem_instruction_out[19:15]),
                           .i_rd_addr_2(w_mem_instruction_out[24:20]),
                           .i_wr_addr(w_mem_instruction_out[11:7]),
                           .i_wr_data(w_regs_data_in),
                           .o_rd_data_1(w_regs_data_out_1),
                           .o_rd_data_2(w_regs_data_out_2));


    wire [31:0] w_extended_imm;
    Imm_32 Imm_32_Inst(.i_imm_ctl(i_imm_ctl),
                       .i_instr_bits(w_mem_instruction_out[31:7]),
                       .o_extended_imm(w_extended_imm));

    wire [31:0] w_alu_op_b;
    assign w_alu_op_b = (i_alu_src_b==1'b0)? w_regs_data_out_2:w_extended_imm;


    wire w_zero;
    assign o_zero = w_zero;
    wire [31:0] w_alu_data_out;
    ALU_Main ALU_Main_Inst(.i_op_a(w_regs_data_out_1),
                           .i_op_b(w_alu_op_b),
                           .i_alu_op(i_alu_op),
                           .o_zero(w_zero),
                           .o_alu_out(w_alu_data_out));

    wire [31:0] w_pc_plus_4;
    assign w_pc_plus_4 = w_pc_out+32'd4;

    wire [31:0] w_pc_plus_imm;
    assign w_pc_plus_imm = w_pc_out+w_extended_imm;

    // assign w_pc_in = (i_pc_src==1'b0)?w_pc_plus_4:w_pc_plus_imm;

    assign w_pc_in = (i_pc_src==2'b00)?w_pc_plus_4: // normal
                     (i_pc_src==2'b01)?w_pc_plus_imm: // jal or branch
                     (i_pc_src==2'b10)?w_alu_data_out:32'b0; // jalr



    wire [31:0] w_mem_data_out;
    Mem_Data Mem_Data_Inst(.i_clk(i_clk),
                           .i_clk_enable(i_clk_enable),
                           .i_rst(i_rst),
                           .i_mem_write(i_mem_wr),
                           .i_mem_addr(w_alu_data_out),
                           .i_mem_data(w_regs_data_out_2),
                           .o_mem_data(w_mem_data_out),
                           .o_mem_location_32h(o_mem_location_32h));


    assign w_regs_data_in = (i_res_src==2'b00)?w_alu_data_out:
                            (i_res_src==2'b01)?w_mem_data_out:
                            (i_res_src==2'b10)?w_pc_plus_4:32'b0;

endmodule