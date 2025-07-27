# Verilog Practice Projects

## 1. UART_tx_rx
Asynchronous data transmission between a transmitter and a receiver module.<br>
Bits are sent and received using a Baud Rate Generator.<br>
What I learned: <br>
-> UART protocol basics: data framing, start/stop bits, asynchronous data transfer.<br>
-> Transmit/Receive data pipelines(tdr/tsr and rsr/rdr).<br>
-> Unit testing is very important, testing after all code is written is a bad idea.<br>
-> Modular design is useful for easier an easier testing phase.<br>

## 2. FIFO parameterized memory
Data is stored/read starting from lower addresses.<br>
What I learned: <br>
-> The importance of handshake and validity signaling(read valid, write valid).<br>
-> The importance of status flags and thresholds(empty/full, almost empty/full).<br>
-> Better synthesizable logic(no latches, for loops, ).<br>
-> Better RTL simulation techniques, such as: assertions, more test cases, repeat blocks.<br>

