// Transmit Data Register

module tdr #(
    parameter DATA_SIZE = 7
) (
    input[DATA_SIZE-1:0] d_i,
    input pl,
    input res,
    input clk,

    input tx_busy,
    output reg tx_start,
    
    output[DATA_SIZE-1:0] d_o
);

    reg[DATA_SIZE-1:0] data;
    assign d_o = data;


    always@(posedge clk)
    begin
        if(res) begin data<=0; end
        else if( pl && !tx_busy)
        begin
            data<=d_i;
            tx_start<=1'b1;
        end
        else
        begin
            tx_start<=1'b0;
        end
    end


endmodule