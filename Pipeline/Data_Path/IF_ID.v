module IF_ID(
    input i_clk,
    input i_rst,
    input i_clk_en,
    
    input i_if_id_stall,
    input i_if_id_flush,

    input [31:0] i_instr_f,
    input [31:0] i_pc_p4_f,

    output [31:0] o_instr_d,
    output [31:0] o_pc_p4_d
);

    reg [31:0] r_instr;
    assign o_instr_d = r_instr;
    reg [31:0] r_pc_p4;
    assign o_pc_p4_d = r_pc_p4;

    always@(posedge i_clk)
    begin
        if(i_rst||i_if_id_flush)
        begin
            r_instr<=0;
            r_pc_p4<=0;
        end
        else
        begin
            if(i_clk_en && !i_if_id_stall)
            begin
                r_instr<=i_instr_f;
                r_pc_p4<=i_pc_p4_f;
            end
        end
    end


endmodule