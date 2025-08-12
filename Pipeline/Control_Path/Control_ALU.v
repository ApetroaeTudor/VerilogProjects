module Control_ALU(
    input [1:0] i_alu_op,
    input [2:0] i_f3,
    input i_f7_b6,

    output [2:0] o_alu_ctl
);

    assign o_alu_ctl =
    (i_alu_op == 2'b00)? 3'b000:
    (i_alu_op == 2'b01)? 3'b001:
    (i_alu_op == 2'b10)? 
                        ((i_f3 == 3'b000)?( (i_f7_b6 == 1'b0 )?3'b000:   // add
                                            (i_f7_b6 == 1'b1 )?3'b001:3'b000 ): // sub
                         (i_f3 == 3'b010)?3'b101: // slt
                         (i_f3 == 3'b110)?3'b011: // or
                         (i_f3 == 3'b111)?3'b010:3'b000 // and
                        ): 3'b000;


endmodule