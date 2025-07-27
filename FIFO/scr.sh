iverilog -o target.out FIFO.v assert.v tb.v; vvp target.out; rm waveform.vcd; rm target.out
