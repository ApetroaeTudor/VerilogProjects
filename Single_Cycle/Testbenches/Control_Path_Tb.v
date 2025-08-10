module Control_Path_Tb;
reg [6:0] t_r_opcode;
reg t_r_f7_bit6;
reg [2:0] t_r_f3;
reg t_r_zero;

wire [1:0] t_w_res_src;
wire [1:0] t_w_pc_src;
wire [2:0] t_w_alu_op;
wire t_w_reg_wr;
wire t_w_mem_wr;
wire [1:0] t_w_imm_ctl;
wire t_w_alu_src_b;


Control_Path DUT(.i_opcode(t_r_opcode),
                 .i_f3(t_r_f3),
                 .i_zero(t_r_zero),
                 .i_f7_bit6(t_r_f7_bit6),
                 .o_res_src(t_w_res_src),
                 .o_pc_src(t_w_pc_src),
                 .o_alu_op(t_w_alu_op),
                 .o_reg_wr(t_w_reg_wr),
                 .o_mem_wr(t_w_mem_wr),
                 .o_imm_ctl(t_w_imm_ctl),
                 .o_alu_src_b(t_w_alu_src_b));

initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0,Control_Path_Tb);
    t_r_zero=1'b0;


    t_r_opcode = 7'b011_0011; // r type
    t_r_f3 = 3'b000;
    t_r_f7_bit6=1'b0; // add
    #10
    t_r_f7_bit6=1'b1; // sub
    #10
    t_r_f3 = 3'b010; // slt
    #10
    t_r_f3 = 3'b110; // or
    #10
    t_r_f3 = 3'b111; // and
    #10
    t_r_opcode = 7'b001_0011; // addi
    #10
    t_r_opcode = 7'b000_0011; // lw
    #10
    t_r_opcode = 7'b010_0011; // sw
    #10
    t_r_opcode = 7'b110_0011; // beq // branch not taken
    #10
    t_r_zero = 1'b1; // beq //  branch taken
    #10
    t_r_opcode = 7'b110_1111; // jal

    #100
    $finish;


end


endmodule