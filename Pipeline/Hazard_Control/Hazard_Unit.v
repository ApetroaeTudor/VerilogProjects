module Hazard_Unit(
    input [4:0] i_rs1_d,
    input [4:0] i_rs2_d,
    input [4:0] i_rs1_e,
    input [4:0] i_rs2_e,

    input [4:0] i_rd_e,
    input [4:0] i_rd_m,
    input [4:0] i_rd_wb,
    input i_res_src_b0_e, // 1=>lw
    input [1:0] i_pc_src_e, // 01=> branch taken


    output [1:0] o_fw_a_e, 
    output [1:0] o_fw_b_e,
    output o_fw_a_d,
    output o_fw_b_d,

    output o_if_id_flush, // 
    output o_if_id_stall,
    output o_id_ex_flush,
    output o_pc_stall
);

    assign o_fw_a_e = 
    ((i_rs1_e == i_rd_m)  && (i_rs1_e!=5'b0))?2'b10: // alu_out_m
    ((i_rs1_e == i_rd_wb) && (i_rs1_e!=5'b0))?2'b01: // res_wb
    2'b00; // normal

    assign o_fw_b_e = 
    ((i_rs2_e == i_rd_m)  && (i_rs2_e!=5'b0))?2'b10:
    ((i_rs2_e == i_rd_wb) && (i_rs2_e!=5'b0))?2'b01:
    2'b00;

    assign o_fw_a_d =
    ((i_rs1_d == i_rd_wb) &&(i_rs1_d!=5'b0))?1'b1: // res_wb_d
    1'b0; // normal

    assign o_fw_b_d =
    ((i_rs2_d == i_rd_wb) &&(i_rs2_d!=5'b0))?1'b1:
    1'b0;


    wire w_lw_stall;
    assign w_lw_stall =
    (i_res_src_b0_e && ((i_rs1_d == i_rd_e) || (i_rs2_d == i_rd_e)) )?1'b1:1'b0;
    assign o_if_id_stall = w_lw_stall;
    assign o_pc_stall = w_lw_stall;


    assign o_if_id_flush = (i_pc_src_e == 2'b01)?1'b1:1'b0;
    assign o_id_ex_flush = ((i_pc_src_e == 2'b01) || w_lw_stall )?1'b1:1'b0;



endmodule