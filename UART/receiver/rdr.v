// Receiver Data Register

module rdr #(
    parameter DATA_SIZE = 7
)(
    input[DATA_SIZE-1:0] d_i,
    input res,
    input clk,

    output reg data_read_ack,
    input data_ready,
    input frame_error,
    output [DATA_SIZE-1:0] d_o
);
    assign d_o = data_out;
    reg[DATA_SIZE-1:0] data_out;

    always@(posedge clk)
    begin
        if(res)
        begin
            data_read_ack<=1'b0;
            data_out<=0;
        end
        else
        begin
            data_read_ack<=1'b0;
            if(data_ready && !frame_error)
            begin
                data_out<=d_i;
                data_read_ack<=1'b1;
            end
        end
    end

endmodule