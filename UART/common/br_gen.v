// Baud Rate d_iv generator

module br_gen #(
    parameter CLK_FREQ_HZ = 50_000_000,
    parameter BAUD_RATE = 960000,
    parameter OVERSAMPLE = 16
)(
    input clk,
    input reset,
    output bit_tick,
    output sample_tick,
    output bit_tick_one_and_half
);

    localparam integer BIT_CYCLES = (CLK_FREQ_HZ + BAUD_RATE/2) / BAUD_RATE; // upper aprox
    localparam integer SAMPLE_CYCLES = (BIT_CYCLES + OVERSAMPLE/2) / OVERSAMPLE;
    localparam integer BIT_CYCLES_ONE_AND_HALF = (BIT_CYCLES + BIT_CYCLES/2);

    reg[$clog2(BIT_CYCLES)-1:0] baud_counter;
    reg[$clog2(SAMPLE_CYCLES)-1:0] sample_counter;
    reg[$clog2(BIT_CYCLES_ONE_AND_HALF)-1:0] baud_counter_and_half;

    assign bit_tick = (baud_counter == BIT_CYCLES-1);
    assign sample_tick = (sample_counter == SAMPLE_CYCLES - 1);
    assign bit_tick_one_and_half = (baud_counter_and_half == BIT_CYCLES_ONE_AND_HALF - 1);

    always @(posedge clk or posedge reset) begin
        if(reset) begin baud_counter<=0; sample_counter<=0; baud_counter_and_half<=0;  end
        else begin
       
            if(bit_tick) baud_counter <=0;
            else baud_counter<=baud_counter+1;

            if(sample_tick) sample_counter<=0;
            else sample_counter<= sample_counter+1;

            if(bit_tick_one_and_half) baud_counter_and_half<=0;
            else baud_counter_and_half<=baud_counter_and_half+1;
       
        end
    end





endmodule