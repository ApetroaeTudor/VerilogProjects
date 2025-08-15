`include "Constants.vh"
module PC(
    input i_clk,
    input i_clk_en,
    input i_wr_en,
    input i_rst,
    input [31:0] i_di,

    output [31:0] o_do
);


    reg [31:0] r_pc = 0;
    assign o_do = r_pc;

    always@(posedge i_clk)
    begin
        if(i_rst)
        begin
            r_pc<=`RESET_LO;
        end
        else if(i_clk_en)
        begin
            if(i_wr_en)
            begin
                r_pc<=i_di;
            end
        end
    end
endmodule