module Mem_Data(
    input i_clk,
    input i_clk_enable,
    input i_rst,
    input i_mem_write,
    input [31:0] i_mem_addr,
    input [31:0] i_mem_data,
    output [31:0] o_mem_data,

    output [31:0] o_mem_location_32h

);

    reg [7:0] r_mem_data [128:0];
    // assign o_mem_data[7:0] = r_mem_data[i_mem_addr];
    // assign o_mem_data[15:8] = r_mem_data[i_mem_addr+1];
    // assign o_mem_data[23:16] = r_mem_data[i_mem_addr+2];
    // assign o_mem_data[31:24] = r_mem_data[i_mem_addr+3];

    assign {o_mem_data[7:0] , o_mem_data[15:8] , o_mem_data[23:16] , o_mem_data[31:24] } = 
           {r_mem_data[i_mem_addr] , r_mem_data[i_mem_addr+1] , r_mem_data[i_mem_addr+2] , r_mem_data[i_mem_addr+3]};


    assign {o_mem_location_32h[7:0] , o_mem_location_32h[15:8] , o_mem_location_32h[23:16] , o_mem_location_32h[31:24] } = 
           {r_mem_data[50] , r_mem_data[51] , r_mem_data[52] , r_mem_data[53]};


    always@(posedge i_clk)
    begin
        if(i_rst)
        begin
            // data mem
            r_mem_data[32'h03] <= 8'h03; r_mem_data[32'h02] <= 8'h02; r_mem_data[32'h01] <= 8'h01; r_mem_data[32'h00] <= 8'h00; 
            r_mem_data[32'h07] <= 8'h07; r_mem_data[32'h06] <= 8'h06; r_mem_data[32'h05] <= 8'h05; r_mem_data[32'h04] <= 8'h04;
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