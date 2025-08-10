module PC(
    input i_clk,
    input i_clk_enable,
    input i_rst,
    input [31:0] i_next_pc,
    output [31:0] o_pc
);
    reg [31:0] r_pc;

    assign o_pc = r_pc;

    always @(posedge i_clk)
    begin
        if(i_rst)
        begin
            r_pc <= 32'h64; // address of the first instuction in my program
        end
        else if(i_clk_enable)
        begin
            r_pc <= i_next_pc;
        end
        
    end


endmodule