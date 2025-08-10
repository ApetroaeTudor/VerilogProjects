module Control_Unit(
    input [6:0] i_opcode,

    output [1:0] o_res_src,
    output o_j,
    output o_b,
    output [1:0] o_alu_ctl,
    output o_reg_wr,
    output o_mem_wr,
    output [1:0] o_imm_ctl,
    output o_alu_src_b
);

    assign {o_res_src , o_j , o_b , o_alu_ctl , o_reg_wr , o_mem_wr , o_imm_ctl , o_alu_src_b} = 
    (i_opcode==7'b011_0011)?{2'b00 , 1'b0 , 1'b0 , 2'b10 , 1'b1 , 1'b0 , 2'bxx , 1'b0}: // r type
    (i_opcode==7'b001_0011)?{2'b00 , 1'b0 , 1'b0 , 2'b00 , 1'b1 , 1'b0 , 2'b00 , 1'b1}: // i type - addi
    (i_opcode==7'b000_0011)?{2'b01 , 1'b0 , 1'b0 , 2'b00 , 1'b1 , 1'b0 , 2'b00 , 1'b1}: // i type - lw
    (i_opcode==7'b010_0011)?{2'bxx , 1'b0 , 1'b0 , 2'b00 , 1'b0 , 1'b1 , 2'b01 , 1'b1}: // s stype - sw
    (i_opcode==7'b110_0011)?{2'bxx , 1'b0 , 1'b1 , 2'b01 , 1'b0 , 1'b0 , 2'b10 , 1'b0}: // b type - beq
    (i_opcode==7'b110_1111)?{2'b10 , 1'b1 , 1'b0 , 2'bxx , 1'b1 , 1'b0 , 2'b11 , 1'bx}: // j type - jal
    (i_opcode==7'b110_0111)?{2'b10 , 1'b1 , 1'b0 , 2'b00 , 1'b1 , 1'b0 , 2'b00 , 1'b1}: // i type = jalr 
    11'bx;

endmodule