module Control_Unit(
    input [6:0] i_opcode,

    output [1:0] o_result_src,
    output o_mem_write,
    output o_reg_write,
    output o_jmp,
    output o_branch,
    output [1:0] o_alu_op,
    output o_alu_src,
    output [1:0] o_imm_src
);

    assign                    {o_result_src , o_mem_write , o_reg_write , o_jmp , o_branch , o_alu_op , o_alu_src , o_imm_src} = 
    (i_opcode == 7'b011_0011)?{    2'b00    ,     1'b0    ,    1'b1     ,  1'b0 ,    1'b0  ,   2'b10  ,    1'b0   ,    2'bxx }: // r type
    (i_opcode == 7'b000_0011)?{    2'b01    ,     1'b0    ,    1'b1     ,  1'b0 ,    1'b0  ,   2'b00  ,    1'b1   ,    2'b00 }: // i type (lw)
    (i_opcode == 7'b001_0011)?{    2'b00    ,     1'b0    ,    1'b1     ,  1'b0 ,    1'b0  ,   2'b00  ,    1'b1   ,    2'b00 }: // i type (addi)
    (i_opcode == 7'b110_0111)?{    2'b10    ,     1'b0    ,    1'b1     ,  1'b1 ,    1'b0  ,   2'b00  ,    1'b1   ,    2'b00 }: // i type (jalr)
    (i_opcode == 7'b010_0011)?{    2'bxx    ,     1'b1    ,    1'b0     ,  1'b0 ,    1'b0  ,   2'b00  ,    1'b1   ,    2'b01 }: // s type (sw)
    (i_opcode == 7'b110_1111)?{    2'b10    ,     1'b0    ,    1'b1     ,  1'b1 ,    1'b0  ,   2'bxx  ,    1'bx   ,    2'b11 }: // j type (jal)
    (i_opcode == 7'b110_0011)?{    2'bxx    ,     1'b0    ,    1'b0     ,  1'b0 ,    1'b1  ,   2'b01  ,    1'b0   ,    2'b10 }: // b type (beq)
    11'b0;



endmodule