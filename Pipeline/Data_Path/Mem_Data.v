module Mem_Data(
    input i_clk,
    input i_clk_enable,
    input i_rst,
    input i_mem_write,
    input [31:0] i_mem_addr,
    input [31:0] i_mem_data,
    output [31:0] o_mem_data

);

    reg [7:0] r_mem_data [128:0];

    assign {o_mem_data[7:0] , o_mem_data[15:8] , o_mem_data[23:16] , o_mem_data[31:24] } = 
           {r_mem_data[i_mem_addr] , r_mem_data[i_mem_addr+1] , r_mem_data[i_mem_addr+2] , r_mem_data[i_mem_addr+3]};


    always@(posedge i_clk)
    begin
        if(i_rst)
        begin
            // data mem
            r_mem_data[32'h03] <= 8'h03; r_mem_data[32'h02] <= 8'h02; r_mem_data[32'h01] <= 8'h01; r_mem_data[32'h00] <= 8'h00; 
            r_mem_data[32'h07] <= 8'h07; r_mem_data[32'h06] <= 8'h06; r_mem_data[32'h05] <= 8'h05; r_mem_data[32'h04] <= 8'h04;

            r_mem_data[32'h0b] <= 8'h0b; r_mem_data[32'h0a] <= 8'h0a; r_mem_data[32'h09] <= 8'h09; r_mem_data[32'h08] <= 8'h08;

            r_mem_data[19] <= 8'h19; r_mem_data[18] <= 8'h18; r_mem_data[17] <= 8'h17; r_mem_data[16] <= 8'h16;




            r_mem_data[32'h19] <= 8'hef; r_mem_data[32'h18] <= 8'hef; r_mem_data[32'h17] <= 8'hcd; r_mem_data[32'h16] <= 8'hab;

        end
        else if(i_clk_enable)
        begin
            if(i_mem_write)
            begin
                r_mem_data[i_mem_addr] <= i_mem_data[7:0];
                r_mem_data[i_mem_addr+1] <= i_mem_data[15:8];
                r_mem_data[i_mem_addr+2] <= i_mem_data[23:16];
                r_mem_data[i_mem_addr+3] <= i_mem_data[31:24];
            end
        end

    end

endmodule