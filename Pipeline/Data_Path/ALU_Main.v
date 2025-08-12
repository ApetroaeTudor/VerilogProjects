module ALU_Main(
    input [31:0] i_op_a,
    input [31:0] i_op_b,

    input [2:0] i_alu_op,

    output o_zero,

    output [31:0] o_alu_out
);

// 000 - add
// 001 - sub
// 010 - and
// 011 - or
// 101 - slt

assign o_zero = ((i_op_a-i_op_b) == 0)?1:0;

assign o_alu_out = (i_alu_op==3'b000)?(i_op_a+i_op_b):
                   (i_alu_op==3'b001)?(i_op_a-i_op_b):
                   (i_alu_op==3'b010)?(i_op_a&i_op_b):
                   (i_alu_op==3'b011)?(i_op_a|i_op_b):
                   (i_alu_op==3'b101)?((i_op_a<i_op_b)?32'd1:32'd0):32'dx;



endmodule