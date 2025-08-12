module Imm_32(
    input [1:0] i_imm_ctl,
    // 00 - I type
    // 01 - S type
    // 10 - B type
    // 11 - J type
    input [24:0] i_instr_bits,

    output [31:0] o_extended_imm
);

    assign o_extended_imm = 
    (i_imm_ctl==2'b00)? { {20{i_instr_bits[24]}},i_instr_bits[24:13]}:
    (i_imm_ctl==2'b01)? { {20{i_instr_bits[24]}},i_instr_bits[24:18],i_instr_bits[4:0]}:
    (i_imm_ctl==2'b10)? { {20{i_instr_bits[24]}},i_instr_bits[0],i_instr_bits[23:18],i_instr_bits[4:1],1'b0}:
    (i_imm_ctl==2'b11)? { {12{i_instr_bits[24]}},i_instr_bits[12:5],i_instr_bits[13],i_instr_bits[23:14],1'b0}: 32'b0;

endmodule