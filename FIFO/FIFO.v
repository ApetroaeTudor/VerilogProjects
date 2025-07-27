module FIFO #(
    parameter WIDTH=8,
    parameter DEPTH=16,
    parameter ALMOST_FLAG_PERCENTAGE = 20 // a the almost empty/full flag will be set when the memory is 20% full or 80%
)(
    input i_clk,
    input i_rst,

    input i_rd_en,
    output [WIDTH-1:0] o_rd_data,
    output o_rd_valid,

    input i_wr_en,
    input [WIDTH-1:0] i_wr_data,
    output o_wr_valid,

    output o_f_flag,
    output o_e_flag,
    output o_af_flag,
    output o_ae_flag,


    output [$clog2(DEPTH)-1:0] o_count
);

    reg[WIDTH-1:0] mem[DEPTH-1:0];

    reg [$clog2(DEPTH)-1:0] r_rd_addr;
    reg [$clog2(DEPTH)-1:0] r_wr_addr;
    reg [$clog2(DEPTH)-1:0] r_count; // how many fields are occupied in the fifo
    assign o_count = r_count;

    reg r_wr_valid;
    assign o_wr_valid = r_wr_valid;
    reg r_rd_valid;
    assign o_rd_valid = r_rd_valid;



    reg [WIDTH-1:0] r_rd_data;
    assign o_rd_data = r_rd_data;

    assign o_f_flag = (r_count==(DEPTH-1) );
    assign o_e_flag = (r_count==0);
    localparam lower = (ALMOST_FLAG_PERCENTAGE*DEPTH)/100;
    localparam upper = ( (100-ALMOST_FLAG_PERCENTAGE) * DEPTH )/100;

    assign o_ae_flag = (r_count <= lower );
    assign o_af_flag = (r_count >= upper );




    always@(posedge i_clk)
    begin
        if(i_rst)
        begin
            r_rd_data<=0;
            r_rd_addr<=0;
            r_wr_addr<=0;
            r_count<=0;  
            r_wr_valid<=0;
            r_rd_valid<=0;      
        end
        else
        begin
            if(i_rd_en)
            begin
                if(r_rd_addr!== (DEPTH-1) ) r_rd_addr<=r_rd_addr+1;
                else r_rd_addr<=0;
            end
            else if(i_wr_en)
            begin
                if(r_wr_addr!=(DEPTH-1)) r_wr_addr<=r_wr_addr+1;
            end

            if(i_rd_en==1'b1 && i_wr_en==1'b0 )
            begin
                if(r_count!=0) r_count<=r_count-1;
            end
            else if(i_rd_en==1'b0 && i_wr_en==1'b1)
            begin
                if(r_count!=DEPTH-1) r_count<=r_count+1;
            end

            if(i_wr_en && !o_f_flag)
            begin
                r_wr_valid<=1'b1;
                mem[r_wr_addr]<=i_wr_data;
            end
            else r_wr_valid<=1'b0;
            
            if(i_rd_en && !o_e_flag)
            begin
                r_rd_valid<=1'b1;
                r_rd_data<=mem[r_rd_addr];
            end
            else r_rd_valid<=1'b0;
        end
    end


endmodule