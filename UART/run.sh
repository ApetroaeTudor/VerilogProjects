#!/bin/bash

iverilog -o target.out ./common/br_gen.v ./receiver/rdr.v ./receiver/rsr.v ./receiver/rx.v ./transmitter/tdr.v ./transmitter/tsr.v ./transmitter/tx.v UART.v ./testbenches/uart_double_tb.v
vvp target.out
gtkwave waveform.vcd

rm target.out
