module Reg_File(
    input i_clk,
    input i_clk_enable,
    input i_rst,
    input i_reg_write,

    input [4:0] i_rd_addr_1,
    input [4:0] i_rd_addr_2,
    input [4:0] i_wr_addr,

    input [31:0] i_wr_data,
    
    output [31:0] o_rd_data_1,
    output [31:0] o_rd_data_2
);



    reg [31:0] r_registers [31:0];

    assign o_rd_data_1 = r_registers[i_rd_addr_1];
    assign o_rd_data_2 = r_registers[i_rd_addr_2];

    integer i;
    always@(posedge i_clk)
    begin
        if(i_rst)
        begin
            for(i=0;i<32;i=i+1)
            begin
                r_registers[i]<=32'b0;
            end
        end
        else if(i_clk_enable)
        begin
            if(i_reg_write)
            begin
                if(i_wr_addr!=0) 
                r_registers[i_wr_addr] <= i_wr_data;
            end
        end
    end

endmodule