module MEM_WB(
    input i_clk,
    input i_rst,
    input i_clk_en,

    input [31:0] i_alu_out_m,
    input [31:0] i_mem_out_m,
    input [4:0] i_rd_m,
    input [31:0] i_pc_p4_m,

    input i_reg_wr_m,
    input [1:0] i_result_src_m,

    output [31:0] o_alu_out_w,
    output [31:0] o_mem_out_w,
    output [4:0] o_rd_w,
    output [31:0] o_pc_p4_w,

    output o_reg_wr_w,
    output [1:0] o_result_src_w
);
    reg [31:0] r_alu_out_m;
    assign o_alu_out_w = r_alu_out_m;

    reg [31:0] r_mem_out_m;
    assign o_mem_out_w = r_mem_out_m;

    reg [4:0] r_rd_m;
    assign o_rd_w = r_rd_m;

    reg [31:0] r_pc_p4_m;
    assign o_pc_p4_w = r_pc_p4_m;

    reg r_reg_wr_m;
    assign o_reg_wr_w = r_reg_wr_m;

    reg [1:0] r_result_src_m;
    assign o_result_src_w = r_result_src_m;

    always@(posedge i_clk)
    begin
        if(i_rst)
        begin
            r_alu_out_m<=0;
            r_mem_out_m<=0;
            r_rd_m<=0;
            r_pc_p4_m<=0;

            r_reg_wr_m<=0;
            r_result_src_m<=0;
        end
        else if(i_clk_en)
        begin
            r_alu_out_m<=i_alu_out_m;
            r_mem_out_m<=i_mem_out_m;
            r_rd_m<=i_rd_m;
            r_pc_p4_m<=i_pc_p4_m;

            r_reg_wr_m<=i_reg_wr_m;
            r_result_src_m<=i_result_src_m;
        end
    end

endmodule