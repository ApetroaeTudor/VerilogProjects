// Receiver Shift Register

module rsr #(
    parameter DATA_SIZE = 7,
    parameter OVERSAMPLE = 16
)(
    input clk,
    input reset,
    output reg [DATA_SIZE-1:0] d_o,
    input bit_tick,
    input sample_tick,
    input bit_tick_one_and_half,
    input receive_line,


    input data_read_ack,
    output reg data_ready,
    output reg frame_error

);
    reg[DATA_SIZE-1:0] data;
    reg[1:0] cs;
    reg[1:0] ns;

    reg sample_tick_prev;
    wire sample_tick_posedge;
    assign sample_tick_posedge = (!sample_tick_prev && sample_tick);

    reg bit_tick_prev;
    wire bit_tick_posedge;
    assign bit_tick_posedge = (!bit_tick_prev && bit_tick);

    reg bit_tick_one_and_half_prev;
    wire bit_tick_one_and_half_posedge;
    assign bit_tick_one_and_half_posedge = (!bit_tick_one_and_half_prev && bit_tick_one_and_half);



    localparam WAITING = 2'b00;
    localparam START = 2'b01;
    localparam DATA = 2'b10;
    localparam FINISHED = 2'b11;

    reg[$clog2(DATA_SIZE):0] bit_idx;
    reg[3:0] sample_cnt;
    reg[4:0] sample_sum;

    reg receive_line_sync;
    reg receive_line_meta;
    always@(posedge clk)
    begin
        {receive_line_sync,receive_line_meta}<={receive_line_meta,receive_line};
    end


    always@(posedge clk)
    begin
        if(reset)
        begin
            d_o<=0;
            data<=0;
            bit_idx<=0;
            cs<=WAITING;
            sample_cnt<=0;
            sample_sum<=0;
            data_ready<=0;
            frame_error<=0;
        end
        else begin
            sample_tick_prev<=sample_tick;
            bit_tick_prev<=bit_tick;
            bit_tick_one_and_half_prev<=bit_tick_one_and_half;

            cs<=ns;
            if(cs == DATA && sample_tick_posedge)
            begin
                sample_cnt<=sample_cnt+1;
                sample_sum<=sample_sum+receive_line_sync;

                if(sample_cnt == (OVERSAMPLE-1))
                begin
                    data[bit_idx]<= (sample_sum>OVERSAMPLE/2)? 1'b1:1'b0;
                    bit_idx<=bit_idx+1;
                    sample_sum<=0;
                end
            end
            case(cs)
            START:
            begin
                sample_cnt<=0;
                sample_sum<=0;
            end
            FINISHED:
            begin
                if(bit_tick_posedge)
                begin
                    frame_error<=!receive_line_sync;
                    data_ready<=1'b1;
                    if(receive_line_sync)
                        d_o<=data;
                end
            end
            WAITING:
            begin
                if(data_read_ack)
                begin
                    data_ready<=1'b0;
                    bit_idx<=1'b0;
                end
            end
            endcase
        end

    end

    always@(*)
    begin
        ns=cs;
        case(cs)
        WAITING:
        begin
            if(receive_line_sync==1'b0) begin ns=START; end
        end
        START:
        begin
            if(bit_tick_one_and_half_posedge) begin ns = DATA; end
        end
        DATA:
        begin
            if(bit_tick_posedge)
            begin
                if(bit_idx == DATA_SIZE)
                begin
                    ns=FINISHED;
                end
                else begin ns = DATA; end
            end
        end
        FINISHED:
        begin
            if(bit_tick_posedge) begin ns = WAITING; end
        end
        default: ns=WAITING;
        endcase

    end

endmodule