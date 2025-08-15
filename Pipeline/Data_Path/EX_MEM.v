module EX_MEM(
    input i_clk,
    input i_rst,
    input i_clk_en,


    input [4:0] i_rd_e,
    input [31:0] i_alu_out_e,
    input [31:0] i_haz_b_e,
    input [31:0] i_pc_p4_e,

    input i_reg_wr_e,
    input [1:0] i_result_src_e,
    input i_mem_write_e,
    input [3:0] i_exception_code_e,

    output o_if_id_flush_exception_m,
    output o_id_ex_flush_exception_m,

    output [4:0] o_rd_m,
    output [31:0] o_alu_out_m,
    output [31:0] o_haz_b_m,
    output [31:0] o_pc_p4_m,
    output o_reg_wr_m,
    output [1:0] o_result_src_m,
    output o_mem_write_m
);



    // wire w_if_id_flush_exception_m;
    // wire w_id_ex_flush_exception_m;

    wire w_exception_ex_stage;
    assign w_exception_ex_stage = ((i_exception_code_e!=4'b1111))?1'b1:1'b0;

    assign o_if_id_flush_exception_m = w_exception_ex_stage;
    assign o_id_ex_flush_exception_m = w_exception_ex_stage;

    reg [4:0] r_rd_e;
    assign o_rd_m = r_rd_e;

    reg [31:0] r_alu_out_e;
    assign o_alu_out_m = r_alu_out_e;

    reg [31:0] r_haz_b_e;
    assign o_haz_b_m = r_haz_b_e;

    reg [31:0] r_pc_p4_e;
    assign o_pc_p4_m = r_pc_p4_e;

    reg r_reg_wr_e;
    assign o_reg_wr_m = r_reg_wr_e;

    reg [1:0] r_result_src_e;
    assign o_result_src_m = r_result_src_e;

    reg r_mem_write_e;
    assign o_mem_write_m = r_mem_write_e;

    always@(posedge i_clk)
    begin
        if(i_rst || w_exception_ex_stage )
        begin
            r_rd_e<=0;
            r_alu_out_e<=0;
            r_haz_b_e<=0;
            r_pc_p4_e<=0;
            r_reg_wr_e<=0;
            r_result_src_e<=0;
            r_mem_write_e<=0;
        end
        else if(i_clk_en)
        begin
            r_rd_e<=i_rd_e;
            r_alu_out_e<=i_alu_out_e;
            r_haz_b_e<=i_haz_b_e;
            r_pc_p4_e<=i_pc_p4_e;
            r_reg_wr_e<=i_reg_wr_e;
            r_result_src_e<=i_result_src_e;
            r_mem_write_e<=i_mem_write_e;
        end
    end

endmodule