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

## 3. Basic VGA output
In the simple_480p module the pixel position data is generated using internal counters. Here the hsync and vsync signals are also generated, when the pixel position is in the sync region. When the pixel position is inside the active range, the data enable signal is asserted.<br>
Two IP blocks are used: <br>
1. PLL block which generates a 270MHZ serial clock signal (from a 27MHZ base), and also a divided 27MHZ pixel clock signal. These are used in TMDS encoding (for the 8b/10b algorithm).<br>
2. DVI TX block, with ELVDS outputs for the color channels and the clock signal.<br>

What i learned: <br>
-> The fundamentals of the HDMI protocol, TMDS encoding and the benefits of data serialization/deserialization.<br>
-> The difference between true LVDS and emulated LVDS. The FPGA board I used doesn't have true LVDS pins and instead the DVI TX block emulates this logic using general purpose pins instead.<br>
-> How basic video output is generated, how color data is generated and sent to the display, what sync signals are.<br>

