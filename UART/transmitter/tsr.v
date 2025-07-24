// Transmit Shift Register

module tsr #(
    parameter DATA_SIZE = 7
    // packet will be START(1) - DATA(7) - END_BIT(1)
)(
    input clk,
    input reset,
    input[DATA_SIZE-1:0] d_i,
    input bit_tick,
    output reg tx_busy,
    input tx_start,
    // transmission complete

    output reg data_out
);

    reg[DATA_SIZE-1:0] data;
    reg[1:0] cs;
    reg[1:0] ns;

    reg data_out_next;

    reg bit_tick_prev;
    wire bit_tick_posedge;
    assign bit_tick_posedge = (!bit_tick_prev && bit_tick);

    
    localparam WAITING = 2'b00;
    localparam START = 2'b01;
    localparam DATA = 2'b10;
    localparam FINISHED = 2'b11;

    reg[3:0] bit_idx;

    always@(posedge clk)
    begin
        if(reset)
        begin
            data <= 0;
            bit_idx<=0;
            cs <=WAITING;
            tx_busy<=0;
            data_out_next<=1'b0;
        end
        else
        begin
            bit_tick_prev<=bit_tick;

            cs<=ns;
            tx_busy<=(cs!=WAITING);
            data_out<=data_out_next;
            if(ns == START && cs==WAITING) begin data<=d_i; end
            if(cs == DATA && bit_tick_posedge) begin bit_idx <= bit_idx+1; end
            else if(ns==WAITING && cs!=WAITING) begin bit_idx<=0; end
        end
    end




    always@(*)
    begin
        data_out_next=1'b1;

        ns=cs;
        
        
        case(cs)
            WAITING:
            begin
                if(tx_start) begin 
                 ns = START; 
                end
            end
            START:
            begin
                data_out_next=1'b0;
                if(bit_tick_posedge) begin ns=DATA; end
            end
            DATA:
            begin
                data_out_next=data[bit_idx];
                if(bit_tick_posedge)
                begin
                    if(bit_idx == DATA_SIZE-1)
                    begin
                        ns=FINISHED;
                    end
                    else begin ns = DATA; end 
                end
            end

            FINISHED:
            begin
                data_out_next=1'b1;
                if(bit_tick_posedge) begin ns=WAITING; end
            end
            default: ns=WAITING;
        endcase
    end



endmodule