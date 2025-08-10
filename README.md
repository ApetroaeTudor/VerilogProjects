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

## 4. RISC-V Single Cycle
Single Cycle CPU: Executes each instruction in one clock cycle.<br>
<br>
Goal: Understanding the split between the Data Path and the control path.<br>
<br>
Key Characteristics:<br>
-> ISA: RV32I<br>
-> Separate data memory and instruction memory (Harvard Architecture)<br>
![Block diagram](./Single_Cycle/Others/SingleCycle.png)
<br>
Execution Flow:<br>
-> Fetch: Read instruction from memory at the address from PC<br>
-> Decode: Identify opcode, source and destination registers, and the imm field<br>
-> Execute: Perform ALU operation or compute branch addr<br>
-> Memory Access: Load/Store data<br>
-> Write Back: Store result to register file<br>
-> Update PC<br>
<br>
Advantages:<br>
-> Easy to design and understand<br>
Disadvantages:<br>
-> Cycle time = Slowest instruction (lw)<br>
-> Not scalable for more complex cpu designs<br>
<br>
Supported instructions:<br>
-> R type (add, sub, or, etc)<br>
-> I type (lw, addi, jalr, etc)<br>
-> S type (sw)<br>
-> B type (jal)<br>
<br>
The design is tested using testbenches and simulations, and synthesized/implemented on a Sipeed Tang Nano 9k FPGA board.<br>
For testing purposes, the code programmed into the instruction memory waits for 5 seconds and then turns a led off.<br>
Initially, the cpu stays in a reset state, until an enable button is pressed. The button signal on the board is active low.<br>
The button signal goes through 3 different modules, before being used in the TOP module. (Button Press -> Debounce -> Sync -> One Period).<br>
The code increments the data at a specific memory location every 8 clock cycles.<br>
<br>
![Simulation for the Verilog code](./Single_Cycle/Others/Simulation_Waveform.png)
<br>
![Schematic general view](./Single_Cycle/Others/SchematicGeneralView.webp)
<br>