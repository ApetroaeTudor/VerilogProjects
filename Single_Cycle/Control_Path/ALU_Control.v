module ALU_Control(
    input [1:0] i_alu_ctl,

    input [2:0] i_f3,
    input i_f7_bit6,

    output [2:0] o_alu_op
);

    assign o_alu_op=
    (i_alu_ctl==2'b00)?3'b000:
    (i_alu_ctl==2'b01)?3'b001:
    (i_alu_ctl==2'b10)?(
                    (i_f3==3'b111)?3'b010:
                    (i_f3==3'b110)?3'b011:
                    (i_f3==3'b010)?3'b101:
                    (i_f7_bit6==1'b1)?3'b001:
                    (i_f7_bit6==1'b0)?3'b000:3'b000
                      ):3'b000;

endmodule