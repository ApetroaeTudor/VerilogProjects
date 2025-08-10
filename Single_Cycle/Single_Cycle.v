module Single_Cycle(
    input i_enable_btn_d_s_o, // debounced + synced + one period
    input i_clk,
    input i_rst_n, // reset is active on 0

    output [31:0] o_mem_location_32h


);  

    reg r_clock_enable = 1'b0;

    // if the cpu isnt enabled, it stays in a reset state
    wire w_rst;
    assign w_rst = (r_clock_enable==1'b0)?1'b1:~i_rst_n;

    always@(posedge i_clk)
    begin
        if(i_enable_btn_d_s_o)
        begin
            r_clock_enable<=~r_clock_enable;
        end
    end


    wire [6:0] w_opcode;
    wire [2:0] w_f3;
    wire w_zero;
    wire w_f7_bit6;

    wire [1:0] w_res_src;
    wire [1:0] w_pc_src;
    wire [2:0] w_alu_op;
    wire w_reg_wr;
    wire w_mem_wr;
    wire [1:0] w_imm_ctl;
    wire w_alu_src_b;


    Control_Path Control_Path_Inst(.i_opcode(w_opcode),
                                   .i_f3(w_f3),
                                   .i_zero(w_zero),
                                   .i_f7_bit6(w_f7_bit6),
                                   .o_res_src(w_res_src),
                                   .o_pc_src(w_pc_src),
                                   .o_alu_op(w_alu_op),
                                   .o_reg_wr(w_reg_wr),
                                   .o_mem_wr(w_mem_wr),
                                   .o_imm_ctl(w_imm_ctl),
                                   .o_alu_src_b(w_alu_src_b));

    wire [31:0] w_reg_5;
    Data_Path Data_Path_Inst(.i_clk(i_clk),
                             .i_clk_enable(r_clock_enable),
                             .i_rst(w_rst),
                             .i_res_src(w_res_src),
                             .i_pc_src(w_pc_src),
                             .i_alu_op(w_alu_op),
                             .i_reg_wr(w_reg_wr),
                             .i_mem_wr(w_mem_wr),
                             .i_imm_ctl(w_imm_ctl),
                             .i_alu_src_b(w_alu_src_b),
                             .o_opcode(w_opcode),
                             .o_f7_bit6(w_f7_bit6),
                             .o_f3(w_f3),
                             .o_zero(w_zero),
                             .o_mem_location_32h(o_mem_location_32h));





endmodule